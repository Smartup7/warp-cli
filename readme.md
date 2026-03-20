https://blog.cloudflare.com/announcing-warp-for-linux-and-proxy-mode/#using-the-cli


# 1. Регистрация (обязательно первый раз)
warp-cli registration new

# 2. Подключение
warp-cli connect

# 3. Проверка статуса
warp-cli status

# 4. Проверка работы
curl https://www.cloudflare.com/cdn-cgi/trace/
# Должно быть: warp=on

# 5. Переключение в режим прокси
warp-cli mode proxy
warp-cli proxy port 40000

# 6. Отключение
warp-cli disconnect
----------------------------------------------------
# 7. В MTProxyMax добавить upstream:
mtproxymax upstream add warp socks5 127.0.0.1:40000
# Изменить вес (например, сделать WARP приоритетным)
mtproxymax upstream add warp socks5 127.0.0.1:40000 "" "" 20

# Или временно отключить прямое соединение
mtproxymax upstream disable direct
