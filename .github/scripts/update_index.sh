#!/bin/bash

HTML_FILE="index.html"

TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" "$1" | grep -B 1000 "Done Tasks:" | sed '1d;$d')
DONE_TASKS=$(grep -A 1000 "Done Tasks:" "$1" | sed '1d')
UNIT_TEST_RESULTS=$(cat "$2")

update_pre() {
  local pre_id="$1"
  local content="$2"
  local html_file="$3"

  awk -v pre_id="$pre_id" -v content="$content" '
BEGIN { in_pre = 0 }
{
  if ($0 ~ "<pre id=\"" pre_id "\">") {
    print
    split(content, lines, "\n")
    for (i in lines) {
      if (lines[i] != "") {
        printf "%s\n", lines[i]
      }
    }
    in_pre = 1
    next
  }
  if (in_pre && $0 ~ /<\/pre>/) {
    print
    in_pre = 0
    next
  }
  print
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