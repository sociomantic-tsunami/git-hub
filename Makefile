
prefix ?= /usr/local

.PHONY: default
default: all

.PHONY: all
all: man

.PHONY: man
man: git-hub.1

git-hub.1: man.rst
	rst2man $^ > $@

.PHONY: install
install: idir := $(DESTDIR)$(prefix)
install: git-hub git-hub.1
	install -m 755 -D git-hub $(idir)/bin/git-hub
	install -D git-hub.1 $(idir)/share/man/man1/git-hub.1

.PHONY: clean
clean:
	$(RM) git-hub.1

