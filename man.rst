=======
git-hub
=======

------------------------------------
Git command line interface to GitHub
------------------------------------

:Author: Leandro Lucarella <leandro.lucarella@dunnhumby.com>
:Copyright: 2013 dunnhumby Germany GmbH
:Version: devel
:Date: |date|
:Manual section: 1
:Manual group: Git Manual

.. |date| date::


SYNOPSIS
========

git hub [global options]  <command> [options] [arguments]


DESCRIPTION
===========

`git hub` is a simple command line interface to github, enabling most useful
GitHub tasks (like creating and listing pull request or issues) to be accessed
directly through the git command line.

To use this command you'll probably need to make an initial configuration to
get authorization from GitHub. To do this you can use the `setup` command.
See the CONFIGURATION_ section for more configuration options.


GLOBAL OPTIONS
==============

\-h, --help
  Show this help and exit.

\--version
  Show program's version number and exit.

\-v, --verbose
  Be more verbose (can be specified multiple times to get extra verbosity)

\-s, --silent
  Be less verbose (can be specified multiple times to get less verbosity)


COMMANDS
========

`setup`
  This command performs an initial setup to connect to GitHub. It basically
  asks GitHub for an authorization token and stores it in the Git configuration
  variable `hub.oauthtoken` for future use so you don't need to type your
  password each time (or store it in the config). The username is also stored
  for future use in the `hub.username` variable. If the base URL is specified,
  it is stored in `hub.baseurl` too. By default configuration is stored in the
  repository's ``.git/config`` file (using ``git config``). If you want your
  configuration to be global to your user or system-wide, use the ``--global``
  or ``--system`` option respectively. These options are passed straight to
  ``git config``.

  \-u USERNAME, --username=USERNAME
    GitHub's username (login name), will be stored in the configuration
    variable `hub.username`. If an e-mail is provided, then a username matching
    that e-mail will be searched and used instead, if found (for this to work
    the e-mail must be part of the public profile).

  \-p PASSWORD, --password=PASSWORD
    GitHub's password (will not be stored).

  \-b URL, --baseurl=URL
    GitHub's base URL to use to access the API. Set this when your GitHub API is
    in another location other than the default (Enterprise servers usually use
    https://host/api/v3).

  \--global
    Store settings in the global configuration (see --global option in `git
    config(1)` for details).

  \--system
    Store settings in the system configuration (see --system option in `git
    config(1)` for details).

`clone` REPO [DEST]
  This command is used to clone **REPO**, a GitHub repository, to a **DEST**
  directory (defaults to the name of the project being cloned). If the
  repository is specified in *<owner>/<project>* form, the **REPO** will be
  used as upstream and a personal fork will be looked up. If none is found,
  a new fork will be created. In both cases, the fork will be cloned instead of
  the upstream repository. The **REPO** can be specified as a regular *clone*
  URL too (http, ssh, git), in that case the URL will be inspected and the
  `hub.urltype` will be set as appropriate.

  If only *<project>* is specified as **REPO**, then the configuration
  `hub.username` is used as *<owner>*, and the parent repository is looked up
  at GitHub to determine the real upstream repository.

  The upstream repository is cloned as `--upstreamremote` (or
  `hub.upstreamremote`, `upstream` by default), the remote for the fork is
  added as `--forkremote` (or `hub.forkremote`, `fork` by default) and the fork
  is set as the git `remote.pushdefault` (so pushing will hit the fork by
  default), unless `--no-triangular` is used (please see the option for more
  details).

  After cloning and fetching, the git configuration variables `hub.upstream`,
  `hub.upstreamremote` and `hub.forkremote` are set in the new cloned repo (see
  CONFIGURATION_).

  \-U NAME, --upstreamremote=NAME
    Use `NAME` as the upstream remote repository name instead of the default
    'upstream').

  \-F NAME, --forkremote=NAME
    Use `NAME` as the fork remote repository name instead of the default
    'fork').

  \-t, --triangular
    Use Git's *triangular workflow* configuration (this is the default). This
    option clones from the parent/upstream repository, and adds the fork as
    a remote repository. Then sets the `remote.pushdefault` Git option and
    `hub.forkremote` git-hub option to the just cloned repository.

    The effect of this having the upstream repository used by default
    when you pull but using your fork when you push, which is typically what
    you want when using GitHub's pull requests.

    Git version 1.8.3 or newer is needed to use this option (and 1.8.4 or newer
    is recommended due to some issues in 1.8.3 related to this).

    To change the default you can set the option `hub.triangular`. See
    CONFIGURATION_ for details.

  \--no-triangular
    Don't use Git's *triangular workflow* configuration (this is only available
    for backwards compatibility but is not recommended). This option clones
    from the forked repository instead of cloning the upstream/parent repo, so
    both pulls and pushes will be done with the fork by default.

    This option could be also used to clone a GitHub repository without forking
    it, but some functionality of the tool will be lost.

  GIT CLONE OPTIONS
    Any standard **git clone** option can be passed. Not all of them might make
    sense when cloning a GitHub repo to be used with this tool though.


`issue`
  This command is used to manage GitHub issues through a set of subcommands.

  `list`
    Show a list of open issues.

    \-c, --closed
      Show closed issues instead.

    \-C, --created-by-me
      Show only issues created by me

    \-A, --assigned-to-me
      Show only issues assigned to me

  `show` ISSUE [ISSUE ...]
    Show issues identified by **ISSUE**.

  `new`
    Create a new issue.

    \-m MSG, --message=MSG
      Issue title (and description). The first line is used as the issue title
      and any text after an empty line is used as the optional body.  If this
      option is not used, the default `GIT_EDITOR` is opened to write one.

    \-l LABEL, --label=LABEL
      Attach `LABEL` to the issue (can be specified multiple times to set
      multiple labels).

    \-a USER, --assign=USER
      Assign a user to the issue. `USER` must be a valid GitHub login name.

    \-M ID, --milestone=ID
      Assign the milestone identified by the number ID to the issue.

  `update` ISSUE
    Similar to `new` but update an existing issue identified by **ISSUE**.

    A convenient shortcut to close an issue is provided by the `close`
    subcommand.

    \-m MSG, --message=MSG
      New issue title (and description). The first line is used as the issue
      title and any text after an empty line is used as the optional body.

    \-t TITLE, --title=TITLE
      New issue title.

    \-e, --edit-message
      Open the default `GIT_EDITOR` to edit the current title (and description)
      of the issue.

    \-o, --open
      Reopen the issue.

    \-c, --close
      Close the issue.

    \-l LABEL, --label=LABEL
      If one or more labels are specified, they will replace the current issue
      labels. Otherwise the labels are unchanged. If one of the labels is
      empty, the labels will be cleared (so you can use **-l''** to clear the
      labels of an issue.

    \-a USER, --assign=USER
      Assign a user to the issue. `USER` must be a valid GitHub login name.

    \-M ID, --milestone=ID
      Assign the milestone identified by the number ID to the issue.

  `comment` ISSUE
    Add a new comment to an existing issue identified by **ISSUE**.

    \-m MSG, --message=MSG
      Comment to be added to the issue. If this option is not used, the default
      `GIT_EDITOR` is opened to write the comment.

  `close` ISSUE
    Alias for `update --close`. (+ `comment` if **--message** or
    **--edit-message** is specified). Closes issue identified by **ISSUE**.

    \-m MSG, --message=MSG
      Add a comment to the issue before closing it.

    \-e, --edit-message
      Open the default `GIT_EDITOR` to write a comment to be added to the issue
      before closing it.


`pull`
  This command is used to manage GitHub pull requests. Since pull requests in
  GitHub are also issues, most of the subcommands are repeated from the
  `issue` command for convenience. Only the `list` and `new` commands are
  really different, and `attach` and `rebase` are added.

  `list`
    Show a list of open pull requests.

    \--closed
      Show closed pull requests instead.

  `show` PULL [PULL ...]
    Alias for `issue show`.

  `checkout` PULL ...
    Checkout the remote branch (head) of the pull request. This command first
    fetches the *head* reference from the pull request and then calls the
    standard `git checkout` command and any extra argument will be passed
    to `git checkout` as-is, after the reference that was just fetched.
    Remember this creates a detached checkout by default, use `-b` if you
    want to create a new branch based on the pull request. Please take a
    look at `git checkout` help for more details.

  `new` [HEAD]
    Create a new pull request. If **HEAD** is specified, it will be used as the
    branch (or git ref) where your changes are implemented.  Otherwise the
    current branch is used. If the branch used as head is not pushed to your
    fork remote, a push will be automatically done before creating the pull
    request.

    The repository to issue the pull request from is taken from the
    `hub.forkrepo` configuration, which defaults to
    *hub.username/<hub.upstream project part>*.

    \-m MSG, --message=MSG
      Pull request title (and description). The first line is used as the pull
      request title and any text after an empty line is used as the optional
      body.  If this option is not used, the default `GIT_EDITOR` is opened.
      If the HEAD branch have a proper description (see `git branch
      --edit-description`), that description will be used as the default
      message in the editor and if not, the message of the last commit will be
      used instead.

    \-b BASE, --base=BASE
      Branch (or git ref) you want your changes pulled into. By default the
      tracking branch (`branch.<ref>.merge` configuration variable) is used or
      the configuration `hub.pullbase` if not tracking a remote branch. If none
      is present, it defaults to **master**. The repository to use as the base
      is taken from the `hub.upstream` configuration.

    \-c NAME, --create-branch=NAME
      Create a new remote branch with (with name **NAME**) as the real head for
      the pull request instead of using the HEAD name passed as **HEAD**. This
      is useful to create a pull request for a hot-fix you committed to your
      regular HEAD without creating a branch first.

    \-f, --force-push
      Force the push operations. Use with care!

  `attach` ISSUE [HEAD]
    Convert the issue identified by **ISSUE** to a pull request by attaching
    commits to it. The branch (or git ref) where your changes are
    implemented can be optionally specified with **HEAD** (otherwise the
    current branch is used). This subcommand is very similar to the `new`
    subcommand, please refer to it for more details.

    Please note you can only attach commits to issues if you have commit access
    to the repository or if you are assigned to the issue.

    \-m MSG, --message=MSG
      Add a comment to the issue/new pull request.

    \-e, --edit-message
      Open the default `GIT_EDITOR` to write a comment to be added to the
      issue/new pull request. The default message is taken from the
      **--message** option if present, otherwise the branch description or the
      first commit message is used as with the `new` subcommand.

    \-b BASE, --base=BASE
      Base branch to which issue the pull request. If this option is not
      present, then the base branch is taken from the configuration
      `hub.pullbase` (or just **master** if that configuration is not present
      either). The repository to use as the base is taken from the
      `hub.upstream` configuration.

    \-c NAME, --create-branch=NAME
      Create a new remote branch with (with name **NAME**) as the real head for
      the pull request instead of using the HEAD name passed as **HEAD**. This
      is useful to create a pull request for a hot-fix you committed to your
      regular HEAD without creating a branch first.

    \-f, --force-push
      Force the push operations. Use with care!

  `rebase` PULL
    Close a pull request identified by **PULL** by rebasing its base branch
    (specified in the pull request) instead of merging as GitHub's *Merge
    Button™* would do.

    If the operation is successful, a comment will be posted informing the new
    HEAD commit of the branch that has been rebased and the pull request will
    be closed.

    The type of URL used to fetch and push can be specified through the
    `hub.pullurltype` configuration variable (see CONFIGURATION_ for more
    details). Your working copy should stay the same ideally, if everything
    went OK.

    The operations performed by this subcommand are roughly these:

    1. git stash
    2. git fetch `pullhead`
    3. git checkout -b `tmp` FETCH_HEAD
    4. git pull --rebase `pullbase`
    5. git push `pullbase`
    6. git checkout `oldhead`
    7. git branch -D `tmp`
    8. git stash pop

    If `hub.forcerebase` is set to "true" (the default), ``--force`` will be
    passed to rebase (not to be confused with this command option
    ``--force-push`` which will force the push), otherwise (if is "false")
    a regular rebase is performed. When the rebase is forced, all the commits
    in the pull request are re-committed, so the Committer and CommitterDate
    metadata is updated in the commits, showing the person that performed the
    rebase and the time of the rebase instead of the original values, so
    providing more useful information. As a side effect, the hashes of the
    commits will change.

    If conflicts are found, the command is interrupted, similarly to how `git
    rebase` would do. The user should either **--abort** the rebasing,
    **--skip** the conflicting commit or resolve the conflict and
    **--continue**. When using one of these actions, you have to omit the
    **PULL** argument.

    \-m MSG, --message=MSG
      Use this message for the comment instead of the default. Specify an empty
      message (**-m''**) to completely omit the comment.

    \-e, --edit-message
      Open the default `GIT_EDITOR` to write the comment.

    \--force-push
      Force the push operations. Use with care!

    \-p, --pause
      Pause the rebase just before the results are pushed and the issue is
      merged. To resume the pull request rebasing (push the changes upstream
      and close the issue), just use the **--continue** action.  This is
      particularly useful for testing.

    \-u, --stash-include-untracked
      Passes the **--include-untracked** option to stash. If used all untracked
      files are also stashed and then cleaned up with git clean, leaving the
      working directory in a very clean state, which avoid conflicts when
      checking out the pull request to rebase.

    \-a, --stash-all
      Passes the **--all** option to stash. Is like
      **--stash-include-untracked** but the ignored files are stashed and
      cleaned in addition to the untracked files, which completely removes the
      possibility of conflicts when checking out the pull request to rebase.

    \-D, --delete-branch
      Delete the pull request branch if the rebase was successful. This is
      similar to press the "Delete Branch" Button (TM) in the web interface
      after merging.

    Actions:

    \--continue
      Continue an ongoing rebase.

    \--abort
      Abort an ongoing rebase.

    \--skip
      Skip current patch in an ongoing rebase and continue.

  `update` PULL
    Alias for `issue update`.

  `comment` PULL
    Alias for `issue comment`.

  `close` PULL
    Alias for `issue close`.


CONFIGURATION
=============

This program use the git configuration facilities to get its configuration
from. These are the git config keys used:

`hub.username`
  Your GitHub username. [default: *current OS username*]

`hub.oauthtoken` required
  This is the authorization token obtained via the `setup` command. Even when
  required, you shouldn't need to set this variable manually. Use the `setup`
  command instead.

`hub.upstream` required
  Blessed repository used to get the issues from and make the pull requests to.
  The format is *<owner>/<project>*. This option can be automatically set by
  the `clone` command and is not really required by it or the `setup` command.

`hub.upstreamremote`
  Remote name for accessing the upstream repository [default: *upstream*].

`hub.forkrepo`
  Your blessed repository fork. The format is *<owner>/<project>*. Used to set
  the head for your pull requests. [default: *<username>/(upstream <project>
  part)*]

`hub.forkremote`
  Remote name for accessing your fork. Used to push branches before creating
  a pull request. [default: *fork*]

`hub.pullbase`
  Default remote branch (or git reference) you want your changes pulled into
  when creating a pull request. [default: *master*]

`hub.urltype`
  Type of URL to use when an URL from a GitHub API is needed (for example,
  when 'pull rebase' is used). At the time of writing it could be *ssh_url*
  or *clone_url* for HTTP). See GitHub's API documentation[1] for more
  details or options. [default: *ssh_url*]

`hub.baseurl`
  GitHub's base URL to use to access the API. Set this when your GitHub API is
  in another location other than the default (Enterprise servers usually use
  https://host/api/v3). This will be prepended to all GitHub API calls and it
  has to be a full URL, not just something like "www.example.com/api/v3/".

`hub.forcerebase`
  If is set to "true", ``--force`` will be passed to rebase. If is set to
  "false" a regular rebase is performed. See the `pull` `rebase` command for
  details. [default: *true*]

`hub.triangular`
  Makes **--triangular** for `clone` if set to "true" (boolean value). See
  `clone` documentation for details.

[1] https://developer.github.com/v3/pulls/#get-a-single-pull-request


FILES
=====

This program creates some temporary files in the '.git' directory during its
operation. The contents of these files can be used for debugging/recovery
purposes if necessary.

`HUB_EDITMSG`
  This file is used to take input from the user, e.g. issue comments, pull
  request title & description etc. If, after accepting user input, the command
  given by the user fails for some reason, then the entered text can still be
  retrieved from this file.

`HUB_PULL_REBASING`
  This file is used to store various metadata information related to a rebase
  operation (with the primary aim of being able to rollback the repository to
  its original state if the rebase fails or is interrupted due to conflicts).
  The sole presence of this file indicates that a rebase is in progress.


VIM SYNTAX HIGHLIGHT
====================

A VIM ftdetect plugin is provided, to enable it you have to follow some steps
though. All you need to do is copy (or preferably make a symbolic link) the
script to `~/.vim/ftdetect/githubmsg.vim`::

  mkdir -p ~/.vim/ftdetect
  ln -s /usr/share/vim/addons/githubmsg.vim ~/.vim/ftdetect/
  # or if you are copying from the sources:
  # ln -s ftdetect.vim ~/.vim/ftdetect/githubmsg.vim

.. vim: set et sw=2 :
