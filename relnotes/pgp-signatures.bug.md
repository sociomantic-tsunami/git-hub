### PGP signatures of commits are not included in messages anymore

When creating a pull request or using a commit message in any way, if the
commit was PGP-signed and the user had git configured to always show signatures
(`git config log.showsignature=true`), then the message would include the
signature verification text, which is not really something you usually want to
include.

Now `--no-show-signature` is always used when retrieving commit messages.
