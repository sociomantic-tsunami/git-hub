### Fix error reading template from path

Verify the template is a regular file so that the content of the template
can be added to the message of the issue or pull request.
The current implementation of templates does not support directories of
templates.
