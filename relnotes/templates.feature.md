### Support issue and pull request templates

* The commands `git-hub issue new` and `git-hub pull new` add template
contents to the issue or pull request message respectively.

Looks for a template file in the root directory of the project,
the `.github` directory and the `.git` directory until the first
template file is found. Then reads the content from the template
file found and adds it to the message of the issue or pull request.

The supported file names for issue templates are `ISSUE_TEMPLATE`
and `ISSUE_TEMPLATE.md`, and for pull request templates are
`PULL_REQUEST_TEMPLATE` and `PULL_REQUEST_TEMPLATE.md`.
The order for template lookups matters meaning that a template
file name without extension is looked up first followed by the
template file name with extension `.md`.

Note that only the content of the first issue or pull request
template found is added to the message of the issue or pull request
respectively.

Finally the commands `git-hub issue new` and `git-hub pull new`
also accept `--no-template` to skip adding the template content
to the issue or pull request message respectively.
