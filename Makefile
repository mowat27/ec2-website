# See https://tech.davis-hansson.com/p/make/ for a write-up of these settings

# Use bash and set strict execution mode
SHELL:=bash
.SHELLFLAGS := -eu -o pipefail -c

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: server deploy

user-data.sh: $(wildcard website/*)
	website/compile.py > user-data.sh

apply: user-data.sh $(wildcard ./*.tf) $(wildcard ./*.tfvars)
	terraform apply

server: 
	python -m http.server --directory website

	