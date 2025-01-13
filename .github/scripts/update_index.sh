#!/bin/bash

# Check if index.html exists
if [[ ! -f /app/index.html ]]; then
    echo "Error: /app/index.html not found. Exiting."
    exit 1
fi

# Read content from the todo output and test output
TODO_CONTENT=$(cat "$1" 2>/dev/null || echo "No tasks available.")
TEST_CONTENT=$(cat "$2" 2>/dev/null || echo "No unit test results available.")

# Create temporary files to store updated content
TEMP_HTML=$(mktemp)

# Remove existing task and test sections by excluding the matching lines
awk '!/<ul id="pending">|<ul id="completed">|<pre id="unittest">|<\/ul>|<\/pre>/' /app/index.html > "$TEMP_HTML"

# Insert the Pending and Completed task content into the correct sections
echo "$TODO_CONTENT" | sed 's/^/    /' >> "$TEMP_HTML" # Indentation for task lists
awk '/<ul id="pending">/ {print; print "<ul id=\"pending\">"; next} /<\/ul>/ {print; print "<\/ul>"; next} {print}' "$TEMP_HTML" > "$TEMP_HTML.tmp" && mv "$TEMP_HTML.tmp" "$TEMP_HTML"

# Insert the Unit Test Results into the correct section
echo "$TEST_CONTENT" | sed 's/^/    /' >> "$TEMP_HTML"

# Update index.html with the new contents
mv "$TEMP_HTML" /app/index.html

# Configure Git to use GitHub Actions user and email
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

# Add index.html to git, commit, and push the changes
git add index.html
git commit -m "Update index.html with new task and test data"
git push
