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

# Clean up the old content
# Remove old task lists and test results
sed -i '/<section>\s*<h2>Pending Tasks<\/h2>/,/<\/section>/d' /app/index.html
sed -i '/<section>\s*<h2>Completed Tasks<\/h2>/,/<\/section>/d' /app/index.html
sed -i '/<section>\s*<h2>Unit Test Results<\/h2>/,/<\/section>/d' /app/index.html

# Create new Pending Tasks, Completed Tasks, and Unit Test Results sections
cat <<EOF > /tmp/new_content.html
<section>
    <h2>Pending Tasks</h2>
    <ul id="pending">
        $(echo "$TODO_CONTENT" | sed 's/^/<li>/;s/$/<\/li>/')
    </ul>
</section>

<section>
    <h2>Completed Tasks</h2>
    <ul id="completed">
        <li>Add Login UI</li>
        <li>Fix UI Bug</li>
        <li>Write Tests</li>
    </ul>
</section>

<section>
    <h2>Unit Test Results</h2>
    <pre id="unittest">
        $(echo "$TEST_CONTENT")
    </pre>
</section>
EOF

# Insert the new content into the HTML file after the <body> tag
sed -i "/<body>/r /tmp/new_content.html" /app/index.html

# Clean up the temporary content file
rm /tmp/new_content.html

# Configure Git to use GitHub Actions user and email
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

# Add the modified index.html to git, commit, and push the changes
git add index.html
git commit -m "Update index.html with new task and test data"
git push
