#!/bin/bash

TEXT=""
FONT_NAME=""
CACHE_DIR="$HOME/.cache/figletfonts/"
BASE_URL="https://raw.githubusercontent.com/xero/figlet-fonts/refs/heads/master"

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --text) TEXT="$2"; shift ;;
        --font) FONT_NAME="$2"; shift ;;
        *) exit 1 ;;
    esac
    shift
done

FONT_NAME=$(echo "$FONT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/^\(.\)/\U\1/')

if [[ -z "$TEXT" ]]; then
    echo 'Warning: Invalid Text Provided'
    echo 'Usage: (figletf --text "enter_text_here" --font "font_name")'
    exit 1
fi

if [[ -z "$FONT_NAME" ]]; then
    echo 'Warning: Invalid Font Provided'
    echo 'Usage: (figletf --text "enter_text_here" --font "font_name")'
    exit 1
fi

FONT_PATH="$CACHE_DIR/$FONT_NAME.flf"

mkdir -p "$CACHE_DIR"

if [[ ! -f "$FONT_PATH" ]]; then
    FONT_URL="$BASE_URL/$FONT_NAME.flf"
    HTTP_STATUS=$(curl -s -o "$FONT_PATH" -w "%{http_code}" "$FONT_URL")

    if [[ "$HTTP_STATUS" -ne 200 ]]; then
        rm -f "$FONT_PATH"
        echo "Error: Font '$FONT_NAME' could not be downloaded (HTTP Status: $HTTP_STATUS). Check the font name."
        exit 1
    fi
fi

figlet -f "$FONT_PATH" "$TEXT"
