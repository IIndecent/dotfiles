#!/bin/bash

sleep 1
conky -c ~/.Conky/clock.conf &
conky -c ~/.Conky/cpu_hr.conf &
conky -c ~/.Conky/cpu_ring.conf &
conky -c ~/.Conky/cpu_header.conf &
conky -c ~/.Conky/cpu_content.conf &
conky -c ~/.Conky/mem_hr.conf &
conky -c ~/.Conky/mem_ring.conf &
conky -c ~/.Conky/mem_header.conf &
conky -c ~/.Conky/mem_content.conf &
#conky -c ~/.Conky/miner.conf &
