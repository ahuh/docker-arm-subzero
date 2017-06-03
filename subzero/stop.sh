#! /bin/bash

kill $(ps aux | grep SubZero | grep -v grep | awk '{print $2}')
