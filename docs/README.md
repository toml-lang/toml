# Maintainer documentation

This section of the repository contains documentation for TOML's maintainers.

## Release Process

- Set up local repos of [toml-lang/toml] and [toml-lang/toml.io], as described
  in [scripts/release.py](../scripts/release.py).
- In the root of the toml-lang/toml clone, run
  `python3.8 scripts/release.py <version>`.
- Done! ✨

[toml-lang/toml]: https://github.com/toml-lang/toml
[toml-lang/toml.io]: https://github.com/toml-lang/toml.io
