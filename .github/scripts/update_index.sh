#!/bin/bash

# Check if index.html exists
if [[ ! -f /app/index.html ]]; then
    echo "Error: /app/index.html not found. Exiting."
    exit 1
fi

# Read content from the todo output and test output
TODO_CONTENT=$(cat "$1" 2>/dev/null || echo "No tasks available.")
TEST_CONTENT=$(cat "$2" 2>/dev/null || echo "No unit test results available.")

# Split tasks into individual list items
PENDING_LIST=$(echo "$TODO_CONTENT" | sed 's/^/ <li>/;s/$/<\/li>/')
COMPLETED_LIST=$(echo "$TEST_CONTENT" | sed 's/^/ <li>/;s/$/<\/li>/')

# Replace the placeholders in index.html using awk for multiline content
awk -v pending="$PENDING_LIST" -v completed="$COMPLETED_LIST" -v test="$TEST_CONTENT" '
BEGIN {
    pending_start = "<ul id=\"pending\">"
    pending_end = "</ul>"
    completed_start = "<ul id=\"completed\">"
    completed_end = "</ul>"
    unittest_start = "<pre id=\"unittest\">"
    unittest_end = "</pre>"
    body_start = "<body>"
    body_end = "</body>"
}
{
    # Identify the <body> section
    if ($0 ~ body_start) {
        print $0
        inside_body = 1
    } else if ($0 ~ body_end && inside_body) {
        print pending
        print completed
        print unittest_start
        print test
        print unittest_end
        print $0
        inside_body = 0
        next
    } else if (inside_body) {
        # Process content within the <body> tag
        print $0
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
