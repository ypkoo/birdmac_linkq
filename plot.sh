#!/bin/bash

source plot_config.cfg
title="result"

for config in "${plot_configs[@]}"; do
	for mac in "${macs[@]}"; do
		result_dir=../"$title"_"$mac"
		mkdir -p ../plot_result

		period_=$(echo $config | awk '{print $1}')
		if [ $period_ = "x" ]; then
			period=$period_
		else
			period=$(expr $period_ \* 3600)
		fi
		topology=$(echo $config | awk '{print $2}')
		density=$(echo $config | awk '{print $3}')

		if [ $topology = "x" ]; then
			files=$(ls $result_dir/min_results | grep "^$y_axis\-$period\-.*\-.*\-$density$")
			echo $files
			
			rm -f temp_avg
			rm -f temp_all
			for file in $files; do
		    file_name=$result_dir/min_results/$file
		    t=$(echo $file | awk 'BEGIN {FS="-"}; {print $3}')
		    awk -v t="$t" '{sum+=$2}; END {printf "%-5d%-10.3f\n", t, sum/NR}' $file_name >> temp_avg
				awk -v t="$t" '{sum+=$2}; END {print t, sum}' $file_name >> temp_all
		  done
			echo "#" $mac >> ../plot_result/topology-$y_axis-$period-$topology-$density-avg
			cat temp_avg >> ../plot_result/topology-$y_axis-$period-$topology-$density-avg
			echo "" >> ../plot_result/topology-$y_axis-$period-$topology-$density-avg
			echo "#" $mac >> ../plot_result/topology-$y_axis-$period-$topology-$density-all
			cat temp_all >> ../plot_result/topology-$y_axis-$period-$topology-$density-all
			echo "" >> ../plot_result/topology-$y_axis-$period-$topology-$density-all
			rm -f temp_avg
			rm -f temp_all
		  file2plot=../plot_result/topology-$y_axis-$period-$topology-$density-avg
		elif [ $period = "x" ]; then
			files=$(ls $result_dir/min_results | grep "^$y_axis\-.*\-$topology\-.*\-$density$")
			rm -f temp_avg
			rm -f temp_all
			for file in $files; do
		    file_name=$result_dir/min_results/$file
		    p=$(echo $file | awk 'BEGIN {FS="-"}; {print $2}')
				p=$(expr $p \/ 3600)
		    awk -v p="$p" '{sum+=$2}; END {printf "%-5d%-10.3f\n", p, sum/NR}' $file_name >> temp_avg
				awk -v p="$p" '{sum+=$2}; END {print p, sum}' $file_name >> temp_all
		  done

			echo "#" $mac >> ../plot_result/period-$y_axis-$period-$topology-$density-avg
			sort -n temp_avg >> ../plot_result/period-$y_axis-$period-$topology-$density-avg
			echo "" >> ../plot_result/period-$y_axis-$period-$topology-$density-avg
			echo "#" $mac >> ../plot_result/period-$y_axis-$period-$topology-$density-all
			sort -n temp_all >> ../plot_result/period-$y_axis-$period-$topology-$density-all
			echo "" >> ../plot_result/period-$y_axis-$period-$topology-$density-all
			rm -f temp_avg
			rm -f temp_all
		  file2plot=../plot_result/period-$y_axis-$period-$topology-$density-avg
		fi
	done
	xmgrace $file2plot
done

