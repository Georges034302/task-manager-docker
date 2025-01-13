#!/bin/bash

# Check if index.html exists
if [[ ! -f /app/index.html ]]; then
    echo "Error: /app/index.html not found. Exiting."
    exit 1
fi

# Read content from the todo output and test output
TODO_CONTENT=$(cat "$1" 2>/dev/null || echo "No tasks available.")
TEST_CONTENT=$(cat "$2" 2>/dev/null || echo "No unit test results available.")

# Temporary backup of the original index.html file
cp /app/index.html /app/index.html.bak

# Update the Pending Tasks section
sed -i '/<section>\s*<h2>Pending Tasks<\/h2>/,/<\/section>/d' /app/index.html
cat <<EOF >> /app/index.html
<section>
    <h2>Pending Tasks</h2>
    <ul id="pending">
        $(echo "$TODO_CONTENT" | sed 's/^/<li>/;s/$/<\/li>/')
    </ul>
</section>
EOF

# Update the Completed Tasks section
sed -i '/<section>\s*<h2>Completed Tasks<\/h2>/,/<\/section>/d' /app/index.html
cat <<EOF >> /app/index.html
<section>
    <h2>Completed Tasks</h2>
    <ul id="completed">
        <li>Add Login UI</li>
        <li>Fix UI Bug</li>
        <li>Write Tests</li>
    </ul>
</section>
EOF

# Update the Unit Test Results section
sed -i '/<section>\s*<h2>Unit Test Results<\/h2>/,/<\/section>/d' /app/index.html
cat <<EOF >> /app/index.html
<section>
    <h2>Unit Test Results</h2>
    <pre id="unittest">
        $(echo "$TEST_CONTENT")
    </pre>
</section>
EOF

# Configure Git to use GitHub Actions user and email
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

# Add the modified index.html to git, commit, and push the changes
git add index.html
git commit -m "Update index.html with new task and test data"
git push
