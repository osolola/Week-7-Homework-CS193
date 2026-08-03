# HW7 - Purdue Conditions Dashboard: Grading Notes (Instructors/TAs)

**Estimated student time:** ~60 minutes. Real live data (Open-Meteo, no key), higher complexity.
**Requires:** `curl` + `jq`. jq is preinstalled on the Purdue `data` server.

## Point breakdown (100 pts)
| # | Requirement | Pts | What to look for |
|---|-------------|-----|------------------|
| 1 | `get_json` error handling | 10 | Returns non-zero when `$?` != 0 **or** output empty (`-z`) |
| 2 | Fetch the air feed | 10 | `air=$(get_json "$aurl")` with a failure guard |
| 3 | Parse scalars with jq | 15 | `humidity`, `aqi`, `pm25` via correct `.current.*` paths |
| 4 | Array work with jq | 20 | `high`=`max`, `low`=`min`, `hot`=`select(. > $t) | length` with `--argjson` |
| 5 | Two category ladders | 15 | AQI Good/Moderate/Unhealthy **and** temp Cold/Cool/Mild/Hot via if/elif/else |
| 6 | Next-6-hours loop | 10 | `for t in $(... jq -r '...[0:6][]'); do echo ...` |
| 7 | CSV logging | 10 | Row appended to `$CSV` with `>>` (timestamp,name,temp,humidity,aqi,pm25) |
| 8 | Main location loop | 10 | `for loc in "${LOCATIONS[@]}"` + `IFS=';' read -r name lat lon` + call `report_for` |

## Correct jq paths / expressions
- Scalars: `.current.temperature_2m`, `.current.relative_humidity_2m`, `.current.us_aqi`, `.current.pm2_5`
- Arrays: `.hourly.temperature_2m | max` / `| min`
- Count: `[.hourly.temperature_2m[] | select(. > $t)] | length` (pass `--argjson t "$THRESHOLD"`)

## Common mistakes
- **Float in a bash `-le`/`-lt` test** - temps/AQI are floats; solution floors with `${temp%.*}` / `${aqi%.*}`. Accept any working guard; if a student compares a raw float they'll get `integer expression expected`.
- **`>` instead of `>>`** on the CSV - overwrites each run. Dock step 7.
- **`tee` without `-a`** - report file overwrites. Minor, mention it.
- **Forgot `IFS=';'` / used `read` without splitting** - name/lat/lon come through mangled. Dock step 8.
- **Only one location** - hard-coded WL, no loop. Dock step 8.
- **jq not installed** - `jq: command not found`; point to README install or Purdue `data`. Not a code deduction.
- **Curly/smart quotes** pasted from a doc - straight quotes only.

## Quick check (needs internet + jq)
```bash
./conditions.sh 80
cat conditions_report.txt        # dashboard for BOTH campuses
cat conditions_log.csv           # 2 new rows per run (WL + Indy)
./conditions.sh >/dev/null; wc -l conditions_log.csv   # grows by 2 each run
```
