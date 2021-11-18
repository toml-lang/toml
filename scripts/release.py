"""Release Automation!

Baked assumptions:

- CWD is the root of the toml repository (this one)
- The toml.io repository is available at "../toml.io"
- Changelog file:
  - is `CHANGELOG.md`
  - has a "## unreleased" heading line.
- Markdown file:
  - is `toml.md`
  - goes to `specs/en/v{version}` in the website repo
  - lines "TOML" and "====" are the main heading.
- ABNF file:
  - is `toml.abnf`

Checked assumptions:

- Both this and the toml.io repository have an "upstream" remote
- "upstream" remotes point to "github.com/toml-lang/{repo}"
- Current branch is the default branch
- Current branch is up to date with remote
- Working directory is clean

"""

import fileinput
import os
import re
import shutil
import subprocess
import sys
import tempfile
import textwrap
from contextlib import contextmanager
from datetime import datetime
from pathlib import Path
from typing import Callable, List, Tuple

# Copied from semver.org and broken up for readability + line length.
SEMVER_REGEX = re.compile(
    r"""
    ^
        (?P<major>0|[1-9]\d*)
        \.
        (?P<minor>0|[1-9]\d*)
        \.
        (?P<patch>0|[1-9]\d*)
        (?:
            -
            (?P<prerelease>
                (?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
                (?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*
            )
        )?
        (?:
            \+
            (?P<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*)
        )?
    $
    """,
    re.VERBOSE,
)


#
# Helpers
#
@contextmanager
def task(message: str):
    """A little thing to allow for nicer code organization."""
    global _INDENT

    log(f"{message}...")
    _INDENT += 1
    try:
        yield
    except AssertionError as e:
        log(f"ERROR: {e}", error=True)
        sys.exit(1)
    finally:
        _INDENT -= 1


def log(message: str, *, error=False) -> None:
    output = textwrap.indent(message, "  " * _INDENT)

    if error:
        file = sys.stderr
        # A dash of red
        if sys.stdout.isatty():
            output = f"\033[31m{output}\033[0m"
    else:
        file = sys.stdout

    print(output, file=file)


_INDENT = 0


def run(*args, cwd: Path):
    """Runs a command, while also pretty-printing it."""
    result = subprocess.run(args, cwd=cwd, capture_output=True)
    if result.returncode == 0:
        return result.stdout.decode().rstrip("\n")

    # Print information about the failed command.
    log(" ".join(["$", *args]))
    log(" stdout ".center(80, "-"))
    log(result.stdout.decode() or "<nothing>")
    log(" stderr ".center(80, "-"))
    log(result.stderr.decode() or "<nothing>")

    assert False, f"Exited with non-zero exit code: {result.returncode}"


@contextmanager
def replacement_file(path: Path):
    fh, tmp_path = tempfile.mkstemp()
    with os.fdopen(fh, "w") as dest:
        with path.open() as source:
            yield source, dest

    # Replace current file with rewritten file
    shutil.copymode(path, tmp_path)
    path.unlink()
    shutil.move(tmp_path, path)


def matches(line):
    return (line + "\n").__eq__


def contains(fragment):
    def marker(line):
        return fragment in line

    return marker


def change_line(path: Path, *, marker: Callable[[str], bool], to: List[str]) -> None:
    with replacement_file(path) as (source, dest):
        for line in source:
            # not-to-be-replaced lines
            if not marker(line):
                dest.write(line)
                continue
            # replacement lines
            for replacement in to:
                dest.write(replacement + "\n")


def git_commit(message: str, *, files: List[str], repo: Path):
    run("git", "add", *files, cwd=repo)
    run("git", "commit", "-m", message, cwd=repo)


#
# Actual automation
#
def get_version() -> str:
    assert len(sys.argv) == 2, "Got wrong number of arguments, expected 1."

    version = sys.argv[1]

    match = SEMVER_REGEX.match(version)
    assert match is not None, "Given version is not a valid semver."
    assert not match.group("buildmetadata"), "Shouldn't have build metadata in version."

    return version


def check_repo_state(repo: Path, *, name: str):
    # Check upstream remote is configured correctly
    upstream = run("git", "config", "--get", "remote.upstream.url", cwd=repo)
    assert (
        upstream == f"git@github.com:toml-lang/{name}.git"
    ), f"Got incorrect upstream repo: {upstream}"

    # Check current branch is correct
    current_branch = run("git", "branch", "--show-current", cwd=repo)
    assert current_branch in ("main", "master"), current_branch

    # Check working directory is clean
    working_directory_state = run("git", "status", "--porcelain", cwd=repo)
    assert (
        working_directory_state == ""
    ), f"Dirty working directory\n{working_directory_state}"

    # Check up-to-date with remote
    with task("Checking against remote"):
        run("git", "remote", "update", "upstream", cwd=repo)

        deviation = run(
            "git",
            "rev-list",
            f"{current_branch}..upstream/{current_branch}",
            "--left-right",
            cwd=repo,
        )
        assert not deviation, f"Local branch deviates from upstream\n{deviation}"


def get_repositories() -> Tuple[Path, Path]:
    spec_repo = Path(".").resolve()
    website_repo = spec_repo.parent / "toml.io"

    with task("Checking repositories"):
        with task("toml"):
            check_repo_state(spec_repo, name="toml")
        with task("toml.io"):
            check_repo_state(website_repo, name="toml.io")

    return website_repo, spec_repo


def prepare_release(version: str, spec_repo: Path, website_repo: Path) -> None:
    # Make "backup" tags
    backup_tag = "backup/{now}".format(now=str(int(datetime.now().timestamp())))
    run("git", "tag", "-m", "backup", backup_tag, cwd=spec_repo)
    run("git", "tag", "-m", "backup", backup_tag, cwd=website_repo)

    date = datetime.today().strftime("%Y-%m-%d")
    release_heading = f"## {version} / {date}"
    release_message = f"Release v{version}"

    with task("Updating changelog for release"):
        unreleased_heading = "## unreleased"
        changelog = spec_repo / "CHANGELOG.md"

        change_line(changelog, marker=matches(unreleased_heading), to=[release_heading])
        git_commit(release_message, files=[str(changelog)], repo=spec_repo)

    with task("Creating release tag"):
        run("git", "tag", "-m", release_message, version, cwd=spec_repo)

    with task("Updating changelog for development"):
        change_line(
            changelog,
            marker=matches(release_heading),
            to=[unreleased_heading, "", "Nothing.", "", release_heading],
        )
        git_commit("Bump for development", files=[str(changelog)], repo=spec_repo)

    with task("Copy to website"):
        source_md = spec_repo / "toml.md"
        destination_md = website_repo / "specs" / "en" / f"v{version}.md"

        shutil.copyfile(source_md, destination_md)

    new_heading = f"TOML v{version}"
    new_abnf_link = f"https://github.com/toml-lang/toml/blob/{version}/toml.abnf"

    with task("Updating spec for release"):
        change_line(destination_md, marker=matches("TOML"), to=[new_heading])
        change_line(destination_md, marker=matches("===="), to=["=" * len(new_heading)])
        change_line(
            destination_md,
            marker=matches("[abnf]: ./toml.abnf"),
            to=[f"[abnf]: {new_abnf_link}"],
        )

    netlify_toml = website_repo / "netlify.toml"

    with task("Update latest redirect"):
        marker = "RELEASE AUTOMATION MARKER: version"
        new_line = f'  to = "/en/v{version}"  # {marker}'

        change_line(netlify_toml, marker=contains(marker), to=[new_line])

    with task("Commit new version"):
        git_commit(
            release_message,
            files=[str(destination_md), str(netlify_toml)],
            repo=website_repo,
        )


def push_release(version: str, spec_repo: Path, website_repo: Path) -> None:
    print("Publishing changes...")
    with task("specs repository"):
        run("git", "push", "origin", "HEAD", version, cwd=spec_repo)
        run("git", "push", "upstream", "HEAD", version, cwd=spec_repo)

    with task("website repository"):
        run("git", "push", "origin", "HEAD", cwd=website_repo)
        run("git", "push", "upstream", "HEAD", cwd=website_repo)


def main() -> None:
    version = get_version()
    website_repo, spec_repo = get_repositories()

    with task("Preparing release"):
        prepare_release(version, spec_repo, website_repo)

    input("Press enter when ready.")  # a chance to stop/pause before publishing

    with task("Publishing release"):
        push_release(version, spec_repo, website_repo)


if __name__ == "__main__":
    main()
