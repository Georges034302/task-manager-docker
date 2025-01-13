#!/bin/bash

# Check if index.html exists
if [[ ! -f /app/index.html ]]; then
    echo "Error: /app/index.html not found. Exiting."
    exit 1
fi

# Read content from the todo output and test output
TODO_CONTENT=$(cat "$1" 2>/dev/null || echo "No tasks available.")
TEST_CONTENT=$(cat "$2" 2>/dev/null || echo "No unit test results available.")

# Split tasks into individual list items for Pending Tasks and Completed Tasks
PENDING_LIST=$(echo "$TODO_CONTENT" | grep -E '^ToDo Tasks:|^Update|^Deploy|^Documentation' | sed 's/^/ <li>/;s/$/<\/li>/')
COMPLETED_LIST=$(echo "$TODO_CONTENT" | grep -E '^Done Tasks:|^Add|^Fix|^Write' | sed 's/^/ <li>/;s/$/<\/li>/')

# Process Unit Test Results into <pre> content
UNIT_TEST_RESULTS=$(echo "$TEST_CONTENT" | sed 's/^/    /')

# Replace the placeholders in index.html using awk for multiline content
awk -v pending="$PENDING_LIST" -v completed="$COMPLETED_LIST" -v unittest="$UNIT_TEST_RESULTS" '
BEGIN {
    pending_start = "<ul id=\"pending\">"
    pending_end = "</ul>"
    completed_start = "<ul id=\"completed\">"
    completed_end = "</ul>"
    unittest_start = "<pre id=\"unittest\">"
    unittest_end = "</pre>"
}
{
    if ($0 ~ "<ul id=\"pending\">") {
        print $0
        print pending
        next
    } else if ($0 ~ "<ul id=\"completed\">") {
        print $0
        print completed
        next
    } else if ($0 ~ "<pre id=\"unittest\">") {
        print $0
        print unittest
        next
    } else {
        print $0
    }
}
' /app/index.html > /app/index.html.tmp && mv /app/index.html.tmp /app/index.html

echo "/app/index.html updated successfully."

# Configure Git to use GitHub Actions user and email
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

# Add index.html to git, commit, and push the changes
git add index.html
git commit -m "Update index.html with vowel frequency results"
git push
