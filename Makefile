
prefix ?= /usr/local

.PHONY: default
default: all

.PHONY: all
all: git-hub.1

git-hub.1: git-hub.1.rst
	rst2man $^ > $@

.PHONY: install
install: git-hub git-hub.1
	install -m 755 -D git-hub $(prefix)/bin/git-hub
	install -D git-hub.1 $(prefix)/share/man/man1/git-hub.1

