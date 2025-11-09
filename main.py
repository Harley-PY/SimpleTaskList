import os
import json

print("Welcome to simple task list")

if not os.path.isfile("tasks.json"):
    with open("tasks.json", "w") as tasks:
        tasks.write("{\"tasks\": []}") # create blank json file

def write_json(new_data, filename='tasks.json'):
    with open(filename, 'r+') as file:
        # Load existing data into a dictionary
        file_data = json.load(file)

        # Append new data to the 'emp_details' list
        file_data["tasks"].append(new_data)

        # Move the cursor to the beginning of the file
        file.seek(0)

        # Write the updated data back to the file
        json.dump(file_data, file, indent=4)

while True:
    print("What would you like to do?")
    print("(r) Read tasks list")
    print("(m) Modify task")
    print("(n) Create new task")
    print("(e) Exit")
    selection = input("Enter selection: ").lower()

    match selection:
        case "r":
            with open("tasks.json", "r") as file:
                js = json.loads(file.read())
                tasks = js["tasks"]

                i = 1
                for task in tasks:
                    print(str(i) + ".", task["task_name"])
                    i += 1
        case "m":
            with open("tasks.json", "r") as tasks:
                js = json.loads(tasks.read())
                print(js)
        case "n":
            while True:
                task_name = input("What is the name of the task: ")

                if len(task_name) != 0:
                        write_json({"task_name": task_name})
                        print("Success!")
                        break
                else:
                    print("Nothing entered!")
        case "e":
            break
        case _:
            print("Note a valid selection")
            continue
