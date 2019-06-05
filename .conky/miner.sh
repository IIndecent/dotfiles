#!/bin/bash

STATE=`systemctl is-active ethminer`

if [ "$STATE" = "active" ]; then
# "-o json" changes the output to json, but still adds the 
# character sequences for coloring output...
  mapfile -t OUTPUT < <( journalctl --no-hostname -o short -a -n 15 -u ethminer | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" )
fi

bold=$(tput bold)
normal=$(tput sgr0)

for item in "${OUTPUT[@]}"; do
  if [[ ${item[@]} == --* ]]; then
    echo "${item[@]}" | sed "s/ bash\[[0-9]*\]://g" | sed 's/^/\${color #FFF} /g'
  elif [[ ${item[@]} == *New* ]]; then
    echo "${item[@]}" | sed "s/ bash\[[0-9]*\]://g" | sed 's/^/\${color #FFF} /g'
  elif [[ ${item[@]} == *found* ]]; then
    echo "${item[@]}" | sed "s/ bash\[[0-9]*\]://g" | sed 's/^/\${color #0BA909} /g'
  elif [[ ${item[@]} == *fan=* ]]; then
    echo "${item[@]}" | sed "s/ bash\[[0-9]*\]://g" | sed 's/^/\${color #A91C87} /g'
  else
    echo "${item[@]}" | sed "s/ bash\[[0-9]*\]://g" | sed 's/^/\${color #CFB23C} /g'
  fi
done