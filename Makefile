# Makefile for project eguisse/toolbox

SHELL := /bin/bash
# grep the version from the mix file
CURRENT_DIR := $(CURDIR)
ifeq ($(strip $(PROJECT_DIR)), )
PROJECT_DIR := $(CURRENT_DIR)
endif
export PROJECT_DIR
export CURRENT_DIR
export VERSION

# HELP
# This will output the help for each task
.PHONY: help clean build-app build run print-env

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


print-env:  ## print environment variables
	echo "PROJECT_DIR: $(PROJECT_DIR)"
	echo "CURRENT_DIR: $(CURRENT_DIR)"
	echo "VERSION: $(VERSION)"
	echo "CURDIR: $(CURDIR)"

build:  ## Build the docker image
	@echo "start build"
	docker build -t "toolbox:snapshot" -f "$(PROJECT_DIR)/Dockerfile" "$(PROJECT_DIR)"

run:  ## Run the docker image on localhost
	@echo "start run"
	if [[ ! -d "$(PROJECT_DIR)/.env" ]] ; then touch "$(PROJECT_DIR)/.env" ; fi
	mkdir -p $(PROJECT_DIR)/data
	docker run -it --rm --name toolbox --env-file .env  "toolbox:snapshot" "/bin/bash"
