# HW7 - Purdue Conditions Dashboard

Write a bash script that pulls **live** weather and air-quality data for
**both Purdue campuses** (West Lafayette + Indianapolis) from two free web
APIs (no account, no API key), reads the JSON with `jq`, and prints a
dashboard: current conditions, air quality, and today's temperature pattern.
It also appends every reading to `conditions_log.csv`.

## One-time setup: install jq (JSON parser)
- **macOS:**  `brew install jq`
- **Ubuntu/WSL/Linux:**  `sudo apt install jq`
- **Windows:**  `choco install jq`  (or `winget install jqlang.jq`)
- **Purdue `data` server:** already installed - just SSH in and go.

Check it works:  `jq --version`

## Run it
```bash
chmod +x conditions.sh
./conditions.sh          # uses a default "hot hour" cutoff of 75 F
./conditions.sh 80       # or pass your own cutoff
```

Example output (numbers reflect the live weather when you run it):
```
======================================================
 Purdue Conditions Dashboard - Sat Aug  2 14:10:00 EDT 2026
 (hot-hour cutoff: 75 F)
======================================================
----- West Lafayette -----
Now:        81.5 F (Hot), humidity 58%
Air:        AQI 42 (Good), PM2.5 9.1
Today:      high 86.0 F / low 64.0 F, 8 hour(s) above 75 F
Next 6 hrs:
   64.0 F
   64.4 F
   ...
----- Indianapolis -----
...
```
Run it a few times and open `conditions_log.csv` to see your history grow.

## Where to look for help
Open `conditions.sh` - every TODO names the exact lecture slide, and the
top of the file has a `jq` guide covering single values AND arrays. Stuck?
Post on Ed Discussion (show what you've tried!).
