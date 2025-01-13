#!/bin/bash

# File where HTML content is located
HTML_FILE="index.html"

# Read the ToDo tasks from $1 (pending tasks)
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d')

# Read the Done tasks from $1 (completed tasks)
DONE_TASKS=$(grep -A 1000 "Done Tasks:" "$1" | sed '1d')

# Read the Unit Test results from $2
UNIT_TEST_RESULTS=$(cat "$2")

# Use sed to add <li> tags around each task for Pending Tasks
sed -i -E "/<ul id=\"pending\">/,/<\/ul>/c\\
<ul id=\"pending\">\\
$(printf '%s\n' "$TODO_TASKS" | sed 's/.*/<li>&<\/li>/')\\
</ul>" "$HTML_FILE"

# Replace the Completed Tasks section with Done tasks, using sed to wrap each task in <li> tags
sed -i -E "/<ul id=\"completed\">/,/<\/ul>/c\\
<ul id=\"completed\">\\
$(printf '%s\n' "$DONE_TASKS" | sed 's/.*/<li>&<\/li>/')\\
</ul>" "$HTML_FILE"

# Replace the Unit Test Results section with the actual test results, no <li> needed for unit tests
sed -i -E "/<pre id=\"unittest\">/,/<\/pre>/c\\
<pre id=\"unittest\">\\
$(printf '%s' "$UNIT_TEST_RESULTS")\\
</pre>" "$HTML_FILE"


# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
