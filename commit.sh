#!/bin/bash

if date -d "1970-01-01" +%s >/dev/null 2>&1; then
    # Linux (GNU date)
    current_date=$(date -d "1970-01-01 00:00:00" +%s)
else
    # macOS (BSD date)
    current_date=$(date -j -f "%Y-%m-%d %H:%M:%S" "1970-01-01 00:00:00" +%s)
fi

one_day=$((60 * 60 * 24))

for i in $(seq 0 999)
do
    target_timestamp=$((current_date + (i * one_day)))
    
    if date -d "@$target_timestamp" +%Y-%m-%dT%H:%M:%S >/dev/null 2>&1; then
        # Linux
        iso_date=$(date -d "@$target_timestamp" +%Y-%m-%dT%H:%M:%S)
    else
        # macOS
        iso_date=$(date -r "$target_timestamp" +%Y-%m-%dT%H:%M:%S)
    fi

    GIT_AUTHOR_DATE="$iso_date" GIT_COMMITTER_DATE="$iso_date" git commit --allow-empty -m "Commit day $((i + 1)): $iso_date"
done
