# Исполнитель заданий: GitHub Actions self-hosted runner + Python/CUDA в одном контейнере.
# На хосте ничего не ставится, кроме Docker и драйвера NVIDIA. Токены в образе не хранятся.
ARG BASE=pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime
FROM ${BASE}
ENV DEBIAN_FRONTEND=noninteractive RUNNER_ALLOW_RUNASROOT=0
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl git jq sudo libicu-dev tar unzip && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir huggingface_hub
RUN useradd -m -s /bin/bash runner && mkdir -p /data && chown runner /data
USER runner
WORKDIR /home/runner/actions-runner
# свежий runner с официального релиза GitHub
RUN V=$(curl -fsSL https://api.github.com/repos/actions/runner/releases/latest | jq -r .tag_name | sed 's/^v//') \
 && curl -fsSL -o r.tgz "https://github.com/actions/runner/releases/download/v${V}/actions-runner-linux-x64-${V}.tar.gz" \
 && tar xzf r.tgz && rm r.tgz
COPY --chown=runner entrypoint.sh /home/runner/entrypoint.sh
RUN tr -d "\015" < /home/runner/entrypoint.sh > /home/runner/e.sh && mv /home/runner/e.sh /home/runner/entrypoint.sh && chmod +x /home/runner/entrypoint.sh
ENV HF_HOME=/data/hf
VOLUME /data
ENTRYPOINT ["/home/runner/entrypoint.sh"]
