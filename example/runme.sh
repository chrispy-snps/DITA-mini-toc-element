#!/bin/bash
rm -rf ./out

dita -i map.ditamap -f html5 -Dargs.rellinks="none" -o ./out

