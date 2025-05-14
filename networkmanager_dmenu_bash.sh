#!/usr/bin/env bash

ROFI="rofi -dmenu -i -p"
NOTIFY="notify-send"

# Detect if Wi-Fi is enabled
wifi_enabled() {
    nmcli radio wifi | grep -q enabled
}

# Toggle Wi-Fi state
toggle_wifi() {
    if wifi_enabled; then
        nmcli radio wifi off && $NOTIFY "Wi-Fi turned off"
    else
        nmcli radio wifi on && $NOTIFY "Wi-Fi turned on"
    fi
}

# List Wi-Fi networks
list_networks() {
    nmcli -t -f active,ssid,signal dev wifi |
        awk -F: '{
            ssid = ($2 == "" ? "<Hidden Network>" : $2);
            marker = ($1 == "yes" ? "*" : " ");
            print marker " " ssid " (" $3 "%)";
        }' | uniq
}

# Extract SSID cleanly
parse_ssid() {
    echo "$1" | sed -E 's/^\*? *//; s/ \(.*\)//'
}

# Prompt for SSID (for hidden networks)
prompt_ssid() {
    rofi -dmenu -p "Enter SSID"
}

# Prompt for password
prompt_password() {
    rofi -dmenu -p "Password for $1" <<< ""
}

# Disconnect from current Wi-Fi
disconnect_wifi() {
    current=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1 == "yes" {print $2}')
    if [ -n "$current" ]; then
        nmcli con down id "$current" && $NOTIFY "Disconnected from $current"
    else
        $NOTIFY "Not connected to any network"
    fi
}

# Main menu
main_menu() {
    echo -e "󰤨 Scan Networks\n󰍛 Toggle Wi-Fi\n󰤭 Disconnect\n Exit"
}

# Start the script
main() {
    choice=$(main_menu | $ROFI "Network")

    case "$choice" in
        "󰤨 Scan Networks")
            if ! wifi_enabled; then
                $NOTIFY "Wi-Fi is turned off"
                exit 1
            fi

            selected=$(list_networks | $ROFI "Wi-Fi")
            [ -z "$selected" ] && exit

            ssid=$(parse_ssid "$selected")

            # Handle hidden networks
            if [ "$ssid" = "<Hidden Network>" ]; then
                ssid=$(prompt_ssid)
                [ -z "$ssid" ] && exit
            fi

            # Try connecting with existing connection
            if nmcli con up id "$ssid" 2>/dev/null; then
                $NOTIFY "Connected to $ssid"
                exit
            fi

            # Prompt for password
            password=$(prompt_password "$ssid")
            [ -z "$password" ] && $NOTIFY "Canceled" && exit

            if nmcli dev wifi connect "$ssid" password "$password"; then
                $NOTIFY "Connected to $ssid"
            else
                $NOTIFY "Failed to connect to $ssid"
            fi
            ;;
        "󰍛 Toggle Wi-Fi")
            toggle_wifi
            ;;
        "󰤭 Disconnect")
            disconnect_wifi
            ;;
        " Exit")
            exit
            ;;
    esac
}

main
