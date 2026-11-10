# Установка исполнителя на этой машине (Windows, Docker Desktop + WSL2 + драйвер NVIDIA).
# Запуск:  powershell -ExecutionPolicy Bypass -File install.ps1
# Спросит адрес репозитория и одноразовый токен регистрации (GitHub: Settings -> Actions -> Runners -> New self-hosted runner).
$ErrorActionPreference = "Stop"
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) { throw "Docker не найден. Поставьте Docker Desktop (с WSL2) и запустите его." }
Write-Host "Проверяю видеокарту в Docker..."
docker run --rm --gpus all nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi
if ($LASTEXITCODE -ne 0) { throw "Видеокарта в Docker недоступна: обновите драйвер NVIDIA и включите WSL2-бэкенд Docker Desktop." }
$repo  = Read-Host "Адрес репозитория, например https://github.com/USER/ocr2-jobs"
$token = Read-Host "Токен регистрации runner"
$label = Read-Host "Метка runner (Enter = ocr2-gpu; для третьего ПК введите ocr2-gpu-b)"
if (-not $label) { $label = "ocr2-gpu" }
Write-Host "Собираю образ..."
docker build -t ocr2-worker $PSScriptRoot
docker rm -f ocr2-worker 2>$null | Out-Null
docker run -d --name ocr2-worker --restart always --gpus all `
  -e REPO_URL=$repo -e RUNNER_TOKEN=$token -e RUNNER_LABELS=$label -v ocr2-worker-data:/data ocr2-worker
Write-Host "Готово. Контейнер ocr2-worker запущен и стартует вместе с Docker. Проверка: docker logs ocr2-worker"
Write-Host "Остановить: docker stop ocr2-worker   Удалить: docker rm -f ocr2-worker"
