import os

print("Welcome to simple task list")

if not os.path.isfile("tasks.json"):
    with open("tasks.json", "a") as tasks:
        tasks.write("{\n}")

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
                print(tasks.read())
        case "m":
            with open("tasks.json", "r") as tasks:
                print(tasks.read())
        case "n":
            while True:
                task_name = input("What is the name of the task: ")

                if len(task_name) != 0:
                    with open("tasks.json", "a") as tasks:
                        tasks.write(task_name)
                    break
                else:
                    print("Nothing entered!")
        case "e":
            break
        case _:
            print("Note a valid selection")
            continue
