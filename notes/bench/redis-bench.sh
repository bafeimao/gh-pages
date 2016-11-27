#!/bin/bash

SEQ=(50 100 150 200 300 400 500 1000)
for i in ${SEQ[*]}
do
        echo $i
        redis-benchmark -h 172.31.254.38 -n 100000 -r 100000 -d 50 --csv -c $i
        redis-benchmark -h 172.31.254.38 -n 100000 -r 100000 -d 50 --csv -c $i
        redis-benchmark -h 172.31.254.38 -n 100000 -r 100000 -d 50 --csv -c $i
done
