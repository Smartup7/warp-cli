#!/bin/bash
# Cloudflare WARP Installer for Debian with Proxy Mode
# Источник: официальная документация Cloudflare [[3]][[7]]

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Установка Cloudflare WARP на Debian ===${NC}"

# Проверка прав root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Этот скрипт должен выполняться от root${NC}"
   exit 1
fi

# STEP 1: Обновление системы [[5]]
echo -e "${YELLOW}[1/7] Обновление системы...${NC}"
apt update && apt upgrade -y

# STEP 2: Установка зависимостей [[2]][[5]]
echo -e "${YELLOW}[2/7] Установка необходимых пакетов...${NC}"
apt install -y curl gnupg lsb-release apt-transport-https

# STEP 3: Добавление GPG-ключа Cloudflare [[5]][[7]]
echo -e "${YELLOW}[3/7] Добавление GPG-ключа Cloudflare...${NC}"
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | \
    gpg --dearmor -o /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg

# STEP 4: Добавление репозитория Cloudflare [[3]][[5]]
echo -e "${YELLOW}[4/7] Добавление репозитория Cloudflare...${NC}"
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] \
https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/cloudflare-client.list

# STEP 5: Установка cloudflare-warp [[3]][[5]]
echo -e "${YELLOW}[5/7] Установка пакета cloudflare-warp...${NC}"
apt update
apt install -y cloudflare-warp

# STEP 6: Регистрация устройства [[5]]
echo -e "${YELLOW}[6/7] Регистрация устройства в Cloudflare...${NC}"
warp-cli registration new

# STEP 7: Настройка Proxy Mode [[29]][[30]][[48]]
echo -e "${YELLOW}[7/7] Настройка Proxy Mode...${NC}"

# Установка режима proxy
warp-cli mode proxy

# Настройка порта прокси (по умолчанию 40000)
PROXY_PORT="${1:-40000}"
warp-cli proxy port "$PROXY_PORT"

# Подключение к WARP
echo -e "${YELLOW}Подключение к Cloudflare WARP...${NC}"
warp-cli connect

# Проверка статуса
echo -e "\n${GREEN}Проверка статуса:${NC}"
warp-cli status

echo -e "\n${GREEN}=== Установка завершена! ===${NC}"
echo -e "${YELLOW}Прокси доступен на: 127.0.0.1:${PROXY_PORT}${NC}"
echo -e "Типы прокси: SOCKS5 / HTTP"
echo -e "\n${YELLOW}Полезные команды:${NC}"
echo "  warp-cli status              # Проверить статус"
echo "  warp-cli disconnect          # Отключиться"
echo "  warp-cli mode --help         # Показать доступные режимы"
echo "  warp-cli proxy port <port>   # Изменить порт прокси"
echo "  warp-cli registration delete # Удалить регистрацию"
