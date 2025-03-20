#!/bin/bash

# Зупиняємо виконання скрипта, якщо трапляється помилка
set -e

# Встановлення змінних
REPO_URL="https://github.com/ТВОЄ_ІМ'Я/Project.git"  # Заміни на свій URL
BRANCH_DEV="dev"
BRANCH_NEW="new"

# Переконуємося, що ми на останній версії dev
git checkout $BRANCH_DEV
git pull origin $BRANCH_DEV

# Створення та перехід на нову гілку
git checkout -b $BRANCH_NEW

# Додаємо порожній рядок до readme
echo "" >> readme.md

# Додаємо зміни у stage
git add readme.md

# Робимо комміт
COMMIT_MESSAGE="update new"
git commit -m "$COMMIT_MESSAGE"

# Завантажуємо нову гілку на GitHub
git push origin $BRANCH_NEW

# Створення pull request за допомогою GitHub CLI (gh)
gh pr create --base $BRANCH_DEV --head $BRANCH_NEW --title "Merge $BRANCH_NEW into $BRANCH_DEV" --body "update text"

echo "Переконайтеся, що pull request створено на GitHub."

# Мердж гілки, якщо PR пройшов (можна автоматизувати за допомогою 'gh pr merge')
read -p "Натисніть Enter після мерджу pull request, щоб продовжити..."

# Повернення до гілки dev
git checkout $BRANCH_DEV

git pull origin $BRANCH_DEV

# Видалення локальної гілки
git branch -d $BRANCH_NEW

# Видалення віддаленої гілки
git push origin --delete $BRANCH_NEW


echo "Гілка $BRANCH_NEW успішно видалена."