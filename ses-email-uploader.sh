#!/bin/bash

# Define the directory you want to list files from
OVERWRITE=false

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --directory)
      DIRECTORY="$2"
      shift 2
      ;;
    --overwrite)
      OVERWRITE=true
      shift
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Check if the directory parameter is provided
if [ -z "$DIRECTORY" ]; then
  echo "Error: --directory parameter is required."
  exit 1
fi

# Check if the directory exists
if [ -d "$DIRECTORY" ]; then
  # Loop through all files in the directory
  for FILE in "$DIRECTORY"/*; do
    # Check if it's a file (not a directory)
    if [ -f "$FILE" ]; then
      # Get the base name of the file (without the path)
      BASENAME=$(basename "$FILE")
      # Remove the extension from the file name
      TEMPLATE_NAME="${BASENAME%.*}"

      # Attempt to create the SES template
      echo "--------------------------------------------------"
      echo "Creating template: $TEMPLATE_NAME"
      aws ses create-template --cli-input-json file://"$FILE"

      # Check if the command failed (e.g., template already exists)
      if [ $? -ne 0 ]; then
        if [ "$OVERWRITE" = false ]; then
		echo "Template $TEMPLATE_NAME already exists, OVERWRITE is false, Skipping..."
		continue
	else
		echo "Template $TEMPLATE_NAME already exists, replacing..."
	       	aws ses delete-template --template-name "$TEMPLATE_NAME"
	        aws ses create-template --cli-input-json file://"$FILE"
        fi
	if [ $? -ne 0 ]; then
          echo "Failed to recreate template: $TEMPLATE_NAME"
        else
          echo "Template created successfully: $TEMPLATE_NAME"
      	fi
      fi
    fi
done

else
  echo "Directory $DIRECTORY does not exist."
fi
