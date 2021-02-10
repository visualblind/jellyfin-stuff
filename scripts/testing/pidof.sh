#!/usr/bin/env bash
pidof -x "$(basename $0)" >/dev/null 2>&1
if [[ $? == 0 ]]; then 
    echo "$(basename $0) is already running"
    exit 1
else
   echo "$(basename $0) is not running"
fi

#Or

if [[ "`pidof -x $(basename $0) -o %PPID`" ]]; then exit; fi
