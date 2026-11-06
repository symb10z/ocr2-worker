# ocr2-worker

Установщик исполнителя заданий: контейнер с GitHub Actions runner и PyTorch/CUDA. Здесь нет ни ключей, ни данных, ни заданий —
задания лежат в закрытом репозитории, к которому runner подключается по одноразовому токену регистрации.

1. Нужны Docker Desktop (WSL2) и драйвер NVIDIA.
2. Скачать архив (Code → Download ZIP) и распаковать.
3. Токен регистрации: в закрытом репозитории Settings → Actions → Runners → New self-hosted runner (живёт около часа).
4. `powershell -ExecutionPolicy Bypass -File install.ps1` — проверит видеокарту в Docker, соберёт образ, запустит контейнер
   с автозапуском (`--restart always`).

Остановить: `docker stop ocr2-worker`. Удалить: `docker rm -f ocr2-worker`, образ `docker rmi ocr2-worker`.
Контейнер видит только свой том `ocr2-worker-data` и видеокарту; файлов и дисков хозяина системы не видит.
