#!/usr/bin/env bash

docker ps --format "{{.Image}} \t {{.Names}}\t {{.ID}} {{.Status}} " | grep pandora | sort | awk '  
            /unhealthy/ {print "\033[31m" $0; system(""); next}
            /healthy/ {print "\033[32m" $0; system(""); next}
            /starting/ {print "\033[33m" $0; system(""); next}
            /INFO/ {print "\033[34m" $0; system(""); next}
            1 {print; system("");}
        '
