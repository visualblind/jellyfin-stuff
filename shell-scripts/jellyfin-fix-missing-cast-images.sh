#!/bin/bash

# API endpoint and your API key
# api_url="http://172.16.16.11:8096/emby" (dont forget the "/emby".. even though you use Jellyfin)
# api_key="xaxajsklujkjaskjaklsjokajss"
# user_id="kjkhkjahdjhsakjdhsakjdhkasd"

api_url="http://X.X.X.X:8096/emby"
api_key=""
user_id=""

server_ip=$(echo "$api_url" | sed -E 's#^https?://([^:/]+).*$#\1#')

# --- ANSI escape codes for colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# --- Check for force flag ---
force_flag=false
if [[ "$1" == "--force" ]]; then
  force_flag=true
fi

# --- Check server ping ---
if ping -c 1 "$server_ip" > /dev/null 2>&1; then
  echo -e "${GREEN}✔ Server is reachable.${NC}"/*************
else
  echo -e "${RED}✘ Server is not reachable. Exiting.${NC}"
  exit 1
fi

# --- Fetch person data ---
person_data=$(curl -s -w "\n%{http_code}" "$api_url/Persons?api_key=$api_key")
status_code=$(echo "$person_data" | tail -n 1)
person_data=$(echo "$person_data" | sed '$d')

if [[ "$status_code" == "200" ]]; then
  echo -e "${GREEN}✔ Successfully retrieved person data.${NC}"
else
  echo -e "${RED}✘ Failed to retrieve person data. Server response code: $status_code${NC}"
  exit 1
fi

# --- Count the total number of persons ---
total_persons=$(echo "$person_data" | jq -r '.Items | length')
echo -e "Total number of persons: ${YELLOW}$total_persons${NC}"

# --- Process persons based on force flag ---
if [[ "$force_flag" == true ]]; then
  echo "Processing all persons (force flag enabled)."
  jq_expression='.Items[] | .Id'  # Process all persons
else
  echo "Processing only persons without ImageTags."
  jq_expression='.Items[] | select(.ImageTags == null) | .Id'  # Filter for those without ImageTags
fi

# --- Get the count of persons to be processed ---
persons_to_process=$(echo "$person_data" | jq -r "$jq_expression" | wc -l)

# --- Progress bar function ---
show_progress_bar() {
  local current=$1
  local total=$2
  local bar_length=50
  local filled_length=$((($current * $bar_length) / $total))
  local remaining_length=$((bar_length - filled_length))
  local bar=$(printf "%${filled_length}s" '' | tr ' ' '=')
  local remaining=$(printf "%${remaining_length}s" '' | tr ' ' '-')
  local color=$3  # Color for the progress bar
  printf "\r${color}Progress:${NC} [%s%s] %d/%d" "$bar" "$remaining" "$current" "$total"
}

# --- Process each person ID  ---
if [[ "$persons_to_process" -gt 0 ]]; then
  current_person=0
  consecutive_errors=0
  echo "$person_data" | jq -r "$jq_expression" | while read -r person_id; do 
    response=$(curl -s -w "\n%{http_code}" "$api_url/Users/$user_id/Items/$person_id?api_key=$api_key")
    person_details=$(echo "$response" | sed '$d')
    status_code=$(echo "$response" | tail -n 1)

    if [[ "$status_code" == "200" ]]; then
      ((current_person++))
      consecutive_errors=0
      show_progress_bar "$current_person" "$persons_to_process" "$GREEN"
    else
      ((consecutive_errors++))
      show_progress_bar "$current_person" "$persons_to_process" "$RED"
      echo -e "\n${RED}✘ Error processing person ID '$person_id'. Server response code: $status_code${NC}"
      if [[ "$consecutive_errors" -ge 10 ]]; then
        echo -e "${RED}✘ Too many consecutive errors. Stopping.${NC}"
        exit 1
      fi
    fi
  done
  printf "\n" # Print a newline after the progress bar
else
  if [[ "$force_flag" == true ]]; then
    echo "No persons found." # If --force is used and no persons are found
  else
    echo "No persons found without ImageTags."
  fi
fi
