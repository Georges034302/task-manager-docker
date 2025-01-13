#!/bin/bash

# Read content from the todo output and test output files
TODO_CONTENT=$(cat "$1" 2>/dev/null || echo "No tasks available.")
TEST_CONTENT=$(cat "$2" 2>/dev/null || echo "No unit test results available.")

# Extract ToDo tasks from the $1 file (Assuming ToDo tasks are marked with 'ToDo' label)
TODO_TASKS=$(echo "$TODO_CONTENT" | sed 's/^/<li>/;s/$/<\/li>/')

# Extract Done tasks from the $1 file (Assuming Done tasks are marked with 'Done' label)
DONE_TASKS=$(echo "$TODO_CONTENT" | sed 's/^/<li>/;s/$/<\/li>/')

# Extract Unit Test Results from the $2 file (Each result is assumed to be a line in the file)
TEST_RESULTS=$(echo "$TEST_CONTENT" | sed 's/^/<pre>/;s/$/<\/pre>/')

# Update the Pending Tasks section (only ToDo tasks, listed vertically)
sed -i "/<ul id=\"pending\">/ { 
    r /dev/stdin
    d
}" /app/index.html <<< "$TODO_TASKS"

# Update the Completed Tasks section (only Done tasks, listed vertically)
sed -i "/<ul id=\"completed\">/ { 
    r /dev/stdin
    d
}" /app/index.html <<< "$DONE_TASKS"

# Update the Unit Test Results section (listed vertically)
sed -i "/<pre id=\"unittest\">/ { 
    r /dev/stdin
    d
}" /app/index.html <<< "$TEST_RESULTS"

# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
