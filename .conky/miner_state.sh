STATE=`systemctl is-active ethminer`

if [ "$STATE" = "active" ]; then
  echo "Miner is $STATE" | sed 's/^/\${color #00ff00} /g'
elif [ "$STATE" = "inactive" ]; then
  echo "Miner is $STATE" | sed 's/^/\${color #ff0000} /g'
else
  echo "Miner is $STATE"
fi