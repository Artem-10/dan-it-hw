#!/bin/bash


target=$((RANDOM % 100 + 1))

echo "Вгадайте число від 1 до 100. У вас є 5 спроб."

for attempt in {1..5}; do
    read -p "Спроба $attempt: Введіть ваше число: " guess


    if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
        echo "Будь ласка, введіть коректне число."
        ((attempt--))
        continue
    fi

    if (( guess == target )); then
        echo "Вітаємо! Ви вгадали правильне число."
        exit 0
    elif (( guess < target )); then
        echo "Занадто низько."
    else
        echo "Занадто високо."
    fi
done

echo "Вибачте, у вас закінчилися спроби. Правильним числом було $target."
exit 1
