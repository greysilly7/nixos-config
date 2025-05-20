#!/usr/bin/env bash

# Rofi base command
ROFI_BASE="rofi -dmenu -i -lines 15 -width 50"
# Notify base command
NOTIFY_CMD="notify-send"

# Detect if Wi-Fi is enabled
wifi_enabled() {
    nmcli radio wifi | grep -q enabled
}

# Check if currently connected to a Wi-Fi network
is_connected() {
    # Checks if there's an active Wi-Fi connection that outputs a name
    nmcli -t -f NAME,DEVICE,TYPE con show --active | awk -F: 'BEGIN{IGNORECASE=1} $3 == "wifi" || $3 == "802-11-wireless" {print $1; exit}' | grep -q .
}

# List Wi-Fi networks
list_networks() {
    nmcli -t -f active,ssid,signal,freq dev wifi |
        awk -F: '{
            ssid = ($2 == "" ? "<Hidden Network>" : $2);
            marker = ($1 == "yes" ? "*" : " ");
            freq_mhz = $4;
            band = "";
            if (freq_mhz > 5000) {
                band = "5GHz";
            } else if (freq_mhz > 2000) {
                band = "2.4GHz";
            }
            # Ensure consistent spacing for alignment if desired
            # Output format: * SSID (Signal%) [Band]
            if (band != "") {
                printf "%s %s (%s%%) [%s]\n", marker, ssid, $3, band;
            } else {
                printf "%s %s (%s%%)\n", marker, ssid, $3;
            }
        }'
}

# Extract SSID cleanly
parse_ssid() {
    # $1: The selected line from list_networks, e.g., "* MySSID (75%) [5GHz]"
    echo "$1" | sed -E 's/^\*? *//; s/ \([0-9]+%\)( \[[25]\.[0-9]?GHz\])?$//'
}

# Prompt for SSID (for hidden networks)
prompt_ssid() {
    $ROFI_BASE -p "Enter SSID"
}

# Prompt for password
prompt_password() {
    # Use Rofi's password mode to obscure input
    $ROFI_BASE -password -p "Password for $1"
}

# List saved Wi-Fi connections
list_saved_wifi_connections() {
    nmcli -t -f NAME,TYPE con show | grep ':wifi$' | cut -d: -f1
}

# Forget a selected Wi-Fi network
forget_network_menu() {
    saved_networks=$(list_saved_wifi_connections)
    if [ -z "$saved_networks" ]; then
        "$NOTIFY_CMD" "No saved Wi-Fi networks to forget."
        return
    fi

    selected_network_to_forget=$(echo "$saved_networks" | $ROFI_BASE -p "Forget Wi-Fi")
    if [ -z "$selected_network_to_forget" ]; then
        "$NOTIFY_CMD" "Forget operation cancelled."
        return
    fi

    if nmcli con delete id "$selected_network_to_forget"; then
        "$NOTIFY_CMD" "Network '$selected_network_to_forget' forgotten."
    else
        "$NOTIFY_CMD" "Error: Failed to forget network '$selected_network_to_forget'."
    fi
}

# View details of the current Wi-Fi connection
view_connection_details() {
    active_connection_info=$(nmcli -t -f NAME,DEVICE,TYPE con show --active | awk -F: 'BEGIN{IGNORECASE=1} ($3 == "wifi" || $3 == "802-11-wireless") {print $1 ":" $2; exit}')

    if [ -z "$active_connection_info" ]; then
        "$NOTIFY_CMD" "Not connected to any Wi-Fi network."
        return
    fi

    active_connection_name=$(echo "$active_connection_info" | cut -d: -f1)
    active_device=$(echo "$active_connection_info" | cut -d: -f2)

    details_raw=$(nmcli con show id "$active_connection_name")

    # Extract details using grep and sed for cleaner parsing
    ssid=$(echo "$details_raw" | grep 'connection.id:' | sed -E 's/^[^:]+:[ \t]*//')
    security=$(echo "$details_raw" | grep 'wifi-sec.key-mgmt:' | sed -E 's/^[^:]+:[ \t]*//')
    ip_address=$(echo "$details_raw" | grep 'IP4.ADDRESS\[1\]:' | sed -E 's/^[^:]+:[ \t]*//')
    gateway=$(echo "$details_raw" | grep 'IP4.GATEWAY:' | sed -E 's/^[^:]+:[ \t]*//')
    # Consolidate multiple DNS entries into one line
    dns_servers=$(echo "$details_raw" | grep 'IP4.DNS\[' | sed -E 's/^[^:]+:[ \t]*//' | paste -sd ',' -)


    signal=""
    band=""
    # Get current signal and band for the active connection on the specific device
    current_net_info=$(nmcli -t -f IN-USE,SSID,SIGNAL,FREQ dev wifi list ifname "$active_device" 2>/dev/null | grep '^\*:' )
    if [ -n "$current_net_info" ]; then
        signal=$(echo "$current_net_info" | cut -d: -f3)
        freq_mhz=$(echo "$current_net_info" | cut -d: -f4)
        if [ -n "$freq_mhz" ]; then
            if [ "$freq_mhz" -gt 5000 ]; then
                band="5GHz"
            elif [ "$freq_mhz" -gt 2000 ]; then
                band="2.4GHz"
            fi
        fi
    fi

    # Prepare formatted details for Rofi
    formatted_details="SSID: $ssid\n"
    formatted_details+="Interface: $active_device\n"
    [ -n "$signal" ] && formatted_details+="Signal: $signal%\n"
    [ -n "$band" ] && formatted_details+="Band: $band\n"
    [ -n "$security" ] && formatted_details+="Security: $security\n"
    [ -n "$ip_address" ] && formatted_details+="IP Address: $ip_address\n"
    [ -n "$gateway" ] && formatted_details+="Gateway: $gateway\n"
    [ -n "$dns_servers" ] && formatted_details+="DNS: $dns_servers\n"

    # Use rofi to display details in a message box
    echo -e "$formatted_details" | rofi -dmenu -mesg "Connection Details" -p "Press Enter or Esc to close" > /dev/null
}

# Disconnect from current Wi-Fi
disconnect_wifi() {
    current_connection_info=$(nmcli -t -f active,ssid dev wifi | grep '^yes:')
    if [ -n "$current_connection_info" ]; then
        current_ssid=$(echo "$current_connection_info" | cut -d: -f2)
        # Attempt to disconnect using the connection ID (SSID in this case)
        if nmcli con down id "$current_ssid"; then
            "$NOTIFY_CMD" "Disconnected from $current_ssid"
        else
            "$NOTIFY_CMD" "Error: Failed to disconnect from $current_ssid"
        fi
    else
        "$NOTIFY_CMD" "Not connected to any Wi-Fi network"
    fi
}

# Main menu
main_menu() {
    local menu_options=""

    if wifi_enabled; then
        menu_options+="󰤨 Scan Networks\n"
        menu_options+="󰑤 Rescan Wi-Fi\n"

        if is_connected; then
            menu_options+="󰋼 Connection Details\n"
            menu_options+="󰤭 Disconnect\n"
        fi
        menu_options+="󰍛 Toggle Wi-Fi Off\n"
    else
        menu_options+="󰍛 Toggle Wi-Fi On\n"
    fi

    menu_options+="󰤬 Forget Network\n" # Always available
    menu_options+=" Exit"

    echo -e "$menu_options"
}

# Start the script
main() {
    choice=$(main_menu | $ROFI_BASE -p "Network")

    case "$choice" in
        "󰤨 Scan Networks")
            if ! wifi_enabled; then
                "$NOTIFY_CMD" "Wi-Fi is turned off. Please enable it first."
                exit 1
            fi

            networks_list=$(list_networks)
            if [ -z "$networks_list" ]; then
                "$NOTIFY_CMD" "No Wi-Fi networks found."
                exit 0
            fi

            selected=$(echo "$networks_list" | $ROFI_BASE -p "Wi-Fi")
            [ -z "$selected" ] && exit 0 # User cancelled Rofi

            ssid=$(parse_ssid "$selected")

            if [ "$ssid" = "<Hidden Network>" ]; then
                ssid_hidden=$(prompt_ssid)
                if [ -z "$ssid_hidden" ]; then
                    "$NOTIFY_CMD" "SSID entry cancelled."
                    exit 0
                fi
                ssid="$ssid_hidden" # Update ssid with user input
            fi

            # Check if already connected to this SSID or if a known connection exists
            if nmcli -t -f active,ssid dev wifi | grep -q "^yes:$ssid$"; then
                "$NOTIFY_CMD" "Already connected to $ssid"
                exit 0
            fi

            # Try connecting with an existing known connection profile for this SSID
            if nmcli con up id "$ssid" >/dev/null 2>&1; then
                "$NOTIFY_CMD" "Connected to $ssid"
                exit 0
            fi

            # If not connected and no existing profile worked, prompt for password
            password=$(prompt_password "$ssid")
            # Check if password prompt was cancelled (rofi returns empty string)
            if [ -z "$password" ] && [ "$password" != " " ]; then # Allow space as password, though unlikely
                 "$NOTIFY_CMD" "Password entry cancelled."
                 exit 0
            fi

            if nmcli dev wifi connect "$ssid" password "$password"; then
                "$NOTIFY_CMD" "Successfully connected to $ssid"
            else
                "$NOTIFY_CMD" "Error: Failed to connect to $ssid. Check password or signal."
            fi
            ;;
        "󰑤 Rescan Wi-Fi")
            if ! wifi_enabled; then
                "$NOTIFY_CMD" "Wi-Fi is turned off. Cannot rescan."
            elif nmcli dev wifi rescan; then
                "$NOTIFY_CMD" "Wi-Fi rescanned."
            else
                "$NOTIFY_CMD" "Error: Failed to rescan Wi-Fi."
            fi
            main # Call main again to show the menu
            ;;
        "󰋼 Connection Details")
            view_connection_details
            main # Call main again to show the menu
            ;;
        "󰤬 Forget Network")
            forget_network_menu
            main # Call main again to show the menu
            ;;
        "󰍛 Toggle Wi-Fi On")
            if ! wifi_enabled; then
                if nmcli radio wifi on; then
                    "$NOTIFY_CMD" "Wi-Fi turned on"
                else
                    "$NOTIFY_CMD" "Error: Failed to turn Wi-Fi on"
                fi
            else
                "$NOTIFY_CMD" "Wi-Fi is already on." # Should not be reachable if menu logic is correct
            fi
            main # Call main again to show the menu
            ;;
        "󰍛 Toggle Wi-Fi Off")
            if wifi_enabled; then
                if nmcli radio wifi off; then
                    "$NOTIFY_CMD" "Wi-Fi turned off"
                else
                    "$NOTIFY_CMD" "Error: Failed to turn Wi-Fi off"
                fi
            else
                "$NOTIFY_CMD" "Wi-Fi is already off." # Should not be reachable
            fi
            main # Call main again to show the menu
            ;;
        "󰤭 Disconnect")
            disconnect_wifi
            main # Call main again to show the menu
            ;;
        " Exit")
            exit 0
            ;;
        *)
            # Handle empty choice from Rofi (e.g., Esc pressed)
            if [ -z "$choice" ]; then
                exit 0
            fi
            "$NOTIFY_CMD" "Invalid option selected"
            exit 1
            ;;
    esac
}

main