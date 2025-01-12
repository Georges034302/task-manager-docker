class Task:
    def __init__(self, title):
        self.title = title
        self.completed = False

    def mark_completed(self):
        self.completed = True

    def __repr__(self):
        return f"{self.title} - {'Completed' if self.completed else 'Pending'}"

class TaskPool:
    def __init__(self):
        self.tasks = []

    def populate(self):
        # Example task population with different statuses
        task1 = Task("Fix UI Bug")
        task2 = Task("Write Tests")
        task3 = Task("Update Documentation")
        task4 = Task("Deploy to Production")
        
        task1.mark_completed()
        task3.mark_completed()
        
        self.tasks = [task1, task2, task3, task4]

    def get_task_titles_with_status(self):
        return [f"{task.title} - {'Completed' if task.completed else 'Pending'}" for task in self.tasks]
