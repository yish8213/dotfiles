# Claude Prompt Context for Dotfiles Project

## Overview

This is a personal dotfiles project using modern Bash scripts to automate the setup and configuration of a development environment on UNIX-like systems.

The project emphasizes simplicity, clarity, and long-term maintainability.

## Principles

- Use **modern Bash** (v5+) features when helpful, but keep scripts readable and portable across common Linux/macOS environments.
- Follow a **minimalist** approach — avoid unnecessary complexity or dependencies.
- Write **modular** scripts that can be reused, extended, or run independently.
- Ensure all scripts behave **consistently** and **predictably** across systems.

## AI Usage Notes

This context is intended to guide Claude Sonnet 4 or GitHub Copilot Agent when generating or editing shell scripts within this project.  
All code suggestions should:

- Use idiomatic, modern Bash
- Favor clarity over cleverness
- Assume common tools are available (`bash`, `grep`, `awk`, `sed`, `curl`, etc.)
- Prompt for `sudo` password once at the beginning if required
- Scripts should log errors but continue execution; do not use `set -e` or force early termination unless absolutely necessary
