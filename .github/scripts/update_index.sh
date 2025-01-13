#!/bin/bash

# File where HTML content is located
HTML_FILE="index.html"

# Read the ToDo tasks from $1 (pending tasks)
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d' | sed 's/^/<li>/;s/$/<\/li>/')

# Read the Done tasks from $1 (completed tasks)
DONE_TASKS=$(grep -A 1000 "Done Tasks:" "$1" | sed '1d' | sed 's/^/<li>/;s/$/<\/li>/')

# Read the Unit Test results from $2
UNIT_TEST_RESULTS=$(cat "$2")

# Backup the original HTML file to prevent data loss
cp "$HTML_FILE" "$HTML_FILE.bak"

# Replace the Pending Tasks section with ToDo tasks
# The sed command here will replace the <ul id="pending"> section and its contents
sed -i "/<ul id=\"pending\">/,/<\/ul>/c\\
<ul id=\"pending\">\\
$TODO_TASKS\\
</ul>" "$HTML_FILE"

# Replace the Completed Tasks section with Done tasks
# The sed command here will replace the <ul id="completed"> section and its contents
sed -i "/<ul id=\"completed\">/,/<\/ul>/c\\
<ul id=\"completed\">\\
$DONE_TASKS\\
</ul>" "$HTML_FILE"

# Replace the Unit Test Results section with the actual test results
# The sed command here will replace the <pre id="unittest"> section and its contents
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
