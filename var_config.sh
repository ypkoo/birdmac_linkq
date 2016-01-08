#!/bin/bash

source config.cfg

period=$(expr $1 \* 3600)
timeout=$(expr $period \* 30 \* 1000)

echo "period="$period"
sigma="$2"
topology="$3"
seed="$4"
check_rate="$5"
density="$6"
mac="$7"
lq="$8"
home_dir=/home2/linkq/$7/lanada/app
result_dir="$title"_"$7"
rawdata_dir="$title"_"$7"/rawdata
timeout="$timeout"" > var_config.cfg
