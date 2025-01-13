#!/bin/bash

# File where HTML content is located
HTML_FILE="index.html"

# Read the ToDo tasks from $1 (pending tasks)
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d' | sed 's/^/<li>/;s/$/<\/li>/')

# Read the Unit Test results from $2
UNIT_TEST_RESULTS=$(cat "$2")

# Escape special characters in the tasks and unit test results for sed
TODO_TASKS_ESCAPED=$(printf '%s' "$TODO_TASKS" | sed 's/[&/\]/\\&/g')
UNIT_TEST_RESULTS_ESCAPED=$(printf '%s' "$UNIT_TEST_RESULTS" | sed 's/[&/\]/\\&/g')

# Replace the Pending Tasks section with ToDo tasks
sed -i "/<ul id=\"pending\">/,/<\/ul>/c\\
<ul id=\"pending\">\\
$TODO_TASKS_ESCAPED\\
</ul>" $HTML_FILE

# Replace the Unit Test Results section with the actual test results
sed -i "/<pre id=\"unittest\">/,/<\/pre>/c\\
<pre id=\"unittest\">\\
$UNIT_TEST_RESULTS_ESCAPED\\
</pre>" $HTML_FILE

# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
