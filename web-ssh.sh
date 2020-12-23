#!/usr/bin/env bash

if [[ -f env.sh ]]; then
  source ./env.sh
fi

if [[ -z $SSH_IDENTITY ]]; then 
  echo >&2 "Please set SSH_IDENTITY to a valid ssh key first"
  exit 1
fi

ssh-add "$SSH_IDENTITY"
ssh -A ec2-user@"$(terraform output -json | jq -r '.web_server_public_ip.value')"

