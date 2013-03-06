=======
git-hub
=======

------------------------------------
Git command line interface to GitHub
------------------------------------

:Author: Leandro Lucarella <leandro.lucarella@sociomantic.com>
:Date: 2013-02-27
:Manual section: 1
:Manual group: Git Manual


SYNOPSYS
========

git hub <command> [options] [arguments]


DESCRIPTION
===========

`git hub` is a simple command line interface to github, enabling most useful
GitHub tasks (like creating and listing pull request or issues) to be accessed
directly through the git command line.

To use this command you need to configure at least two git configuration
variables: `hub.upstream` and `hub.password`. All commands here will use
the `hub.upstream` GitHub repository (issues, pull requests, etc.). See the
CONFIGURATION_ section for more details.


COMMANDS
========

`issue`
  This command is used to manage GitHub issues through a set of subcommands.
  Is no subcommand is specified, `list` is used.

  `list`
    Show a list of open issues.

    --closed
      Show closed issues instead.

  `show`
    Show the issues identified by the number passed as arguments.

  `new`
    Create a new issue.

    -m MSG, --message=MSG
      Issue title (and description). The first line is used as the issue title
      and any text after an empty line is used as the optional body.  If this
      option is not used, the default `GIT_EDITOR` is opened to write one.

    -l LABEL, --label=LABEL
      Attach `LABEL` to the issue (can be specified multiple times to set
      multiple labels).

    -a USER, --assign=USER`
      Assign an user to the issue. `USER` must be a valid GitHub login name.

    -M ID, --milestone=ID
      Assign the milestone identified by the number ID to the issue.

  `update`
    Similar to `new` but update an existing issue identified by the number
    passed as argument.

    A convenient shortcut to close an issue is provided by the `close`
    subcommand.

    -m MSG, --message=MSG
      New issue title (and description). The first line is used as the issue
      title and any text after an empty line is used as the optional body.

    -e, --edit-message
      Open the default `GIT_EDITOR` to edit the current title (and description)
      of the issue.

    --open
      Reopen the issue.

    --close
      Close the issue.

    -l LABEL, --label=LABEL
      If one or more labels are specified, they will replace the current issue
      labels. Otherwise the labels are unchanged. If one of the labels is
      empty, the labels will be cleared (so you can use **-l''** to clear the
      labels of an issue.

    -a USER, --assign=USER
      Assign an user to the issue. `USER` must be a valid GitHub login name.

    -M ID, --milestone=ID
      Assign the milestone identified by the number ID to the issue.

  `comment`
    Add a new comment to an existing issue identified by the number passed as
    argument.

    -m MSG, --message=MSG
      Comment to be added to the issue. If this option is not used, the default
      `GIT_EDITOR` is opened to write the comment.

  `close`
    Alias for `update --close`. (+ `comment` if **--message** or
    **--edit-message** is specified).

    -m MSG, --message=MSG
      Add a comment to the issue before closing it.

    -e, --edit-message
      Open the default `GIT_EDITOR` to write a comment to be added to the issue
      before closing it.

`pull`
  This command is used to manage GitHub pull requests. Since pull requests in
  GitHub are also issues, most of the subcommands are repeated from the
  `issue` command for convenience. Only the `list` and `new` commands are
  really different, and `attach` and `rebase` are added.

 `list`
    Show a list of open pull requests.

    --closed
      Show closed pull requests instead.

  `show`
    Alias for `issue show`.

  `new`
    Create a new pull request. If an argument is specified, it will be used as
    the branch (or git ref) where your changes are implemented (the head).
    Otherwise the current branch is used. If the branch used as head is not
    pushed to your fork remote, a push will be automatically done before
    creating the pull request.

    The repository to issue the pull request from is taken from the
    `hub.forkrepo` configuration, which defaults to
    **hub.username/<hub.upstream project part>**.

    -m MSG, --message=MSG
      Pull request title (and description). The first line is used as the pull
      request title and any text after an empty line is used as the optional
      body.  If this option is not used, the default `GIT_EDITOR` is opened.
      If the HEAD branch have a proper description (see `git branch
      --edit-description`), that description will be used as the default
      message in the editor and if not, the message of the last commit will be
      used instead.

    -b BASE, --base=BASE
      Branch (or git ref) you want your changes pulled into. If this option is
      not present, then the base branch is taken from the configuration
      `hub.pullbase` (or just **master** if that configuration is not present
      either). The repository to use as the base is taken from the
      `hub.upstream` configuration.

  `attach`
    Convert the issue identified by the number passed as the first argument to
    a pull request by attaching commits to it. The head can be optionally
    passed as the second argument. This subcommand is very similar to the `new`
    subcommand, please refer to it for more details.

    -m MSG, --message=MSG
      Add a comment to the issue/new pull request.

    -e, --edit-message
      Open the default `GIT_EDITOR` to write a comment to be added to the
      issue/new pull request. The default message is taken from the
      **--message** option if present, otherwise the branch description or the
      first commit message is used as with the `new` subcommand.

    -b BASE, --base=BASE
      Base branch to which issue the pull request. If this option is not
      present, then the base branch is taken from the configuration
      `hub.pullbase` (or just **master** if that configuration is not present
      either). The repository to use as the base is taken from the
      `hub.upstream` configuration.

  `rebase`
    Close a pull request identified by the number passed as argument by
    rebasing its base branch (specified in the pull request) instead of merging
    as GitHub's *Merge Button™* would do.

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
    8. git pop

    -m MSG, --message=MSG
      Use this message for the comment instead of the default. Specify an empty
      message (**-m''**) to completely omit the comment.

    -e, --edit-message
      Open the default `GIT_EDITOR` to write the comment.

  `update`
    Alias for `issue update`.

  `comment`
    Alias for `issue comment`.

  `close`
    Alias for `issue close`.


CONFIGURATION
=============

This program use the git configuration facilities to get its configuration
from. These are the git config keys used:

`hub.username`
  Your GitHub username. [default: *current OS username*]

`hub.password` required
  Your GitHub password.

`hub.upstream` required
  Blessed repository used to get the issues from and make the pull requests
  to. The format is <owner>/<project>.

`hub.forkrepo`
  Your blessed repository fork. The format is <owner>/<project>. Used to set
  the head for your pull requests. [defaul: *<username>/(upstream <project>
  part)*]

`hub.forkremote`
  Remote name for accessing your fork. Used to push branches before creating
  a pull request. [default: *origin*]

`hub.pullbase`
  Default remote branch (or git reference) you want your changes pulled into
  when creating a pull request. [default: *master*]

`hub.pullurltype`
  Type of URL to use when an URL from a GitHub API is needed (for example,
  when 'pull rebase' is used). At the time of writing it could be ssh_url
  or clone_url for HTTP). See this link for possible options:
  http://developer.github.com/v3/pulls/#get-a-single-pull-request
  [default: ssh_url]


.. vim: set et sw=2 :
