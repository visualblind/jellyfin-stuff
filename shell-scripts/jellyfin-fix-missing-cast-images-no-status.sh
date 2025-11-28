#!/bin/bash

API_KEY="YourApiKey"
BASE_URL="https://jellyfin.example.com"
USER="TheUsernameYouLogInWith"
#Go to https://jellyfin.example.com/web/#/dashboard/users and "rightclick > copy link" on your portrait to get your user ID
#Example user ID:
#USERID="31fd53576d384b288d055549dad87a4a"
USERID="YourUserId"

# Fetch all persons
response=$(curl -s "${BASE_URL}/emby/Persons?api_key=${API_KEY}")

# Filter persons with empty ImageTags, sort by Id, and remove duplicates
ids=$(echo "$response" | jq -r '.Items[] | select(.ImageTags == null or .ImageTags == {}) | .Id' | sort -u)

# Fetch details for each person
for id in $ids; do
    curl -s "${BASE_URL}/Users/${USERID}/Items/${id}?api_key=${API_KEY}"
done