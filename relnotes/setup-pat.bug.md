### The `setup` command will not attempt to login using user/password

GitHub stopped supporting logins using user/password with the API, so trying to
do so in the `setup` command is doomed to fail. Because of this, support for
generating a Personal Access Token (PAT) for the user is now removed. Instead
the user has to create their own PAT manually and pass it to the `setup`
command instead.

In particular the `setup` command removed the `--password` option and added
the `--oauthtoken` option instead, and when not specified, it will ask the user
to create one (with some hints on how to do so).

**NOTE:** This would normally be a breaking change deserving a new major release, but
since the tool was *externally* broken, there is no way to fix it without
breaking changes and previous versions will be **all broken**, so it doesn't
make sense to make a major release for this change.
