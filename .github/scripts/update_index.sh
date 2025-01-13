#!/bin/bash

# File where HTML content is located
HTML_FILE="index.html"

# Read the ToDo tasks from $1 (pending tasks)
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d')

# Read the Done tasks from $1 (completed tasks)
DONE_TASKS=$(grep -A 1000 "Done Tasks:" "$1" | sed '1d')

# Read the Unit Test results from $2
UNIT_TEST_RESULTS=$(cat "$2")

# Use awk to add <li> tags around each task for Pending Tasks
awk -v tasks="$TODO_TASKS" -v html_file="$HTML_FILE" '
FNR==NR {
    if ($0 ~ /<ul id="pending">/) {
        print
        split(tasks, task_array, "\n")
        for (i in task_array) {
            print "<li>" task_array[i] "</li>"
        }
    } else {
        print
    }
    next
}
{ print }
' "$HTML_FILE" "$HTML_FILE" > "$HTML_FILE".tmp && mv "$HTML_FILE".tmp "$HTML_FILE"

# Use awk to add <li> tags around each task for Completed Tasks
awk -v tasks="$DONE_TASKS" -v html_file="$HTML_FILE" '
FNR==NR {
    if ($0 ~ /<ul id="completed">/) {
        print
        split(tasks, task_array, "\n")
        for (i in task_array) {
            print "<li>" task_array[i] "</li>"
        }
    } else {
        print
    }
    next
}
{ print }
' "$HTML_FILE" "$HTML_FILE" > "$HTML_FILE".tmp && mv "$HTML_FILE".tmp "$HTML_FILE"

# Use awk to replace Unit Test Results
awk -v results="$UNIT_TEST_RESULTS" -v html_file="$HTML_FILE" '
FNR==NR {
    if ($0 ~ /<pre id="unittest">/) {
        print
        print results
    } else {
        print
    }
    next
}
{ print }
' "$HTML_FILE" "$HTML_FILE" > "$HTML_FILE".tmp && mv "$HTML_FILE".tmp "$HTML_FILE"


# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
