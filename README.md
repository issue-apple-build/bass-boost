# bass-boost

PipeWire filter-chain config that adds a bass boost sink to your audio setup.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/issue-apple-build/bass-boost/main/install-bassboost.sh | sh
```

## What it does

- Installs a PipeWire filter-chain config to `~/.config/pipewire/filter-chain.conf.d/`
- Creates a **Bass Boost Sink** virtual audio device (+10 dB shelf at 80 Hz, +5 dB peak at 150 Hz)
- Enables and starts `filter-chain.service` so the sink persists across reboots
