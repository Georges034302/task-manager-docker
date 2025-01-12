#!/bin/bash

# Check if input for tasks is provided
if [ -z "$1" ]; then
  echo "No tasks provided."
  exit 1
fi

# Extract tasks
TASKS=$1

# Split the tasks into two categories: pending and completed
PENDING_TASKS=""
COMPLETED_TASKS=""

# Loop through each task and categorize them
for TASK in $TASKS; do
  # Assuming task starts with 'completed' or 'pending'
  if [[ $TASK == *"completed"* ]]; then
    COMPLETED_TASKS="$COMPLETED_TASKS<li>$TASK</li>"
  else
    PENDING_TASKS="$PENDING_TASKS<li>$TASK</li>"
  fi
done

# Update Pending Tasks section in index.html
sed -i "/<ul id='pending'>/a $PENDING_TASKS" index.html

# Update Completed Tasks section in index.html
sed -i "/<ul id='completed'>/a $COMPLETED_TASKS" index.html

echo "Index updated successfully."
