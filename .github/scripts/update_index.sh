#!/bin/bash

# File where HTML content is located
HTML_FILE="index.html"

# Read the ToDo tasks from $1 (pending tasks)
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d')

# Read the Done tasks from $1 (completed tasks)
DONE_TASKS=$(grep -A 1000 "Done Tasks:" "$1" | sed '1d')

# Read the Unit Test results from $2
UNIT_TEST_RESULTS=$(cat "$2")

# Function to update lists (pending and completed)
update_list() {
  local list_id="$1"
  local tasks="$2"
  local html_file="$3"

  awk -v list_id="$list_id" -v tasks="$tasks" '
    BEGIN { in_list = 0 }
    /<ul id="'list_id'">/ {
      print
      split(tasks, task_array, "\n")
      for (i in task_array) {
        if (task_array[i] != "") { # Skip empty lines
          print "<li>" task_array[i] "</li>"
        }
      }
      in_list = 1 # Set flag to prevent further processing within this <ul>
      next       # Skip the original closing </ul>
    }
    in_list && /<\/ul>/ {
        in_list=0
        next
    }
    !in_list { print } # Print all lines outside the target <ul>
  ' "$html_file" > "$html_file".tmp && mv "$html_file".tmp "$html_file"
}

# Function to update pre block (unit tests)
update_pre() {
  local pre_id="$1"
  local results="$2"
  local html_file="$3"

  awk -v pre_id="$pre_id" -v results="$results" '
    BEGIN { in_pre = 0 }
    /<pre id="'pre_id'">/ {
      print
      print results
      in_pre = 1
      next
    }
        in_pre && /<\/pre>/ {
                in_pre=0
                next
        }
    !in_pre { print }
  ' "$html_file" > "$html_file".tmp && mv "$html_file".tmp "$html_file"
}

# Use the functions
update_list "pending" "$TODO_TASKS" "$HTML_FILE"
update_list "completed" "$DONE_TASKS" "$HTML_FILE"
update_pre "unittest" "$UNIT_TEST_RESULTS" "$HTML_FILE"


# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
