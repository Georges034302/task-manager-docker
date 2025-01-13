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

# Target sections by their ID and update the content
sed -i "/<ul id=\"pending\">/,/<\/ul>/c\\
            <ul id=\"pending\">\n\
            <li>ToDo Tasks:</li>\n\
            $(echo "$TODO_CONTENT" | sed 's/^/<li>/;s/$/<\/li>/')\n\
            </ul>" /app/index.html

sed -i "/<ul id=\"completed\">/,/<\/ul>/c\\
            <ul id=\"completed\">\n\
            <li>Add Login UI</li>\n\
            <li>Fix UI Bug</li>\n\
            <li>Write Tests</li>\n\
            </ul>" /app/index.html

sed -i "/<pre id=\"unittest\">/,/<\/pre>/c\\
            <pre id=\"unittest\">\n\
            $(echo "$TEST_CONTENT")\n\
            </pre>" /app/index.html

# Configure Git to use GitHub Actions user and email
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

# Add the modified index.html to git, commit, and push the changes
git add index.html
git commit -m "Update index.html with new task and test data"
git push
