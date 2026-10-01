#!/usr/bin/env bash

get_volume() {
    local device="$1"
    local output

    output=$(wpctl get-volume "$device")

    local volume
    volume=$(awk '{printf "%.0f%%", $2 * 100}' <<< "$output")

    if [[ "$output" == *"[MUTED]"* ]]; then
        echo "$volume 🔇"
    else
        echo "$volume"
    fi
}

SPEAKER=$(get_volume @DEFAULT_AUDIO_SINK@)
MIC=$(get_volume @DEFAULT_AUDIO_SOURCE@)

notify-send -t 1250 "🔊 Громкость" \
    "Динамики: $SPEAKER
Микрофон: $MIC"
