#!/bin/bash

# Зупиняємо виконання скрипта, якщо трапляється помилка
set -e

# Встановлення змінних
REPO_URL="https://github.com/OleksaSolo/MontyHall.git"
BRANCH_DEV="dev"
BRANCH_NEW="new20"

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

# Перевірка автентифікації GitHub CLI
if ! "C:/Program Files/GitHub CLI/gh.exe" auth status &> /dev/null; then
    echo "[INFO] Не авторизовано в GitHub CLI. Розпочинається процес автентифікації..."
    "C:/Program Files/GitHub CLI/gh.exe" auth login --with-token < mytoken.txt
fi

echo "[INFO] Автентифікація успішна. Створення Pull Request..."

# Створення Pull Request
gh pr create --base $BRANCH_DEV --head $BRANCH_NEW --title "Merge $BRANCH_NEW into $BRANCH_DEV" --body "update text"

# Перевірка відкритих PR і витягнення номера
echo "[INFO] Отримання номеру Pull Request..."
PR_NUMBER=$(gh pr list --base $BRANCH_DEV --head $BRANCH_NEW --json number -q ".[0].number")
echo "[DEBUG] Знайдений PR номер: $PR_NUMBER"

if [ -z "$PR_NUMBER" ]; then
    echo "[ERROR] Не вдалося знайти номер Pull Request. Можливо, PR ще не створено."
    exit 1
fi

# Мердж гілки, якщо PR пройшов
read -p "Натисніть Enter після мерджу pull request, щоб продовжити..."

gh pr merge $PR_NUMBER --merge --auto

# Повернення до гілки dev
git checkout $BRANCH_DEV

git pull origin $BRANCH_DEV

# Видалення локальної гілки
git branch -d $BRANCH_NEW

# Видалення віддаленої гілки
git push origin --delete $BRANCH_NEW

echo "Гілка $BRANCH_NEW успішно видалена."