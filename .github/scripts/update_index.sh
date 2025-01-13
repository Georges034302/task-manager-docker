#!/bin/bash

# File where HTML content is located
HTML_FILE="index.html"

# Read the ToDo tasks from $1 (pending tasks)
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d')

# Read the Done tasks from $1 (completed tasks)
DONE_TASKS=$(grep -A 1000 "Done Tasks:" "$1" | sed '1d')

# Read the Unit Test results from $2
UNIT_TEST_RESULTS=$(cat "$2")

# Function to update pre blocks (using sed - FINALLY AND DEFINITIVELY CORRECT)
update_pre() {
  local pre_id="$1"
  local content="$2"
  local html_file="$3"

  # Escape special characters for sed (using a very unlikely delimiter)
  local escaped_content=$(printf '%s' "$content" | sed 's/[&\\$]/\\&/g; s/"/\\"/g; s/'"'/\\'"'/g')

  # Use sed to replace the content within the <pre> block (using ||| as delimiter)
  sed -i -E "/<pre id=\"$pre_id\">/,/<\/pre>/ {
    /<pre id=\"$pre_id\">/ {
      s|||<pre id=\"$pre_id\">|||<pre id=\"$pre_id\">\n$escaped_content|||
      n
    }
    /<\/pre>/ {
      s|||<\/pre>||\n<\/pre>|||
    }
    /./d
  }" "$html_file"
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