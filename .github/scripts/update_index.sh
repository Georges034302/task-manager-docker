#!/bin/bash

# Read content from the todo output and test output
TODO_CONTENT=$(cat "$1" 2>/dev/null || echo "No tasks available.")
TEST_CONTENT=$(cat "$2" 2>/dev/null || echo "No unit test results available.")

# Temporary backup of the original index.html file
cp /app/index.html /app/index.html.bak

# Remove the second body tag (if exists) and clean up any extra content
sed -i 's|</body>||g' /app/index.html
sed -i 's|<body>||g' /app/index.html

# Add the content to the existing body
sed -i "/<\/html>/i \
<body>\n\
    <section>\n\
        <h2>Pending Tasks</h2>\n\
        <ul id=\"pending\">\n\
            <li>ToDo Tasks:</li>\n\
            $(echo "$TODO_CONTENT" | sed 's/^/<li>/;s/$/<\/li>/')\n\
        </ul>\n\
    </section>\n\
    \n\
    <section>\n\
        <h2>Completed Tasks</h2>\n\
        <ul id=\"completed\">\n\
            <li>Add Login UI</li>\n\
            <li>Fix UI Bug</li>\n\
            <li>Write Tests</li>\n\
        </ul>\n\
    </section>\n\
    \n\
    <section>\n\
        <h2>Unit Test Results</h2>\n\
        <pre id=\"unittest\">\n\
            $(echo "$TEST_CONTENT")\n\
        </pre>\n\
    </section>\n\
</body>" /app/index.html

# Configure Git to use GitHub Actions user and email
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

# Add the modified index.html to git, commit, and push the changes
git add index.html
git commit -m "Update index.html with new task and test data"
git push
