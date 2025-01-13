#!/bin/bash

# Read content from the todo output and test output
TODO_CONTENT=$(cat "$1" 2>/dev/null || echo "No tasks available.")
TEST_CONTENT=$(cat "$2" 2>/dev/null || echo "No unit test results available.")

# Update the Pending Tasks section
sed -i "/<ul id=\"pending\">/{
    r <(echo \"$TODO_CONTENT\" | sed 's/^/<li>/;s/$/<\/li>/')
    d
}" /app/index.html

# Update the Completed Tasks section
sed -i "/<ul id=\"completed\">/{
    r <(echo \"<li>Add Login UI</li><li>Fix UI Bug</li><li>Write Tests</li>\")
    d
}" /app/index.html

# Update the Unit Test Results section
sed -i "/<pre id=\"unittest\">/{
    r <(echo \"$TEST_CONTENT\")
    d
}" /app/index.html

# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
