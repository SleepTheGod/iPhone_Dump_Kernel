#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to get the iOS device's firmware version
get_ios_firmware_version() {
    if [[ -f /var/mobile/Library/Preferences/com.apple.SystemConfiguration.plist ]]; then
        firmware_version=$(defaults read /var/mobile/Library/Preferences/com.apple.SystemConfiguration.plist ProductVersion)
    elif command_exists ideviceinfo; then
        firmware_version=$(ideviceinfo -s ProductVersion)
    else
        echo "Error: Unable to retrieve firmware version. Please ensure you have the appropriate tools or permissions."
        exit 1
    fi
    echo "$firmware_version"
}

# Function to get device information
get_device_info() {
    if command_exists ideviceinfo; then
        echo "Gathering device information..."
        ideviceinfo || echo "Error: Failed to gather device information."
    else
        echo "Error: ideviceinfo command not found. Please install it to gather device information."
    fi
}

# Function to execute a command and handle errors
execute_command() {
    local command="$1"
    local output
    output=$(eval "$command" 2>&1)
    local status=$?
    if [ $status -ne 0 ]; then
        echo "Error executing command: $command"
        echo "Output: $output"
        return 1
    fi
    echo "$output"
    return 0
}

# Function to get a custom command from the user
get_user_command() {
    echo "Please enter the command you want to execute on the iOS device:"
    read -r user_command
    if [[ -z "$user_command" ]]; then
        echo "No command entered. Exiting."
        exit 1
    fi
    echo "$user_command"
}

# Function to perform tasks based on the firmware version
perform_tasks_based_on_firmware() {
    local firmware_version="$1"
    
    echo "Performing tasks based on iOS firmware version: $firmware_version"

    case "$firmware_version" in
        15.*)
            echo "You are running iOS 15.x. Executing iOS 15 specific commands..."
            # Example command for iOS 15
            execute_command "ideviceinfo -s ActivationState"
            ;;
        14.*)
            echo "You are running iOS 14.x. Executing iOS 14 specific commands..."
            # Example command for iOS 14
            execute_command "ideviceinfo -s SerialNumber"
            ;;
        13.*)
            echo "You are running iOS 13.x. Executing iOS 13 specific commands..."
            # Example command for iOS 13
            execute_command "ideviceinfo -s ModelNumber"
            ;;
        *)
            echo "Unknown or unsupported iOS version: $firmware_version"
            ;;
    esac
}

# Main function
main() {
    echo "Welcome to the iOS Debugging Script!"
    echo "This script will help you execute commands on your iOS device based on its firmware version."

    # Get the firmware version
    local firmware_version
    firmware_version=$(get_ios_firmware_version)
    echo "Detected iOS firmware version: $firmware_version"

    # Gather device information
    get_device_info

    # Perform tasks based on the firmware version
    perform_tasks_based_on_firmware "$firmware_version"

    # Get a custom command from the user
    local user_command
    user_command=$(get_user_command)

    # Final command to be executed
    local final_cmd="$user_command"

    # Execute the final command
    if output=$(execute_command "$final_cmd"); then
        echo "Command executed successfully: $final_cmd"
        echo "Output: $output"
    else
        exit 1
    fi
}

# Check for required commands before running the main function
if ! command_exists defaults && ! command_exists ideviceinfo; then
    echo "Error: Required commands 'defaults' or 'ideviceinfo' not found. Please install them to proceed."
    exit 1
fi

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please try again with 'sudo'."
    exit 1
fi

# Run the main function
main "$@"
