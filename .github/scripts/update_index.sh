#!/bin/bash

# Check if index.html exists
if [[ ! -f /app/index.html ]]; then
    echo "Error: /app/index.html not found. Exiting."
    exit 1
fi

# Read content from the todo output and test output
TODO_CONTENT=$(cat "$1" 2>/dev/null || echo "No tasks available.")
TEST_CONTENT=$(cat "$2" 2>/dev/null || echo "No unit test results available.")

# Temporary backup of the original index.html file
cp /app/index.html /app/index.html.bak

# Update Pending Tasks section
sed -i '/<section>.*<h2>Pending Tasks<\/h2>/,/<\/section>/{
    /<ul id="pending">/ { 
        r /dev/stdin
        d
    }
    a\
    <ul id="pending">\
    <li>ToDo Tasks:</li>\
    '"$(echo "$TODO_CONTENT" | sed 's/^/<li>/;s/$/<\/li>/')"\
    </ul>\
}' /app/index.html <<< "$TODO_CONTENT"

# Update Completed Tasks section
sed -i '/<section>.*<h2>Completed Tasks<\/h2>/,/<\/section>/{
    /<ul id="completed">/ { 
        r /dev/stdin
        d
    }
    a\
    <ul id="completed">\
    <li>Add Login UI</li>\
    <li>Fix UI Bug</li>\
    <li>Write Tests</li>\
    </ul>\
}' /app/index.html

# Update Unit Test Results section
sed -i '/<section>.*<h2>Unit Test Results<\/h2>/,/<\/section>/{
    /<pre id="unittest">/ { 
        r /dev/stdin
        d
    }
    a\
    <pre id="unittest">\
    '"$(echo "$TEST_CONTENT")"'\
    </pre>\
}' /app/index.html

# Configure Git to use GitHub Actions user and email
git config --global user.name "github-actions"
git config --global user.email "github-actions@users.noreply.github.com"

# Add the modified index.html to git, commit, and push the changes
git add index.html
git commit -m "Update index.html with new task and test data"
git push
