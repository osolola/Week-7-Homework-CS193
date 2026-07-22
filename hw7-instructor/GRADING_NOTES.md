# HW7 - Study-Log Helper: Grading Notes (Instructors/TAs)

**Estimated student time:** 15-20 minutes. Beginner scripting practice.

## Point breakdown (100 pts, adjust to your scale)
| # | Requirement | Pts | What to look for |
|---|-------------|-----|------------------|
| 1 | Shebang present | 10 | `#!/bin/bash` on line 1 (given in template, but confirm not deleted) |
| 2 | Missing-name check | 25 | `if [ -z "$1" ]` (or `-z "$1"`), prints usage, `exit 1` (any non-zero) |
| 3 | LOGFILE variable | 15 | Variable assigned with **no spaces** around `=` |
| 4 | Timestamped append | 25 | Uses `$1`, command substitution `$(date)`, and `>>` (append, not `>`) |
| 5 | Count & report | 25 | `wc -l` on the file, count stored/printed, sensible message |

## Common mistakes to watch for
- **`>` instead of `>>`** - overwrites the log every run (count never grows). Dock step 4.
- **Spaces around `=`** - `LOGFILE = "..."` fails. Dock step 3.
- **Forgot to quote `"$1"` / `"$LOGFILE"`** - works until a name has a space; give a nudge, minor/no deduction for beginners.
- **`exit 0` on the error path** - the failure case should return non-zero. Dock part of step 2.
- **Curly/smart quotes** copied from a doc - script won't run. Point them to straight quotes.

## Quick auto-check
```bash
# no name -> should print usage and exit non-zero
./studylog.sh; echo "exit=$?"        # expect exit=1

# with a name -> should append and report
./studylog.sh Boiler
./studylog.sh Boiler
wc -l study_log.txt                  # expect 2
```

## Optional stretch (bonus only)
- `-ge` test for a "Great consistency!" message at 3+ sessions.
- A `for` loop (or `cat`) that lists existing entries.
