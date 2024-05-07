#!/usr/bin/env python3

import psutil

def get_cpu_usage_pct():
    """
    Retrieves the current CPU usage as a percentage.
    """
    return psutil.cpu_percent(interval=1)

if __name__ == "__main__":
    print(f"{get_cpu_usage_pct()}%")
