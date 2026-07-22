#!/bin/bash
# ============================================================
#  CS 193 - Homework 7: Study-Log Helper
#  Fill in each TODO. Every hint below comes straight from
#  the Advanced Bash lecture, so scroll back to the slides
#  if you get stuck!  Estimated time: 15-20 minutes.
# ============================================================

# ------------------------------------------------------------
# STEP 1 - The shebang (already done for you above!)
#   Slide "The Shebang": #!/bin/bash tells the OS which
#   interpreter to run. Always line 1.
# ------------------------------------------------------------


# ------------------------------------------------------------
# STEP 2 - Check that the student gave their name
#   $1 is the first argument  (slide "Script Arguments")
#   -z tests if a string is empty  (slide "Common Test Operators")
#   Exit with a NON-ZERO code on failure  (slide "Exit Codes")
#
#   Example shape (from the "if Statements" slide):
#       if [ -z "$1" ]
#       then
#         echo "Usage: ./studylog.sh <your-name>"
#         exit 1
#       fi
# ------------------------------------------------------------
# TODO: write the if-block that checks for a missing name



# ------------------------------------------------------------
# STEP 3 - Store the log file name in a variable
#   Reminder: NO spaces around the = sign  (slide "Variables")
#       name="value"     # correct
#       name = "value"   # breaks!
# ------------------------------------------------------------
# TODO: create a variable called LOGFILE set to "study_log.txt"



# ------------------------------------------------------------
# STEP 4 - Append a timestamped entry to the log
#   $(...) runs a command and drops its output inline
#       (slide "Command Substitution")
#   >> appends without erasing  (slide ">> Append to a File")
#
#   Example: echo "text $(date)" >> "$FILE"
# ------------------------------------------------------------
# TODO: append a line like  '<name> studied on <date>'  to $LOGFILE
#       using $1, $(date), and >>



# ------------------------------------------------------------
# STEP 5 - Count and report total study sessions
#   wc -l counts lines  (slide "wc - Count Words & Lines")
#   < feeds a file as input  (slide "< Read Input From a File")
#
#   Example: total=$(wc -l < "$FILE")
# ------------------------------------------------------------
# TODO: store the line count of $LOGFILE in a variable called total,
#       then echo a message such as:
#       "Thanks <name>! You have logged <total> study session(s)."



# ============================================================
#  OPTIONAL STRETCH (not required for full credit)
#  - Use an if with the -ge test operator: if total is 3 or
#    more, print an encouraging "Great consistency!" message.
#  - Use a for loop to print every line already in the log.
# ============================================================
