#!/bin/bash
# ============================================================
#  CS 193 - HW7 Study-Log Helper - INSTRUCTOR SOLUTION
#  Reference implementation. Do NOT distribute to students.
# ============================================================

# STEP 2 - guard against a missing name
if [ -z "$1" ]
then
  echo "Usage: ./studylog.sh <your-name>"
  exit 1
fi

# STEP 3 - variable (no spaces around =)
LOGFILE="study_log.txt"

# STEP 4 - append a timestamped entry
echo "$1 studied on $(date)" >> "$LOGFILE"

# STEP 5 - count and report
total=$(wc -l < "$LOGFILE")
echo "Thanks $1! You have logged $total study session(s)."

# ---- OPTIONAL STRETCH ----
if [ "$total" -ge 3 ]
then
  echo "Great consistency! Keep it up."
fi

# list every entry so far
echo "--- your study log ---"
for line in "$LOGFILE"
do
  cat "$line"
done
