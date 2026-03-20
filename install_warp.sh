#!/bin/bash

# Остановить скрипт при ошибке
set -e

echo "--- Настройка репозитория Cloudflare WARP ---"

# 1. Обновляем списки и устанавливаем зависимости
sudo apt update && sudo apt install -y curl gpg lsb-release

# 2. Добавляем GPG ключ для проверки подписи пакетов
curl -fsSL https://pkg.cloudflareclient.com | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg

# 3. Определяем кодовое имя системы (например, jammy или bookworm)
OS_CODENAME=$(lsb_release -cs)

# 4. Добавляем репозиторий в список источников
echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com $OS_CODENAME main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list

# 5. Обновляем кэш пакетов и устанавливаем приложение
sudo apt update
sudo apt install -y cloudflare-warp

echo "--- Установка завершена! ---"
echo "Для начала работы введите: warp-cli registration new"
