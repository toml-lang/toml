# Maintainance documentation

This section of the repository contains maintainance documentation for TOML.

The plan is that we'd build better automation for managing the specification
and the relevant processes, information about the tooling used and related
items would be documented here.

Currently, this documentation is pretty thin; as we are still working on
improving the automation and setting up workflows.

## Release Process

1. Checkout the latest `master` branch.
2. Update the notice on README.md (if any) to reflect the current state
   of the project; because... we don't have a better mechanism for
   communicating state-of-affairs right now.
3. Create a copy of README.md at `versions/en/toml-v{version}.md`.
4. Update the top-level heading to clearly include the version like
  `TOML v{version}` and remove the note about tracking `master`.
5. Commit all these changes.
6. Make a PR with these changes, and merge it.
7. Publish a GitHub release, containing CHANGELOG, and pointing at
   the current master (i.e. post merge).
