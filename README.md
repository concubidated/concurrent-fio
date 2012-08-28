Concurrent Fio Tests
==============

Allows you to run fio_testing concurrently on multiple VMs runnning on RBD

fio_testing
===========

This will need to be installed on all the VMs you are planning on running the tests on. 

	sudo apt-get install git fio
	git clone https://github.com/jgalvez/fio_testing.git

You will then just need to add the IP's of your to the vms variable and the OSD hostnames to the osds variable. 

Can then run the tests with:

	./concurrent-fio.sh
