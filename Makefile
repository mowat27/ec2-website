# See https://tech.davis-hansson.com/p/make/ for a write-up of these settings

# Use bash and set strict execution mode
SHELL:=bash
.SHELLFLAGS := -eu -o pipefail -c

MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

TERRAFORM_DEPS := $(wildcard ./*.tf) $(wildcard ./*.tfvars)

.PHONY: server deploy apply apply! destroy destroy!

user-data.sh: $(wildcard website/*)
	website/compile.py > user-data.sh

apply: user-data.sh $(TERRAFORM_DEPS)
	terraform apply

apply!: user-data.sh $(TERRAFORM_DEPS)
	terraform apply --auto-approve

destroy:
	terraform destroy

destroy!:
	terraform destroy --auto-approve


server: 
	python -m http.server --directory website

	