#!/bin/bash

# while true
#    open a netcat session listeing on port 40
#    pipe the result to a fifo and echo back the message received
#    close the connection and loop again

trap "rm -f fifo" EXIT

if [[ ! -p fifo ]]; then
    mkfifo fifo
fi

while [[ true ]]; do
    cat fifo | nc -l 8080 | awk '{ if ($2 ~ /html/ && system("[ -f " $2 "  ]") == 0) system("cat " $2); else print "500" }' > fifo
done
