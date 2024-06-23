#!/bin/zsh

# Replace with your SSH server details
host="valinor2"
port=22  # Default SSH port is 22
username="root"
conda_env="sauronlab"

screen_session_name="test"
command_to_run_in_screen="htop"  # Command to run in the screen session

# Function to SSH into the remote server, check for existing screen session, and launch if necessary
ssh_and_launch_screen() {
    # Check if there's an existing SSH process for the specified host and port
    if pgrep -f "ssh -p $port $username@$host" >/dev/null; then
        echo "SSH connection to $host:$port as $username is already open."
    else
        #echo "Opening new SSH connection to $host:$port as $username..."

       local session_check=$(ssh ${username}@${host} "screen -ls | grep ${screen_session_name}")

       if [[ -n "$session_check" ]]; then
          echo "Screen session '${screen_session_name}' already exists."
       else
          gnome-terminal -- /bin/zsh -c "ssh -p $port $username@$host" #; source /home/root/.zshrc; screen -S ${screen_session_name} -d -m zsh '${command_to_run_in_screen}'"
       fi
    fi
}

# Call function to SSH into the remote server and launch or reconnect to the screen session
ssh_and_launch_screen

check_ssh_connection() {
    # Check if there's an existing SSH process for the specified host and port
    if pgrep -f "ssh -p $port $username@$host" >/dev/null; then
        echo "SSH connection to $host:$port as $username is already open."
    else
        #echo "Opening new SSH connection to $host:$port as $username..."
        open_new_terminal_and_ssh
    fi
}

open_new_terminal_and_ssh() {
    gnome-terminal -- /bin/zsh -c "ssh -p $port $username@$host"
}


# Call function to attempt SSH connection within a new terminal window
#check_ssh_connection

# initialize the conda environment
/bin/zsh -c "source /home/cole/.zshrc; source \$(conda info --base)/etc/profile.d/conda.sh; conda activate $conda_env; zsh"
