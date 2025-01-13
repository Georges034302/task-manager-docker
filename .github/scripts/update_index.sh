#!/bin/bash

HTML_FILE="index.html"

TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d')
DONE_TASKS=$(grep -A 1000 "Done Tasks:" "$1" | sed '1d')
UNIT_TEST_RESULTS=$(cat "$2")

# Function to update pre blocks (using awk)
update_pre() {
  local pre_id="$1"
  local content="$2"
  local html_file="$3"

  awk -v pre_id="$pre_id" -v content="$content" '
    {
      if ($0 ~ "<pre id=\"" pre_id "\">") {
        print  # Print the opening <pre> tag
        split(content, lines, "\n")
        for (i in lines) {
          if (lines[i] != "") {
            printf "%s\n", lines[i]
          }
        }
        while (getline) {
          if ($0 ~ /<\/pre>/) {
            print # Print the closing </pre> tag
            break # Exit the while loop
          } else {
            print
          }
        }
        next # Skip the rest of the main awk loop for this line
      }
      print  # Print all other lines outside the <pre> block
    }
  ' "$html_file" > "$html_file".tmp && mv "$html_file".tmp "$html_file"
}

update_pre "pending" "$TODO_TASKS" "$HTML_FILE"
update_pre "completed" "$DONE_TASKS" "$HTML_FILE"
update_pre "unittest" "$UNIT_TEST_RESULTS" "$HTML_FILE"

git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push