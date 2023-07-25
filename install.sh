#!/usr/bin/env bash

REMARKABLE_HOST=remarkable
EPOCH=$(date +'%s')

echo "copying templates"
scp templates/pngs/*.png $REMARKABLE_HOST:/usr/share/remarkable/templates

echo "updating templates.json"
scp $REMARKABLE_HOST:/usr/share/remarkable/templates/templates.json ./reference/templates.json
jq -n '{ templates: [ inputs.templates ] | add | unique_by(.name)}' ./reference/templates.json templates.addition.json >templates.merged.json
ssh $REMARKABLE_HOST \
	"cp /usr/share/remarkable/templates/templates.json /usr/share/remarkable/templates/templates.json.${EPOCH}.bak"
scp templates.merged.json $REMARKABLE_HOST:/usr/share/remarkable/templates/templates.json
rm templates.merged.json

# Restarting the GUI service
ssh $REMARKABLE_HOST "systemctl restart xochitl"
