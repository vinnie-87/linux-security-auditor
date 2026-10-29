#!/bin/bash

set -u

# Linux Security Auditor - Version 0.1
#Read-Only System inventory


REPORT_DIR="$HOME/linux-security-auditor/reports"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
REPORT_FILE="$REPORT_DIR/audit_$TIMESTAMP.txt"

CHECKS_PASSED=0
CHECKS_FAILED=0

mkdir -p "$REPORT_DIR" || {
echo "Error: Could not create report directory." >&2
exit 1

}

section(){
printf '\n\n=== %s ===\n' "$1" | tee -a "$REPORT_FILE"
}

run_check(){
printf '\n$' | tee -a "$REPORT_FILE"
printf ' %s' "$@" | tee -a "$REPORT_FILE"
printf '\n' | tee -a "$REPORT_FILE"

"$@" 2>&1 | tee -a "$REPORT_FILE"
command_status=${PIPESTATUS[0]}

if ((command_status == 0 )); then
printf "[PASS] Command completed successfully.\n" \ | tee -a "$REPORT_FILE"
((CHECKS_PASSED += 1))
else
printf "[FAIL] Command exited with Status %s.\n" \
"$command_status" | tee -a "$REPORT_FILE"
((CHECKS_FAILED += 1))
fi
}


{
echo "LINUX SECURITY AUDIT"
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo "Auditing user: $(id -un)"
} | tee "$REPORT_FILE"





section "OPERATING SYSTEM"
run_check cat /etc/os-release
run_check uname -a


section "USER AND PRIVILEGES"
run_check id
run_chek groups

section "SENSITIVE FILE PERMISSIONS"
run_check stat -c '%A %a %U:%G %n' \
/etc/passwd \
/etc/shadow \
/etc/sudoers \
/etc/ssh/sshd_config

section "WORLD-WRITABLE FILES UNDER /etc"
run_check find /etc -xdev -type f -perm -0002 -print

section "LISTENING TCP AND UDP PORTS"
run_check ss -lntup


section "ACCOUNT INVENTORY"
run_check awk -F:awk -F: "{printf "%-20s UID=%-6s GID=%-6s SHELL=%s'\n'", $1, $3, $4, $7}" /etc/passwd 

section "ACCOUNTS WITH UID 0"
run_check awk -F: "$3 == 0 {printf "Username: %s | UID: %s | Home: %s | Shell: %s\n", $1, $3, $6, $7}" /etc/passwd

section "SUDO GROUP MEMBERSHIP"
run_check getent group sudo

section "ACCOUNTS WITH INTERACTIVE_LOOKING SHELLS"
run_check awk -F: "$7 ~ /(bash|zsh|sh|fish)$/ {printf "%-20s %s\n", $1, $7}" /etc/passwd

section "SYSTEM RESOURCES"
run_check uptime
run_check df -h

section "NETWORK INTERFACES"
run_check ip -brief address

section "AUDIT SUMMARY"

printf 'Checks passed: %s\n' "$CHECKS_PASSED" \
| tee -a "$REPORT_FILE"
printf 'Checks failed: %s\n' "$CHECKS_FAILED" \
| tee -a "$REPORT_FILE"

section "AUDIT COMPLETE"
echo "Report saved to: $REPORT_FILE"
