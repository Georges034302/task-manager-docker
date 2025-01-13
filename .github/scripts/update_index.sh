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

# Replace the Pending Tasks section with ToDo tasks (do not remove the section)
awk -v tasks="$TODO_TASKS" '
  /<ul id="pending">/ { 
    print "<ul id=\"pending\">"; 
    print tasks; 
    next;
  }
  /<\/ul>/ { print "</ul>"; next }
  { print }
' "$HTML_FILE.bak" > "$HTML_FILE"

# Replace the Completed Tasks section with Done tasks (ensure the <ul id="completed"> section exists)
awk -v tasks="$DONE_TASKS" '
  /<ul id="completed">/ { 
    print "<ul id=\"completed\">"; 
    print tasks; 
    next;
  }
  /<\/ul>/ { print "</ul>"; next }
  { print }
' "$HTML_FILE" > "$HTML_FILE.tmp" && mv "$HTML_FILE.tmp" "$HTML_FILE"

# Replace the Unit Test Results section with the actual test results
awk -v results="$UNIT_TEST_RESULTS" '
  /<pre id="unittest">/ { 
    print "<pre id=\"unittest\">"; 
    print results; 
    next;
  }
  /<\/pre>/ { print "</pre>"; next }
  { print }
' "$HTML_FILE" > "$HTML_FILE.tmp" && mv "$HTML_FILE.tmp" "$HTML_FILE"

# Configure Git and push changes
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

git add index.html
git commit -m "Update index.html with new task and test data"
git push
