interval=10
total=1
while [ $total -lt 60 ]
do
	cat /proc/loadavg | logger -t "cpu-metrics" -p INFO
	df | grep /dev | logger -t "disk-metrics" -p INFO
	cat /proc/meminfo | grep Mem | sed ':a;N;$!ba;s/\n/ /g' | logger -t "memory-metrics" -p INFO
	sleep $interval
	total=$((total + interval)) 
done
