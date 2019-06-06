#!/bin/bash

sleep 1
conky -c ~/.conky/clock.conf &
conky -c ~/.conky/cpu_hr.conf &
conky -c ~/.conky/cpu_ring.conf &
conky -c ~/.conky/cpu_header.conf &
conky -c ~/.conky/cpu_content.conf &
conky -c ~/.conky/mem_hr.conf &
conky -c ~/.conky/mem_ring.conf &
conky -c ~/.conky/mem_header.conf &
conky -c ~/.conky/mem_content.conf &
#conky -c ~/.conky/miner.conf &
