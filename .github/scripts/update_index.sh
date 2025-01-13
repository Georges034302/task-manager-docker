#!/bin/bash

HTML_FILE="index.html"

# Robustly extract tasks (handling missing/multiple "Done Tasks:")
TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | sed '1d;/Done Tasks:/q')

# Extract DONE_TASKS using awk for more robust handling
DONE_TASKS=$(awk '/Done Tasks:/,/^$/' "$1" | sed '1d;$d')

UNIT_TEST_RESULTS=$(cat "$2")

update_pre() {
  perl -i -0777 -pe "s{<pre id=\"$1\">.*?</pre>}{
<pre id=\"$1\">\n$2\n</pre>}gs" "$3"
}

update_pre "pending" "$TODO_TASKS" "$HTML_FILE"
update_pre "completed" "$DONE_TASKS" "$HTML_FILE"
update_pre "unittest" "$UNIT_TEST_RESULTS" "$HTML_FILE"

git config --global user.email "github-actions@users.noreply.github.com"
git add "$HTML_FILE"
git commit -m "Update $HTML_FILE with new task and test data"
git push