import os
import json

print("Welcome to simple task list")

if not os.path.isfile("tasks.json"):
    with open("tasks.json", "w") as tasks:
        tasks.write("{\n\n}") # create blank json file

while True:
    print("What would you like to do?")
    print("(r) Read tasks list")
    print("(m) Modify task")
    print("(n) Create new task")
    print("(e) Exit")
    selection = input("Enter selection: ").lower()

    match selection:
        case "r":
            with open("tasks.json", "r") as tasks:
                js = json.loads(tasks.read())
                print(json.dumps(js))
        case "m":
            with open("tasks.json", "r") as tasks:
                js = json.loads(tasks.read())
                print(js)
        case "n":
            while True:
                task_name = input("What is the name of the task: ")

                if len(task_name) != 0:
                    with open("tasks.json", "r+") as tasks:
                        js = json.loads(tasks.read())
                        js.update({"task_name": task_name})
                        jsstring = json.dumps(js)

                        tasks.write(jsstring)
                        print("Success!")
                    break
                else:
                    print("Nothing entered!")
        case "e":
            break
        case _:
            print("Note a valid selection")
            continue
