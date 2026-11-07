#!/bin/bash
# Runs from cron every 30 min: commit any config change and push to GitHub.
cd ~/printer_data/config || exit 1
# A lock left behind by a crashed run blocks every later commit (this is
# what killed the backup from 2025-08-01 until 2026-11-07).
if [ -f .git/index.lock ] && ! pgrep -x git >/dev/null; then
    rm -f .git/index.lock
fi
git add -A
git diff --cached --quiet && exit 0          # nothing changed
git commit -q -m "Automated backup: $(date)" || exit 1
git push -q origin master
