### Check if the base branch exists when creating a PR (#92)

When creating a PR if the specified (or inferred) base branch doesn't exist,
a very weird error message was printed. Now the branch existence is explicitly
checked before attempting the PR creation.
