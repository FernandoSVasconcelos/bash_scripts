#!/bin/bash

#Encerra todos os processos relacionados ao projeto vegetação.
kill $(pgrep -f 'main-orientation.py')
kill $(pgrep -f 'main-capture.py')
kill $(pgrep -f 'main-process.py')
kill $(pgrep -f 'start1.sh')
