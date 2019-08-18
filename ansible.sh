#!/bin/bash
TF_STATE=. ansible-playbook --private-key=/path/to/ec2user/key \
--inventory-file=$(which terraform-inventory) \
--extra-vars="$(terraform show -json ./terraform.tfstate | jq -r '[ .values.root_module.resources[] | (.address | gsub("\\."; "_"))  as $address | .values | keys[] as $k | "\($address)__\($k)='\''\(.[$k])'\''" ] | join(" ")')" \
wordpress.yml 