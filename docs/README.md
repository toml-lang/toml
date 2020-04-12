# Maintainance documentation

This section of the repository contains maintainance documentation for TOML.

The plan is that we'd build better automation for managing the specification
and the relevant processes, information about the tooling used and related
items would be documented here.

Currently, this documentation is pretty thin; as we are still working on
improving the automation and setting up workflows.

## Release Process

- Checkout the latest `master` branch.
- Update the existing files:
  - `README.md`: Update the notice on top of the file, to reflect the
    current state of the project; because... we don't have a better
    mechanism for communicating state-of-affairs right now.
  - `CHANGELOG.md`: Update the top level heading, to reflect the new
    version and date.
- Create the new "release version" of the specification:
  - Copy `README.md` to `versions/en/toml-v{version}.md`.
  - Update the top-level heading, to clearly include the version
    like `TOML v{version}`.
  - Remove the note about tracking `master`.
- Commit all these changes.
- Make a PR with these changes, and squash-merge it.
- Go to https://github.com/toml-lang/toml/releases/new and create a new release:
  - Tag version: `v{version}` like `v1.0.0-rc.1`
  - Target: master
  - Title: same as "Tag Version"
  - Description: Notes for this release, copied from CHANGELOG.md
  - Pre-release: make sure to check/not check this box
