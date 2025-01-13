#!/bin/bash

# Check if index.html exists
if [[ ! -f /app/index.html ]]; then
    echo "Error: /app/index.html not found. Exiting."
    exit 1
fi

# Read content from the todo output and test output
TODO_CONTENT=$(cat "$1" 2>/dev/null || echo "No tasks available.")
TEST_CONTENT=$(cat "$2" 2>/dev/null || echo "No unit test results available.")

# Backup the original index.html
cp /app/index.html /app/index.html.bak

# Update the Pending Tasks section
sed -i "/<ul id=\"pending\">/ { 
    r /dev/stdin
    d
}" /app/index.html <<< "$TODO_CONTENT"

# Update the Completed Tasks section (modify the content as needed)
sed -i "/<ul id=\"completed\">/ { 
    r /dev/stdin
    d
}" /app/index.html <<< "<li>Add Login UI</li><li>Fix UI Bug</li><li>Write Tests</li>"

# Update the Unit Test Results section
sed -i "/<pre id=\"unittest\">/ { 
    r /dev/stdin
    d
}" /app/index.html <<< "$TEST_CONTENT"

# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
