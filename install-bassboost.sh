#!/usr/bin/env bash

set -euo pipefail

PIPEWIRE_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pipewire/filter-chain.conf.d"
CONF_FILE="$PIPEWIRE_CONF_DIR/sink-bass-boost.conf"

mkdir -p "$PIPEWIRE_CONF_DIR"

cat > "$CONF_FILE" << 'EOF'
context.modules = [
    { name = libpipewire-module-filter-chain
        args = {
            node.description = "Bass Boost Sink"
            media.name       = "Bass Boost Sink"
            filter.graph = {
                nodes = [
                    {
                        type    = builtin
                        name    = bass_shelf
                        label   = bq_lowshelf
                        control = { "Freq" = 80.0 "Q" = 0.9 "Gain" = 10.0 }
                    }
                    {
                        type    = builtin
                        name    = bass_peak
                        label   = bq_peaking
                        control = { "Freq" = 150.0 "Q" = 1.0 "Gain" = 5.0 }
                    }
                    {
                        type    = builtin
                        name    = output_gain
                        label   = bq_highshelf
                        control = { "Freq" = 1.0 "Q" = 0.707 "Gain" = -10.0 }
                    }
                ]
                links = [
                    { output = "bass_shelf:Out" input = "bass_peak:In" }
                    { output = "bass_peak:Out" input = "output_gain:In" }
                ]
            }
            audio.channels = 2
            audio.position = [ FL FR ]
            capture.props = {
                node.name   = "effect_input.bass_boost"
                media.class = Audio/Sink
            }
            playback.props = {
                node.name    = "effect_output.bass_boost"
                node.passive = true
            }
        }
    }
]
EOF

echo "Installed: $CONF_FILE"
systemctl --user enable filter-chain.service
systemctl --user restart filter-chain.service
