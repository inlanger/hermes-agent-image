# hermes-agent-image

[Hermes Agent](https://github.com/NousResearch/hermes-agent) with its browser's system libraries, terminal tools and
[SearXNG](https://github.com/searxng/searxng), on Ubuntu 24.04. Always the newest: Hermes' latest release (the one its
installer installs), SearXNG's newest commit and Ubuntu's updates, checked every 3 hours and rebuilt when one has
changed (Ubuntu's updates each week), published as `ghcr.io/inlanger/hermes-agent-image:latest` (plus a dated tag).
Unchanged layers keep their digests, so a host that already has the image pulls only what changed: the 1.2 GB Hermes
layer only after a new Hermes release or Ubuntu image, the others are small.

| Path | What |
|---|---|
| `/opt/hermes/agent` | Hermes Agent |
| `/opt/hermes/tools`, `/opt/hermes/installs` | Hermes' Python, uv and extra environments, kept outside `HERMES_HOME` |
| `/opt/hermes/home-seed` | Hermes' default home |
| `/opt/hermes/userhome` | the `agent` user's home: the `hermes` command and caches |
| `/opt/hermes/searxng` | SearXNG and its environment |
| `/opt/hermes/VERSION` | what this build holds |
