#!/bin/bash

echo "======================"
echo "Executing todo.py"
echo "======================"
python3 /app/.github/scripts/todo.py > /app/todo_output.txt

echo "======================"
echo "Executing todo-test.py"
echo "======================"
python3 /app/.github/scripts/todo-test.py > /app/test_output.txt  # Corrected the filename

echo "======================"
echo "Executing update_index.sh"
echo "======================"
bash /app/.github/scripts/update_index.sh /app/todo_output.txt /app/test_output.txt

echo "======================"
echo "Done!"
echo "======================"
