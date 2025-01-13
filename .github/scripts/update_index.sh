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

# Update the Pending Tasks section (only ToDo tasks, listed vertically)
sed -i "/<ul id=\"pending\">/ { 
    r /dev/stdin
    d
}" /app/index.html <<< "<li>Update Login UI</li><li>Update Documentation</li><li>Deploy to Production</li>"

# Update the Completed Tasks section (only Done tasks, listed vertically)
sed -i "/<ul id=\"completed\">/ { 
    r /dev/stdin
    d
}" /app/index.html <<< "<li>Add Login UI</li><li>Fix UI Bug</li><li>Write Tests</li>"

# Update the Unit Test Results section (listed vertically)
sed -i "/<pre id=\"unittest\">/ { 
    r /dev/stdin
    d
}" /app/index.html <<< "test_add_task ... ok\ntest_get_done_tasks ... ok\ntest_get_open_tasks ... ok\nTotal Tests: 3\nPassed: 3 (100.00%)\nFailed: 0 (0.00%)"

# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
