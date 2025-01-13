#!/bin/bash

# File where HTML content is located
HTML_FILE="index.html"

# Read the ToDo tasks from $1 (pending tasks)
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d')

# Read the Done tasks from $1 (completed tasks)
DONE_TASKS=$(grep -A 1000 "Done Tasks:" "$1" | sed '1d')

# Read the Unit Test results from $2
UNIT_TEST_RESULTS=$(cat "$2")

# Function to update pre blocks (using awk)
update_pre() {
  local pre_id="$1"
  local content="$2"
  local html_file="$3"

  awk -v pre_id="$pre_id" -v content="$content" '
    BEGIN { in_pre = 0 }
    {
      if ($0 ~ "<pre id=\"" pre_id "\">") {
        print  # Print the opening <pre> tag
        split(content, lines, "\n")
        for (i in lines) {
          if (lines[i] != "") {
            printf "%s\n", lines[i] # Print each line with a newline
          }
        }
        in_pre = 1
        next
      }
      if (in_pre && $0 ~ /<\/pre>/) {
        print  # Print the closing </pre> tag
        in_pre = 0
        next
      }
      print  # Print all other lines
    }
  ' "$html_file" > "$html_file".tmp && mv "$html_file".tmp "$html_file"
}

# Use the function to update all pre blocks
update_pre "pending" "$TODO_TASKS" "$HTML_FILE"
update_pre "completed" "$DONE_TASKS" "$HTML_FILE"
update_pre "unittest" "$UNIT_TEST_RESULTS" "$HTML_FILE"

# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
