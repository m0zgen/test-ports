#!/bin/bash -e
# Ref: https://www.redhat.com/sysadmin/stop-using-telnet-test-port

# Sys env / paths / etc
# ---------------------------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
cd $SCRIPT_PATH

LOG_FILE="$SCRIPT_PATH/test-ports.log"
LOG_ENABLED=1

# ---------------------------------------------------------------------\

# Get datetime
# ---------------------------------------------------------------------\
get_datetime() {
  echo $(date '+%Y-%m-%d_%H:%M:%S')
}

if [ -n "$1" ] && [ -f "$1" ]; then
  while read -r line; do
    machine=$(echo "$line"| cut -d' ' -f1)|| exit 100
    ports=$(echo "$line"| cut -d' ' -f2)|| exit 101
    OLD_IFS=$OLD_IFS
    IFS=","
    for port in $ports; do
      if  (echo >/dev/tcp/"$machine"/"$port") >/dev/null 2>&1; then
        echo "OK ( $(get_datetime) ): $machine -> $port"
        
        if [[ ${LOG_ENABLED} -eq 1 ]]; then
          echo "OK ( $(get_datetime) ): $machine -> $port" >> "$LOG_FILE"
        fi

      else
        echo "ERROR ( $(get_datetime) ): $machine -> $port"
        
        if [[ ${LOG_ENABLED} -eq 1 ]]; then
          echo "ERROR ( $(get_datetime) ): $machine -> $port" >> "$LOG_FILE"
        fi
      fi
    done
    IFS=$OLD_IFS
  done < "$1"
else
  echo "ERROR: Invalid or missing data file!"
  exit 103
fi