#!/bin/bash

# File where HTML content is located
HTML_FILE="index.html"

# Read the ToDo tasks from $1 (pending tasks)
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d' | sed 's/^/<li>/;s/$/<\/li>/')

# Read the Done tasks from $1 (completed tasks)
DONE_TASKS=$(grep -A 1000 "Done Tasks:" "$1" | sed '1d' | sed 's/^/<li>/;s/$/<\/li>/')

# Read the Unit Test results from $2
UNIT_TEST_RESULTS=$(cat "$2")

# Escape any special characters for use in sed (e.g., & and /)
TODO_TASKS=$(echo "$TODO_TASKS" | sed 's/[&/\]/\\&/g')
DONE_TASKS=$(echo "$DONE_TASKS" | sed 's/[&/\]/\\&/g')
UNIT_TEST_RESULTS=$(echo "$UNIT_TEST_RESULTS" | sed 's/[&/\]/\\&/g')

# Backup the original HTML file to prevent data loss
cp "$HTML_FILE" "$HTML_FILE.bak"

# Replace the Pending Tasks section with ToDo tasks
sed -i "/<ul id=\"pending\">/,/<\/ul>/c\\
<ul id=\"pending\">\\
$TODO_TASKS\\
</ul>" "$HTML_FILE"

# Replace the Completed Tasks section with Done tasks
sed -i "/<ul id=\"completed\">/,/<\/ul>/c\\
<ul id=\"completed\">\\
$DONE_TASKS\\
</ul>" "$HTML_FILE"

# Replace the Unit Test Results section with the actual test results
sed -i "/<pre id=\"unittest\">/,/<\/pre>/c\\
<pre id=\"unittest\">\\
$UNIT_TEST_RESULTS\\
</pre>" "$HTML_FILE"

# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
