
prefix ?= /usr/local
# fall back to /etc, ignoring prefix
sysconfdir ?= /etc

export PYTHON ?= python2
RST2MAN ?= rst2man

version ?= $(shell git describe --dirty 2> /dev/null | cut -b2-)
version := $(if $(version),$(version),devel)

install-deps := git-hub git-hub.1 ftdetect.vim bash-completion README.rst

.PHONY: default
default: all

.PHONY: all
all: man bash-completion

.PHONY: deb
deb: $(install-deps)
	$(MAKE) prefix=/usr DESTDIR=deb/install install
	deb/build

.PHONY: man
man: git-hub.1

git-hub.1: man.rst git-hub
	sed 's/^:Version: devel$$/:Version: $(version)/' $< | \
		$(RST2MAN) --exit-status=1 > $@ || ($(RM) $@ && false)

bash-completion: generate-bash-completion git-hub
	./$^ > $@ || ($(RM) $@ && false)

.PHONY: install
install: $(install-deps)
	install -m 755 -D git-hub $(DESTDIR)$(prefix)/bin/git-hub
	sed -i 's/^VERSION = "git-hub devel"$$/VERSION = "git-hub $(version)"/' \
			$(DESTDIR)$(prefix)/bin/git-hub
	sed -i 's|^#!/usr/bin/env python2$$|#!/usr/bin/env $(PYTHON)|' \
			$(DESTDIR)$(prefix)/bin/git-hub
	install -m 644 -D git-hub.1 $(DESTDIR)$(prefix)/share/man/man1/git-hub.1
	install -m 644 -D ftdetect.vim \
		$(DESTDIR)$(prefix)/share/vim/addons/ftdetect/githubmsg.vim
	install -m 644 -D bash-completion $(DESTDIR)$(sysconfdir)/bash_completion.d/git-hub
	install -m 644 -D README.rst $(DESTDIR)$(prefix)/share/doc/git-hub/README.rst

.PHONY: release
release:
	@read -p "Enter version (previous: $$(git describe --abbrev=0)): " version; \
	test -z $$version && exit 1; \
	msg=`echo $$version | sed 's/v/Version /;s/-rc/ Release Candidate /'`; \
	echo ; \
	echo Changelog: ; \
	git log --format='* %s (%h)' `git describe --abbrev=0 HEAD^`..HEAD; \
	echo ; \
	set -x; \
	git tag -a -m "$$msg" $$version

.PHONY: clean
clean:
	$(RM) -r git-hub.1 bash-completion deb/*.deb deb/install

