#!/bin/bash

# File where HTML content is located
HTML_FILE="index.html"

# Read the ToDo tasks from $1 (pending tasks)
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d' | sed 's/^/<li>/;s/$/<\/li>/')

# Read the Unit Test results from $2
UNIT_TEST_RESULTS=$(cat "$2")

# Replace the Pending Tasks section with ToDo tasks
sed -i 's#<ul id="pending">.*</ul>#<ul id="pending">\
'"$TODO_TASKS"'\
</ul>#' $HTML_FILE

# Replace the Unit Test Results section with the actual test results
sed -i 's#<pre id="unittest">.*</pre>#<pre id="unittest">\
'"$UNIT_TEST_RESULTS"'\
</pre>#' $HTML_FILE

# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
