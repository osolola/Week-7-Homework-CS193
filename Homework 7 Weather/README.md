# Homework 7 - Weather (Purdue Conditions Dashboard)

Everything for the Week 7 live-data bash assignment.

## Contents
- **Student/** - everything students receive.
  - `HW7_Live_Conditions_Handout.pdf` - the student handout (what to do).
  - `HW7_Live_Conditions_Handout.tex` - LaTeX source for the handout.
  - `hw7-conditions/` - the STUDENT template. This is what students open in
    their editor and fill in (start here: `hw7-conditions/conditions.sh`).
- **TA/** - INSTRUCTOR/TA ONLY. Reference solution (`conditions_SOLUTION.sh`)
  and `GRADING_NOTES.md`. Do not distribute.

## The assignment in one line
Students write a bash script that pulls live weather + air-quality JSON for
both Purdue campuses (West Lafayette + Indianapolis), parses it with `jq`,
categorizes conditions, prints a dashboard, and logs each reading to a CSV.

## Note
Students can work in **any IDE or straight from the terminal** - there is no
required editor. The `Student/hw7-conditions` folder includes optional editor
settings that some editors pick up automatically; they can be ignored.
