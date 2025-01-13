#!/bin/bash

HTML_FILE="index.html"

TODO_TASKS=$(grep -A 1000 "ToDo Tasks:" -B 1000 "Done Tasks:" "$1" | sed '1d;$d')
DONE_TASKS=$(grep -A 1000 "Done Tasks:" "$1" | sed '1d')
UNIT_TEST_RESULTS=$(cat "$2")

update_pre() {
  perl -i -0777 -pe "s{<pre id=\"$1\">.*?</pre>}{
<pre id=\"$1\">\n$2\n</pre>}gs" "$3"
}

for pre_id in pending completed unittest; do
  update_pre "$pre_id" "$(eval "echo \$${pre_id}_TASKS")" "$HTML_FILE"
done

git config --global user.email "github-actions@users.noreply.github.com"
git add "$HTML_FILE"
git commit -m "Update $HTML_FILE with new task and test data"
git push