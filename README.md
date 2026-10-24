# hermes-agent-image

[Hermes Agent](https://github.com/NousResearch/hermes-agent) with its browser's system libraries, terminal tools and
[SearXNG](https://github.com/searxng/searxng), on Ubuntu 24.04. Rebuilt every night with the newest Hermes and SearXNG,
published as `ghcr.io/inlanger/hermes-agent-image:latest` (plus a dated tag).

| Path | What |
|---|---|
| `/opt/hermes/agent` | Hermes Agent |
| `/opt/hermes/tools`, `/opt/hermes/installs` | Hermes' Python, uv and extra environments, kept outside `HERMES_HOME` |
| `/opt/hermes/home-seed` | Hermes' default home |
| `/opt/hermes/userhome` | the `agent` user's home: the `hermes` command and caches |
| `/opt/hermes/searxng` | SearXNG and its environment |
| `/opt/hermes/VERSION` | what this build holds |
