#!/bin/bash


# geometry: top=3cm, left=2cm, right=2cm, bottom=3cm
# mainfont: Ubuntu

cat <<PREAMBLE - README.md | pandoc -o toml.pdf --latex-engine xelatex
---
title: TOML
subtitle: Tom’s Obvious, Minimal Language
author: Tom Preston-Werner, Pradyun Gedam, et al.
date: $(date +%Y-%m-%d)
documentclass: scrbook
classoption: oneside
papersize: a4
colorlinks: blue
fontsize: 12pt
---
PREAMBLE