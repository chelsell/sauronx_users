#!/bin/zsh
screen_session_names=(
	"valinor"
	"airflow"
	"caddy"
	"airflow_webserver"
)

screen_commands=(
	"cd /data/repos/valar; sbt run"
	"airflow scheduler"
	"caddy run --config /etc/caddy/Caddyfile"
	"airflow webserver -p 8080"
)

# Function to create screen sessions based on arrays
create_screen_sessions() {
    local num_sessions=${#screen_session_names[@]}
    
    for ((i=1; i<=$num_sessions; i++)); do
        local session_name=${screen_session_names[$i]}
        local command_to_run="${screen_commands[$i]}"
        
        # Check if session already exists
        local session_check=$(screen -ls | grep -w "${session_name}")
        if [[ -n "$session_check" ]]; then
            echo "Screen session '${session_name}' already exists. Skipping..."
        else
            echo "Launching new screen session '${session_name}'..."
            screen -S $session_name -dm zsh -c "${command_to_run}"
            echo "Command '${command_to_run}' started in session '${session_name}'."
        fi
    done
}

# Call function to create screen sessions
create_screen_sessions
