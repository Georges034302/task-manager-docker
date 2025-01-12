import pytest
from todo import Task, TaskPool

# Test to check if Task creation works as expected
def test_task_creation():
    task = Task("Test Task")
    assert task.title == "Test Task"
    assert not task.completed  # Default value for completion should be False

# Test to mark a task as completed
def test_task_mark_completed():
    task = Task("Test Task")
    task.mark_completed()
    assert task.completed is True

# Test TaskPool population
def test_task_pool_population():
    pool = TaskPool()
    pool.populate()
    tasks = pool.get_tasks()
    assert len(tasks) > 0  # Ensure there are tasks in the pool after population

# Test if a task is correctly moved to Done
def test_task_move_to_done():
    pool = TaskPool()
    pool.populate()
    task = pool.get_tasks()[0]  # Get first task from populated pool
    task.mark_completed()
    
    # Test if the task is completed
    assert task.completed is True

    # Here you can also test that the task appears in the 'done' section,
    # but that requires you to mock the behavior of TaskPool's done logic or interact with an actual project board API.
