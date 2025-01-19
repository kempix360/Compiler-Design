#!/bin/bash

NUMBER_OF_TESTS=2

for i in $(seq 1 $NUMBER_OF_TESTS);
do
	echo "---- Running test $i ----"

	if [ ! -f "tests/Test$i.xml" ]; then 
		echo "File 'tests/Test$i.xml' not found."
		echo "---- Test $i skipped ----"
		continue
	fi

	make -s
	if [ $? -ne 0 ]; then 
		exit $?
	fi

	./x < "tests/Test$i.xml" > "tests/Test$i.xml.actual"

	diff --color "tests/Test$i.xml.actual" "tests/Test$i.xml"

	if [ $? -eq 0 ]; then 
		echo "---- Test $i passed ----"
	else
		echo "---- Test $i failed ----"
	fi
	echo
done
