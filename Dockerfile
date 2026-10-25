# Hermes Agent with its browser's system libraries, terminal tools and SearXNG, on Ubuntu 24.04.
# The newest Hermes and SearXNG at build time: rebuilt every night when either has changed (and each week for Ubuntu's
# updates). The build arguments below are only cache keys: a changed one rebuilds its layer and the ones after it, so
# an unchanged layer keeps its digest and a host that has it pulls only what changed.
# Hermes' runtime (tools: its Python and uv; installs: its extra Python environments) is kept outside HERMES_HOME,
# in /opt/hermes/tools and /opt/hermes/installs, so a HERMES_HOME can be mounted from elsewhere and link back to them.
# /opt/hermes/home-seed holds Hermes' default home.
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8

# the browser's system libraries and fonts, terminal tools, and what the installers need
ARG APT_WEEK
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git xz-utils wget jq unzip less \
      libasound2t64 libatk-bridge2.0-0t64 libatk1.0-0t64 libatspi2.0-0t64 libcairo2 libcups2t64 libdbus-1-3 libdrm2 \
      libgbm1 libglib2.0-0t64 libnspr4 libnss3 libpango-1.0-0 libx11-6 libxcb1 libxcomposite1 libxdamage1 libxext6 \
      libxfixes3 libxkbcommon0 libxrandr2 libfontconfig1 libfreetype6 fonts-liberation fonts-noto-color-emoji \
      fonts-freefont-ttf fonts-wqy-zenhei fonts-ipafont-gothic fonts-tlwg-loma-otf \
 && rm -rf /var/lib/apt/lists/* \
 && useradd -M -d /opt/hermes/userhome -u 10000 -s /bin/sh agent

ENV H=/opt/hermes
# Hermes, installed with its own installer; then its runtime moves out of its home and the home becomes home-seed
ARG HERMES_COMMIT
RUN mkdir -p $H/userhome $H/cache \
 && curl -fsSL https://hermes-agent.nousresearch.com/install.sh -o /tmp/install.sh \
 && HOME=$H/userhome HERMES_HOME=$H/home XDG_CACHE_HOME=$H/cache UV_CACHE_DIR=/tmp/uv \
    bash /tmp/install.sh --non-interactive --skip-computer-use --dir $H/agent \
 && mkdir -p $H/home/tools $H/home/installs \
 && mv $H/home/tools $H/tools && mv $H/home/installs $H/installs \
 && rm -rf $H/home/cache $H/home/logs \
 && mv $H/home $H/home-seed \
 && rm -rf /tmp/install.sh /tmp/uv \
 && chown -R agent:agent $H

# SearXNG, with Hermes' Python
ARG SEARXNG_COMMIT
RUN git clone -q --depth 1 https://github.com/searxng/searxng $H/searxng/src \
 && UV=$(ls -d $H/tools/uv-*/ | tail -1)uv && PY=$(ls -d $H/tools/python-*/ | tail -1)bin/python3 \
 && export UV_CACHE_DIR=/tmp/uv \
 && $UV venv -q --python "$PY" $H/searxng/venv \
 && VIRTUAL_ENV=$H/searxng/venv $UV pip install -q setuptools wheel \
 && cd $H/searxng/src \
 && VIRTUAL_ENV=$H/searxng/venv $UV pip install -q -r requirements.txt \
 && VIRTUAL_ENV=$H/searxng/venv $UV pip install -q --no-build-isolation -e . \
 && $H/searxng/venv/bin/python -m searx.version freeze \
 && rm -rf /tmp/uv \
 && chown -R agent:agent $H/searxng

# what this image holds (git as the owner of the checkouts)
RUN echo "hermes $(runuser -u agent -- git -C $H/agent describe --tags --always), searxng $(runuser -u agent -- git -C $H/searxng/src rev-parse --short HEAD), built $(date -u +%F)" > $H/VERSION \
 && cat $H/VERSION
