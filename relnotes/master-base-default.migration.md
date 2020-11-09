### No last resort default for `pull new`/`attach --base`

The old `master` default made little sense, as repositories sometimes have
a different default branch, or have no `master` at all. Now that GitHub have
changed the default branch to `main` for new projects (and many projects are
moving away from using `master` as a name for anything altogether) it makes
less sense that ever to use this last resort default.

An error will be shown if the `pull new` or `pull attach` commands have no
remote tracking branch or a `hub.pullbase` configuration is present. If you
relied on this behaviour just do: `git config hub.pullbase master` (add
`--global` to set this default globally for all your repos).
