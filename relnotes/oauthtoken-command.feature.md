### Allow specifying a command to get the `oauthtoken`

Sometimes storing OAuth token in plain text is not a great idea, so now the
`oauthtoken` configuration variable can use a shell command to get the token
instead. Just prepend a `!` and write the command you want to run instead of
using the token.

For example:

```sh
git config hub.oauthtoken '!password-manager ~/my.db get github-oauth-token'
```
