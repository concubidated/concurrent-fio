#!/bin/bash

vms="192.168.122.199 192.168.122.117"
osds="burnupi57 burnupi58 burnupi59"

SIZE_OF_TEST="4096m"
TEST_FILENAME="fio_test_file"
IO_DEPTH="64"

YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
TIME=`date +%H-%M-%S`
RESULT_PATH="/home/ubuntu/fio_testing/results/concurrent/"

for vm in $vms
do
	ssh ubuntu@$vm mkdir -p $RESULT_PATH
done


#Gets tests to run
tests=`ssh ubuntu@192.168.122.199 ls -1 /home/ubuntu/fio_testing/enabled-tests`

for t in $tests
do 
	for  vm in $vms
	do
		echo "Running $t on $vm"
        	ssh ubuntu@$vm "export TEST_SIZE=${SIZE_OF_TEST} && export IO_DEPTH=${IO_DEPTH} && export TEST_FILENAME=${TEST_FILENAME} && fio --output=${RESULT_PATH}/${TIME}-${t} /home/ubuntu/fio_testing/enabled-tests/${t}" &
	done

	#Wait for subprocesses to finish
	wait

	echo "Test $t finished on VM(s)"

       	for osd in $osds
       	do
        	ssh root@$osd "echo 3 > /proc/sys/vm/drop_caches"
       		echo "Caches Dropped on $osd";
        done
done
