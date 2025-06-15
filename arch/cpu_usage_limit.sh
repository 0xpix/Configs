#!/bin/bash

profile=$(powerprofilesctl get)

if [[ "$profile" == "performance" ]]; then
    echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo >/dev/null
    echo 100 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct >/dev/null
elif [[ "$profile" == "balanced" ]]; then
    echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo >/dev/null
    echo 80 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct >/dev/null

else
    echo 1 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo >/dev/null
    echo 60 | sudo tee /sys/devices/system/cpu/intel_pstate/max_perf_pct >/dev/null
fi
