#!/bin/bash
# ============================================================
#  CS 193 - HW7 Purdue Conditions Dashboard - INSTRUCTOR SOLUTION
#  Reference implementation. Do NOT distribute to students.
#  Requires: curl, jq. Data: Open-Meteo (free, no API key).
# ============================================================

# ---- Config ----
REPORT="conditions_report.txt"
CSV="conditions_log.csv"
THRESHOLD="${1:-75}"          # "hot hour" cutoff in F; override as ./conditions.sh 80

# name;latitude;longitude  (both Purdue campuses)
LOCATIONS=(
  "West Lafayette;40.4259;-86.9081"
  "Indianapolis;39.7684;-86.1581"
)

# ---- Helper: fetch a URL, fail if empty or curl errored ----
get_json() {
  local url="$1" out
  out=$(curl -s "$url")
  if [ $? -ne 0 ] || [ -z "$out" ]; then
    return 1
  fi
  echo "$out"
}

# ---- Build one location's report block (prints to stdout) ----
report_for() {
  local name="$1" lat="$2" lon="$3"
  local wurl="https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m&hourly=temperature_2m&temperature_unit=fahrenheit&timezone=America/Indiana/Indianapolis&forecast_days=1"
  local aurl="https://air-quality-api.open-meteo.com/v1/air-quality?latitude=$lat&longitude=$lon&current=us_aqi,pm2_5&timezone=America/Indiana/Indianapolis"

  local weather air
  weather=$(get_json "$wurl") || { echo "!! $name: weather fetch failed"; return 1; }
  air=$(get_json "$aurl")     || { echo "!! $name: air-quality fetch failed"; return 1; }

  # scalar values
  local temp humidity aqi pm25
  temp=$(echo "$weather" | jq '.current.temperature_2m')
  humidity=$(echo "$weather" | jq '.current.relative_humidity_2m')
  aqi=$(echo "$air" | jq '.current.us_aqi')
  pm25=$(echo "$air" | jq '.current.pm2_5')

  # array work with jq: day high/low and count of "hot" hours
  local high low hot
  high=$(echo "$weather" | jq '.hourly.temperature_2m | max')
  low=$(echo "$weather"  | jq '.hourly.temperature_2m | min')
  hot=$(echo "$weather"  | jq --argjson t "$THRESHOLD" '[.hourly.temperature_2m[] | select(. > $t)] | length')

  # categorize AQI
  local aqi_i="${aqi%.*}" aqi_cat
  if [ "$aqi_i" -le 50 ]; then aqi_cat="Good"
  elif [ "$aqi_i" -le 100 ]; then aqi_cat="Moderate"
  else aqi_cat="Unhealthy"; fi

  # categorize temperature
  local temp_i="${temp%.*}" temp_cat
  if [ "$temp_i" -lt 40 ]; then temp_cat="Cold"
  elif [ "$temp_i" -lt 60 ]; then temp_cat="Cool"
  elif [ "$temp_i" -lt 80 ]; then temp_cat="Mild"
  else temp_cat="Hot"; fi

  # print the block
  echo "----- $name -----"
  echo "Now:        $temp F ($temp_cat), humidity $humidity%"
  echo "Air:        AQI $aqi ($aqi_cat), PM2.5 $pm25"
  echo "Today:      high $high F / low $low F, $hot hour(s) above $THRESHOLD F"
  echo "Next 6 hrs:"
  for t in $(echo "$weather" | jq -r '.hourly.temperature_2m[0:6][]'); do
    echo "   $t F"
  done
  echo ""

  # append a structured CSV row for long-term logging
  echo "$(date +%F_%T),$name,$temp,$humidity,$aqi,$pm25" >> "$CSV"
}

# ---- Main: loop over both campuses, save + show the report ----
{
  echo "======================================================"
  echo " Purdue Conditions Dashboard - $(date)"
  echo " (hot-hour cutoff: $THRESHOLD F)"
  echo "======================================================"
  for loc in "${LOCATIONS[@]}"; do
    IFS=';' read -r name lat lon <<< "$loc"
    report_for "$name" "$lat" "$lon"
  done
} | tee -a "$REPORT"
