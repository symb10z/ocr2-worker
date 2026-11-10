#!/bin/bash
# Регистрирует runner при первом запуске (нужны REPO_URL и RUNNER_TOKEN), дальше просто слушает задания.
# Контейнер с --restart always сохраняет свою файловую систему, поэтому токен нужен только один раз.
set -e
cd /home/runner/actions-runner
if [ ! -f .runner ]; then
  : "${REPO_URL:?нужен REPO_URL}" "${RUNNER_TOKEN:?нужен RUNNER_TOKEN}"
  ./config.sh --unattended --url "$REPO_URL" --token "$RUNNER_TOKEN" \
      --name "${RUNNER_NAME:-ocr2-gpu-$(hostname)}" --labels "${RUNNER_LABELS:-ocr2-gpu}" --replace
fi
exec ./run.sh
