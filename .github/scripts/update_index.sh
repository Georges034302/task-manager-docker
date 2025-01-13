#!/bin/bash

# Check if index.html exists
if [[ ! -f /app/index.html ]]; then
    echo "Error: /app/index.html not found. Exiting."
    exit 1
fi

# Read content from the todo output and test output
TODO_CONTENT=$(cat "$1" 2>/dev/null || echo "No tasks available.")
TEST_CONTENT=$(cat "$2" 2>/dev/null || echo "No unit test results available.")

# Replace the placeholders in index.html using awk for multiline content
awk -v todo="$TODO_CONTENT" -v test="$TEST_CONTENT" '
BEGIN {
    pending_start = "<ul id=\"pending\">"
    pending_end = "</ul>"
    unittest_start = "<pre id=\"unittest\">"
    unittest_end = "</pre>"
}
{
    if ($0 ~ pending_start) {
        print $0
        print todo
        skip = 1
    } else if ($0 ~ pending_end) {
        skip = 0
        next
    } else if ($0 ~ unittest_start) {
        print $0
        print test
        skip = 1
    } else if ($0 ~ unittest_end) {
        skip = 0
        next
    }
    if (!skip) print $0
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