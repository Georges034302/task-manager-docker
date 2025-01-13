#!/bin/bash

# File where HTML content is located
HTML_FILE="index.html"

# Read the ToDo tasks from $1 (pending tasks)
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d' | sed 's/^/<li>/;s/$/<\/li>/')

# Read the Unit Test results from $2
UNIT_TEST_RESULTS=$(cat "$2")

# Replace the Pending Tasks section with ToDo tasks
sed -i "/<ul id=\"pending\">/,/<\/ul>/c\<ul id=\"pending\">\n$TODO_TASKS\n</ul>" $HTML_FILE

# Replace the Unit Test Results section with the actual test results
sed -i "/<pre id=\"unittest\">/,/<\/pre>/c\<pre id=\"unittest\">\n$UNIT_TEST_RESULTS\n</pre>" $HTML_FILE

# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
