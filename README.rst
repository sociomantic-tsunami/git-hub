======================================
A Git command line interface to GitHub
======================================

.. contents::
   :depth: 1
   :local:


Description
===========

**git hub** is a simple command line interface to GitHub_, enabling most useful
GitHub_ tasks (like creating and listing pull request or issues) to be accessed
directly through the Git_ command line.

Although probably the most outstanding feature (and the one that motivated the
creation of this tool) is the ``pull rebase`` command, which is the *rebasing*
version of the `GitHub Merge (TM) button`__. This enables an easy workflow that
doesn't involve thousands of merges which makes the repository history
unreadable.

__ https://github.com/blog/843-the-merge-button

Another *unique* feature is the ability to transform an issue into a pull
request by attaching commits to it (this is something offered by the `GitHub
API`__ but not by the web interface).

__ http://developer.github.com/


Usage
=====

Here are some usage examples, for more information about all the supported
command an options, please refer to the man page using ``git hub --help`` or
looking at the `online version`__ (this is for the latest development snapshot
though).

__ https://github.com/sociomantic/git-hub/blob/master/man.rst

One time global setup to get the credentials
--------------------------------------------
::

  $ git hub setup --global --user octocat
  GitHub password (will not be stored):

You can revoke this credentials at any time in the `GitHub Applications Settings
page`__.

__ https://github.com/settings/applications

Clone (and fork) a project
--------------------------
::

  $ git hub clone sociomantic/git-hub
  Forking sociomantic/playground to octocat/git-hub
  Cloning git@github.com:octocat/git-hub.git to git-hub
  Fetching from upstream (git@github.com:sociomantic/git-hub.git)

The fork will happen only if you haven't fork the project before, of course.

Using a pre-existing cloned repository
--------------------------------------
::

  $ git config hub.upstream sociomantic/git-hub

This sets the *master* GitHub_ project. It's where we query for issues and pull
requests and where we create new pull requests, etc.

This is only necessary if you didn't clone your repository using ``git hub
clone`` and is a one time only setup step.

List issues
-----------
::

  $ git hub issue list
  [3] pull: Use the tracking branch as default base branch (leandro-lucarella-sociomantic)
      https://github.com/sociomantic/git-hub/issues/3
  [1] bash-completion: Complete with IDs only when is appropriate according to command line arguments (leandro-lucarella-sociomantic)
      https://github.com/sociomantic/git-hub/issues/1

Update an issue
---------------
::

  $ git hub issue update --label important --label question \
        -m 'New Title' --assign octocat --open --milestone v0.5 1
  [1] New Title (leandro-lucarella-sociomantic)
      https://github.com/sociomantic/git-hub/issues/1

Create a new pull request
-------------------------
::

  $ git hub pull new -b experimental -c mypull
  Pushing master to mypull in myfork
  [4] Some pull request (octocat)
      https://github.com/sociomantic/git-hub/pull/4

This creates a pull request against the upstream branch ``experimental`` using
the current ``HEAD``, but creating a new topic branch called ``mypull`` to store
the actual pull request (assuming our ``HEAD`` is in the branch ``master``).

Attach code to an existing issue
--------------------------------
::

  $ git hub pull attach -b experimental -c mypull 1
  Pushing master to mypull in myfork
  [1] Some issue (octocat)
      https://github.com/sociomantic/git-hub/pull/1

Same as before, but this time attach the commits to issue 2 (effectively
converting the issue into a pull request).

Rebase a pull request
---------------------
::

  $ git hub pull rebase 4
  Fetching mypull from git@github.com:octocat/git-hub.git
  Rebasing to master in git@github.com:sociomantic/git-hub.git
  Pushing results to master in git@github.com:sociomantic/git-hub.git
  [4] Some pull request (octocat)
      https://github.com/sociomantic/git-hub/pull/4

If the rebase fails, you can use ``git hub pull rebase --continue`` as you would
do with a normal rebase.


Download
========

You can get this tool from the `GitHub project`__. If you want to grab
a release, please remember to visit the Release__ section.

__ https://github.com/sociomantic/git-hub
__ https://github.com/sociomantic/git-hub/releases


Installation
============

Dependencies
------------

* Python_ 2.7 (3.x can be used too but you have to run the ``2to3`` tool to the
  script first)

* Git_ >= 1.7.7 (if you use Ubuntu_ you can easily get the latest Git version
  using the `Git stable PPA`__)

* Docutils_ (>= 0.8, although it might work with older versions too, only needed
  to build the man page)

__ https://launchpad.net/~git-core/+archive/ppa

Building
--------

Only the man page and *bash completion* script need to be built. Type ``make``
to build them.

Alternatively, you can build a Debian_/Ubuntu_ package. Use ``make deb`` for
that.

Installing
----------

If you built the Debian_/Ubuntu_ package, you can just install the package
(``dpkg -i ../git-hub_VER_all.deb``).

Otherwise you can type ``make install`` to install the tool, man page, *bash
completion* and VIM_ *ftdetect* plugin (by default in ``/usr/local``, but you
can pick a different location by passing the ``prefix`` variable to ``make``
(for example ``make install prefix=/usr``).

The installation locations might be too specific for Debian_/Ubuntu_ though.
Please report any failed installation attempts.

To enjoy the *bash completion* you need to re-login (or re-load the
``/etc/bash_completion`` script).

To have syntax highlight in VIM_ when editing **git-hub** messages, you need to
activate the *ftdetect* plugin by copying or symbolic-linking it to
``~/.vim/ftdetect/githubmsg.vim``::

  mkdir -p ~/.vim/ftdetect
  ln -s $(prefix)/share/vim/addons/githubmsg.vim ~/.vim/ftdetect/
  # or if you are copying from the sources:
  # ln -s ftdetect.vim ~/.vim/ftdetect/githubmsg.vim

.. _Python: http://www.python.org/
.. _Docutils: http://docutils.sourceforge.net/
.. _Git: http://www.git-scm.com/
.. _GitHub: http://www.github.com/
.. _Ubuntu: http://www.ubuntu.com/
.. _Debian: http://www.debian.org/
.. _VIM: http://www.vim.org/

.. vim: set et sw=2 tw=80 :