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

# Remove all existing sections from the body (Pending Tasks, Completed Tasks, Unit Test Results)
sed -i '/<body>/,/<\/body>/ { /<section>/,/<\/section>/d }' /app/index.html

# Add the Pending Tasks section
cat <<EOF >> /app/index.html
<body>
    <section>
        <h2>Pending Tasks</h2>
        <ul id="pending">
            <li>ToDo Tasks:</li>
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
</body>
</html>
EOF

# Configure Git to use GitHub Actions user and email
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

# Add the modified index.html to git, commit, and push the changes
git add index.html
git commit -m "Update index.html with new task and test data"
git push
