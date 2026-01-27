#!/bin/sh
ps -ef | grep "provider-5.1.26-R6.jar" | grep -v grep | awk '{print $2}' | xargs kill
