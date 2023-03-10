#!/bin/sh

playbook="backend.yml"

env="$1"
ssh_key="$2"

if [ -z "$env" ] || [ ! -f "$ssh_key" ]; then
  echo "Usage: $0 <env> <ssh_key>"
  exit 1
fi

if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "ansible-playbook is required but not installed" >&2
  exit 1
fi

cd -P -- "$(dirname -- "$0")"
cd ..

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook $playbook -i "./env/$env/hosts.ini" -v \
  -e "@env/$env/config.vars.yml" -e "@env/$env/secrets.vars.yml" \
  --key-file "$ssh_key" --vault-pass-file "$ssh_key"