import argparse
import os
import json

class task_manager:
    def gen_file(path="tasks.json"):
        if not os.path.isfile(path):
            with open(path, "w") as tasks:
                tasks.write("{\"tasks\": []}")

    def read(isPretty=False, withId=False):
        with open("tasks.json", "r") as file:
            js = json.loads(file.read())
            tasks = js["tasks"]

            if isPretty:
                final_string = ""

                i = 1
                for task in tasks:
                    if withId:
                        final_string = f"{final_string}({task["id"]}) {str(i)}. {task["task_name"]}\n"
                    else:
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
    if not os.path.isfile("tasks.json"):
        gen_file("tasks.json")
        
    parser = argparse.ArgumentParser(prog="simpletodo", description="A simple to-do CLI app")

    subparsers = parser.add_subparsers(dest="command", required=True)

    # Add command
    add_parser = subparsers.add_parser("add", help="Add a new task")
    add_parser.add_argument("task", nargs="+", help="Task description")

    # List command
    list_parser = subparsers.add_parser("list", help="List all tasks")
    list_parser.add_argument("--with-id", action="store_true",   help="Show ids")

    # Remove command
    remove_parser = subparsers.add_parser("remove", help="Remove a task by ID")
    remove_parser.add_argument("id", help="Task ID to remove")

    # Reset command
    subparsers.add_parser("reset", help="Deletes all tasks saved")

    args = parser.parse_args()

    match args.command:
        case "add":
            task = " ".join(args.task)
            task_h = hash(task)

            task_id = hex(task_h & 0xFFFFFF)[2:]
            task_manager.new({"id": task_id, "task_name": task})

            print("Success!")
        case "list":
            with_id = args.with_id
            output = task_manager.read(isPretty=True, withId=with_id)
            print(output)
        case "remove":
            print(f"🗑️ Removed task #{args.id}")
        case "reset":
            try:
                os.remove("tasks.json")
                print("Reset success")
                task_manager.gen_file()
            except:
                print("Reset failed")

if __name__ == "__main__":
    main()
