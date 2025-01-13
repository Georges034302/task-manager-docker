#!/bin/bash

# File where HTML content is located
HTML_FILE="index.html"

# Read the ToDo tasks from $1 (pending tasks)
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d')

# Read the Done tasks from $1 (completed tasks)
DONE_TASKS=$(grep -A 1000 "Done Tasks:" "$1" | sed '1d')

# Read the Unit Test results from $2
UNIT_TEST_RESULTS=$(cat "$2")

# Function to escape special characters for sed
escape_sed() {
  echo "$1" | sed 's/[&/\]/\\&/g'
}

# Escape the tasks and results to handle special characters
TODO_TASKS_ESCAPED=$(escape_sed "$TODO_TASKS")
DONE_TASKS_ESCAPED=$(escape_sed "$DONE_TASKS")
UNIT_TEST_RESULTS_ESCAPED=$(escape_sed "$UNIT_TEST_RESULTS")

# Use sed to replace the content inside <pre id="pending"> with tasks wrapped in <li>
# Replace the pending tasks section
sed -i "/<pre id=\"pending\">/,/<\/pre>/c\\
<pre id=\"pending\">\n$(echo "$TODO_TASKS_ESCAPED" | sed 's/$/<li>&<\/li>/')\n</pre>" "$HTML_FILE"

# Replace the Completed Tasks section with Done tasks, keeping the <pre> structure
sed -i "/<pre id=\"completed\">/,/<\/pre>/c\\
<pre id=\"completed\">\n$(echo "$DONE_TASKS_ESCAPED" | sed 's/$/<li>&<\/li>/')\n</pre>" "$HTML_FILE"

# Replace the Unit Test Results section with the actual test results, no <li> needed
sed -i "/<pre id=\"unittest\">/,/<\/pre>/c\\
<pre id=\"unittest\">\n$UNIT_TEST_RESULTS_ESCAPED\n</pre>" "$HTML_FILE"

# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
