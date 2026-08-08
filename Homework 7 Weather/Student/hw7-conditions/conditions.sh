#!/bin/bash
# ============================================================
#  CS 193 - Homework 7: Purdue Conditions Dashboard
#  Build a script that pulls REAL live data for BOTH Purdue
#  campuses (West Lafayette + Indianapolis) from two free web
#  APIs (no account or API key), reads the JSON, and prints a
#  dashboard with current conditions, air quality, and today's
#  temperature pattern. It also logs each reading to a CSV.
#
#  Concepts (all from lecture, plus jq for JSON):
#    functions  for-loops  arrays  variables  $( )
#    if/elif/else  test operators  curl  >>  (and jq)
#
#  jq mini-guide (JSON parser):
#    echo "$json" | jq '.current.temperature_2m'   # one value
#    echo "$json" | jq '.hourly.temperature_2m | max'   # array -> max
#    echo "$json" | jq '.hourly.temperature_2m | min'   # array -> min
#    echo "$json" | jq -r '.hourly.temperature_2m[0:6][]' # first 6, raw
#    # count array items over a number N:
#    echo "$json" | jq --argjson t 75 \
#        '[.hourly.temperature_2m[] | select(. > $t)] | length'
# ============================================================

# ---- Config (given) ----
REPORT="conditions_report.txt"
CSV="conditions_log.csv"
THRESHOLD="${1:-75}"          # "hot hour" cutoff in F; ./conditions.sh 80 overrides it

# name;latitude;longitude  (both Purdue campuses)
LOCATIONS=(
  "West Lafayette;40.4259;-86.9081"
  "Indianapolis;39.7684;-86.1581"
)

# ------------------------------------------------------------
# HELPER - fetch a URL and fail if it came back empty
#   curl -s hides the progress bar (slide "curl").
#   Return non-zero on failure so the caller can react
#   (slides "Exit Codes", "Common Test Operators").
# ------------------------------------------------------------
get_json() {
  local url="$1" out
  out=$(curl -s "$url")
  # TODO: if the fetch failed ($? not 0) OR $out is empty, `return 1`

  echo "$out"
}

# ------------------------------------------------------------
# report_for NAME LAT LON  -> prints one campus's block
# ------------------------------------------------------------
report_for() {
  local name="$1" lat="$2" lon="$3"
  local wurl="https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m&hourly=temperature_2m&temperature_unit=fahrenheit&timezone=America/Indiana/Indianapolis&forecast_days=1"
  local aurl="https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$lat&longitude=$lon&current=us_aqi,pm2_5&timezone=America/Indiana/Indianapolis"

  local weather air
  weather=$(get_json "$wurl") || { echo "!! $name: weather fetch failed"; return 1; }
  # TODO: fetch the air-quality feed into `air` the same way (fail with a message)

  # --- scalar values (temperature is done for you) ---
  local temp humidity aqi pm25
  temp=$(echo "$weather" | jq '.current.temperature_2m')
  # TODO: humidity  <- .current.relative_humidity_2m   (from $weather)
  # TODO: aqi       <- .current.us_aqi                 (from $air)
  # TODO: pm25      <- .current.pm2_5                  (from $air)

  # --- array values: today's high/low and count of hot hours ---
  local high low hot
  # TODO: high <- jq  '.hourly.temperature_2m | max'
  # TODO: low  <- jq  '.hourly.temperature_2m | min'
  # TODO: hot  <- jq with --argjson (see the jq guide up top) counting
  #              hourly temps greater than $THRESHOLD

  # --- categorize AQI:  0-50 Good, 51-100 Moderate, 101+ Unhealthy ---
  local aqi_i="${aqi%.*}" aqi_cat
  # TODO: set aqi_cat with if / elif / else using -le

  # --- categorize temperature: <40 Cold, <60 Cool, <80 Mild, else Hot ---
  local temp_i="${temp%.*}" temp_cat
  # TODO: set temp_cat with if / elif / else

  # --- print the block ---
  echo "----- $name -----"
  echo "Now:        $temp F ($temp_cat), humidity $humidity%"
  echo "Air:        AQI $aqi ($aqi_cat), PM2.5 $pm25"
  echo "Today:      high $high F / low $low F, $hot hour(s) above $THRESHOLD F"
  echo "Next 6 hrs:"
  # TODO: for-loop over the first 6 hourly temps (jq -r ... [0:6][]) and
  #       echo each one indented, e.g.  "   72.8 F"

  echo ""

  # --- log a structured CSV row for long-term tracking ---
  # TODO: append  date,name,temp,humidity,aqi,pm25  to $CSV  with >>
  #       hint: date +%F_%T gives a compact timestamp
}

# ------------------------------------------------------------
# MAIN - loop over both campuses; show AND save the dashboard
# ------------------------------------------------------------
{
  echo "======================================================"
  echo " Purdue Conditions Dashboard - $(date)"
  echo " (hot-hour cutoff: $THRESHOLD F)"
  echo "======================================================"
  # TODO: for each entry in LOCATIONS, split it on ';' into name/lat/lon
  #       (hint: IFS=';' read -r name lat lon <<< "$loc")
  #       then call:  report_for "$name" "$lat" "$lon"

} | tee -a "$REPORT"
