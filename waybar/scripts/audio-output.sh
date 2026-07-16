#!/usr/bin/env bash
set -euo pipefail

default_sink=$(pactl get-default-sink)
mapfile -t sinks < <(
    pactl -f json list sinks |
        jq -r '.[] | "\(.name)\u001f\(.description // .name)"'
)

labels=()
names=()

for entry in "${sinks[@]}"; do
    name=${entry%%$'\x1f'*}
    description=${entry#*$'\x1f'}

    if [[ $name == "$default_sink" ]]; then
        labels+=("●  $description")
    else
        labels+=("   $description")
    fi

    names+=("$name")
done

selection=$(
    printf '%s\n' "${labels[@]}" |
        fuzzel --dmenu \
            --prompt='Audio Output Device > ' \
            --lines=8 \
            --width=50
) || exit 0

for i in "${!labels[@]}"; do
    [[ ${labels[$i]} == "$selection" ]] || continue

    sink=${names[$i]}
    pactl set-default-sink "$sink"

    while read -r input; do
        pactl move-sink-input "$input" "$sink" || true
    done < <(pactl -f json list sink-inputs | jq -r '.[].index')

    notify-send "Audio Output Device" "${labels[$i]#*  }"
    break
done
