#!/bin/bash

# Prompt for MFA code
read -p "Enter the MFA code: " CODE

# Fetch session token using AWS CLI and parse the JSON output with jq
SESSION_TOKEN=$(aws sts get-session-token --profile new-work-se-user --token-code $CODE --serial-number "arn:aws:iam::676206941382:mfa/new-work-se" | jq -r '.Credentials | .AccessKeyId, .SecretAccessKey, .SessionToken')

# Check if the command was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to get session token."
  exit 1
fi

# Extract the AWS credentials from the response
AWS_ACCESS_KEY_ID=$(echo "$SESSION_TOKEN" | sed -n '1p')
AWS_SECRET_ACCESS_KEY=$(echo "$SESSION_TOKEN" | sed -n '2p')
AWS_SESSION_TOKEN=$(echo "$SESSION_TOKEN" | sed -n '3p')

#export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
#export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
#export AWS_SESSION_TOKEN="$AWS_SESSION_TOKEN"

# Output the environment variable export commands
echo "export AWS_ACCESS_KEY_ID=\"$AWS_ACCESS_KEY_ID\""
echo "export AWS_SECRET_ACCESS_KEY=\"$AWS_SECRET_ACCESS_KEY\""
echo "export AWS_SESSION_TOKEN=\"$AWS_SESSION_TOKEN\""

echo "Please copy and execute in your local"