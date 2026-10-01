# ======= PROGRAMS AND FLAGS =======
RUBY := ruby
GEM := gem
RBENV := rbenv
ENV := env
BUNDLE := bundle
EXEC := exec
JEKYLL := jekyll
SERVE := serve --watch
HOST := 127.0.0.1
# first free port starting from 4000 (override with `make serve PORT=...`)
ifndef PORT
PORT := $(shell p=4000; while ss -ltn | grep -q ":$$p "; do p=$$((p+1)); done; echo $$p)
endif
BASEURL := /nesy-auto-bench/
BUILD := build

# ======= COLORS ===================
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
NONE := \033[0m

# ======= COMMANDS =================
ECHO := echo -e
OPEN := xdg-open
MKDIR := mkdir -p

# RULES
.PHONY: help env install install-ruby serve build math

help:
	@$(ECHO) '$(YELLOW)Makefile help$(NONE)'
	@$(ECHO) " \
	* env 					: generates the virtual environment using the last version and rbenv\n \
	* install				: install the requirements listed in the Gemfile\n \
	* install-ruby				: install the last ruby version in rbenv\n \
	* serve				: build the site and make it available on a local server\n \
	* build				: build the site\n \
	* math				: render the LaTeX in _tools/index.src.md into index.md"

install-ruby:
	@export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
	@$(RBENV) install $($(RBENV) install -l | grep -v - | tail -1)
	@$(RBENV) local $($(RBENV) install -l | grep -v - | tail -1)
	@$(GEM) install bundler

install:
	@$(ECHO) '$(GREEN)Installing requirements..$(NONE)'
	@$(BUNDLE) install
	@$(ECHO) '$(GREEN)Done$(NONE)'

serve:
	@$(ECHO) '$(BLUE)Building site and making it available locally..$(NONE)'
	@(sleep 5; $(OPEN) http://$(HOST):$(PORT)$(BASEURL)) &
	@$(BUNDLE) $(EXEC) $(JEKYLL) $(SERVE) --host $(HOST) --port $(PORT)
	@$(ECHO) '$(BLUE)Done$(NONE)'

math:
	@$(ECHO) '$(BLUE)Rendering math into index.md..$(NONE)'
	@python3 _tools/build_math.py
	@$(ECHO) '$(BLUE)Done$(NONE)'

build:
	@$(ECHO) '$(BLUE)Building site..$(NONE)'
	@$(BUNDLE) $(EXEC) $(JEKYLL) $(BUILD)
	@$(ECHO) '$(BLUE)Done$(NONE)'

env:
	@$(ECHO) '$(GREEN)Generating virtual environment..$(NONE)'
	@$(MKDIR) vendor/bundle
	$(RBENV) local $(shell $(RBENV) install -l | grep -v - | tail -1)
	@$(ECHO) '$(GREEN)Enviroment created$(NONE)'
