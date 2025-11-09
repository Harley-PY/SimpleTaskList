import argparse
import os
import json

if not os.path.isfile("tasks.json"):
    with open("tasks.json", "w") as tasks:
        tasks.write("{\"tasks\": []}") # create blank json file

class task_manager:
    def read(isPretty=False):
        with open("tasks.json", "r") as file:
            js = json.loads(file.read())
            tasks = js["tasks"]

            if isPretty:
                final_string = ""

                i = 1
                for task in tasks:
                    final_string = f"{final_string}{str(i)}. {task["task_name"]}\n"
                    i += 1

                return final_string

            return tasks

    def new(new_data):
        with open("tasks.json", 'r+') as file:
            # Load existing data into a dictionary
            file_data = json.load(file)

            # Append new data to the 'emp_details' list
            file_data["tasks"].append(new_data)

            # Move the cursor to the beginning of the file
            file.seek(0)

            # Write the updated data back to the file
            json.dump(file_data, file, indent=4)

def main():
    parser = argparse.ArgumentParser(prog="simpletodo", description="A simple to-do CLI app")

    subparsers = parser.add_subparsers(dest="command", required=True)

    # Add command
    add_parser = subparsers.add_parser("add", help="Add a new task")
    add_parser.add_argument("task", nargs="+", help="Task description")

    # List command
    subparsers.add_parser("list", help="List all tasks")

    # Remove command
    remove_parser = subparsers.add_parser("remove", help="Remove a task by ID")
    remove_parser.add_argument("id", type=int, help="Task ID to remove")

    args = parser.parse_args()

    match args.command:
        case "add":
            task = " ".join(args.task)
            task_manager.new({"task_name": task})
            print("Success!")
        case "list":
            output = task_manager.read(isPretty=True)
            print(output)
        case "remove":
            print(f"🗑️ Removed task #{args.id}")

if __name__ == "__main__":
    main()
