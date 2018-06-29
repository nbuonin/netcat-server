#!/bin/bash

trap exit SIGINT

trap "rm -f fifo" EXIT

if [[ ! -p fifo ]]; then
    mkfifo fifo
fi

while [[ true ]]; do
    cat <(cat fifo) - | nc -l 8080 | awk '{ if ($2 ~ /html$/ && system("[ -f " $2 "  ]") == 0) system("printf \"HTTP/1.0 200 OK\r\rContent-Length: %s\r\n\r\n\" \"$(wc -c " $2 ")\"; cat " $2 ); else print "HTTP/1.0 500 Internal Server Error" }' > fifo
done
