#!/usr/bin/env bash

hyprctl devices -j | jq -r '.keyboards[].name' | while read -r kb; do hyprctl switchxkblayout "$kb" next; done
