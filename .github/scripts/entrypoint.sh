#!/bin/bash

# Run todo.py and capture the output
TASKS_OUTPUT=$(python3 todo.py)

# Run test-todo.py and capture the output
TEST_OUTPUT=$(python3 test-todo.py)

# Run update_index.sh with both outputs
./update_index.sh "$TASKS_OUTPUT" "$TEST_OUTPUT"
