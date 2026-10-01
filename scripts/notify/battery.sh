#!/usr/bin/env bash

get_battery_status() {
    for bat in /sys/class/power_supply/BAT*; do
        if [ -d "$bat" ] && [ -f "$bat/capacity" ] && [ -f "$bat/status" ]; then
            local capacity=$(cat "$bat/capacity")
            local status=$(cat "$bat/status")
            
            case "$status" in
                Charging)     status_text="Заряжается" ;;
                Discharging)  status_text="Разряжается" ;;
                Full)         status_text="Полностью заряжена" ;;
                "Not charging") status_text="Не заряжается" ;;
                *)            status_text="$status" ;;
            esac

            notify-send "Заряд: ${capacity}% ($status_text)" -t 1250
            return 0
        fi
    done
    notify-send "Батарея не найдена" -t 1250
    return 1
}

get_battery_status
