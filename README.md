# Linux Security Auditor

A read-only Bash-based Linux auditing tool that collects basic system information and highlights areas that may warrant security review.

## Features

- Operating system and system resource inventory
- User account and group enumeration
- Identification of accounts with UID 0
- Review of sudo group membership
- Sensitive file permission inspection
- Detection of world-writable regular files under `/etc`
- Listening TCP and UDP socket inventory
- Timestamped text reports
- Command-level success and failure logging

## Requirements

- Linux system with Bash
- Standard utilities used by the script, including `awk`, `stat`, `find`, `getent`, `ss`, `tee`, and `date`
- Read access to the relevant system information

Some checks may return incomplete information without elevated privileges. Do not run the script with elevated privileges unless you understand and have reviewed its behavior.

## Usage

```bash
chmod +x auditor.sh
./auditor.sh
```

Reports are saved under:

`~/linux-security-auditor/reports/`

## Safety

The tool is designed for read-only auditing. It does not intentionally change user accounts, file permissions, firewall rules, or running services.

## Limitations

- This is a basic inventory and auditing tool, not a vulnerability scanner.
- A successful command does not prove that a system is secure.
- A listening port is not automatically a vulnerability.
- Findings require contextual review and validation.
- Results depend on available commands, permissions, and system configuration.
- Command exit status alone does not establish whether a security condition is acceptable.

## Future improvements

- Structured JSON output
- More robust error handling
- Unique report filenames
- Automated tests
- Configurable checks and severity classifications
- Comparison of reports across audit runs

## Project status

Educational portfolio project. Validate the results before using them to support operational security decisions.
