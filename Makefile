
prefix ?= /usr/local

deb_version := $(shell sed -n '1 s/^git-hub (\(.*\)) .*/v\1/p' debian/changelog)
sem_version := $(shell echo $(deb_version) | tr '~' '-')
git_version := $(shell git describe 2> /dev/null)
version := $(if $(git_version),$(git_version),$(sem_version))

.PHONY: default
default: all

.PHONY: all
all: man bash-completion

.PHONY: deb
deb:
	debuild -uc -us -tc

.PHONY: man
man: git-hub.1

git-hub.1: man.rst git-hub
	sed 's/^:Version: devel$$/:Version: $(version)/' $< | \
		rst2man --exit-status=1 > $@ || ($(RM) $@ && false)

bash-completion: generate-bash-completion git-hub
	./$^ > $@ || ($(RM) $@ && false)

.PHONY: install
install: git-hub git-hub.1 ftdetect.vim bash-completion README.rst
	install -m 755 -D git-hub $(DESTDIR)$(prefix)/bin/git-hub
	sed -i 's/^VERSION = "git-hub devel"$$/VERSION = "git-hub $(version)"/' \
			$(DESTDIR)$(prefix)/bin/git-hub
	install -m 644 -D git-hub.1 $(DESTDIR)$(prefix)/share/man/man1/git-hub.1
	install -m 644 -D ftdetect.vim \
		$(DESTDIR)$(prefix)/share/vim/addons/ftdetect/githubmsg.vim
	install -m 644 -D bash-completion $(DESTDIR)/etc/bash_completion.d/git-hub
	install -m 644 -D README.rst $(DESTDIR)$(prefix)/share/doc/git-hub/README.rst

.PHONY: release
release:
	@read -p "Enter version [$(sem_version)]: " version; \
	test -z $$version && version=$(sem_version); \
	msg=`echo $$version | sed 's/v/Version /;s/-rc/ Release Candidate /'`; \
	set -x; \
	git tag -a -m "$$msg" $$version

.PHONY: clean
clean:
	$(RM) git-hub.1 bash-completion

