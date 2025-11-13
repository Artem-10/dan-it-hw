import random

pc_chose = random.randint(1, 100)
attempts_limit = 5

print(f"I've thought of a number between 1 and 100. You have {attempts_limit} attempts to guess it!")

for attempt in range(attempts_limit):
    print(f"\n--- Attempt #{attempt + 1} ---")

    try:
        user_choice = int(input("What is your guess? "))

        if user_choice == pc_chose:
            print(f"You got it! The number was {pc_chose}.")
            break
        elif user_choice < pc_chose:
            print("Too low.")
        else:
            print("Too high.")

    except ValueError:
        print("Please enter a valid number. This attempt still counts.")

else:
    print(f"\nYou lost! The attempts are over. The number I was thinking of was: {pc_chose}")