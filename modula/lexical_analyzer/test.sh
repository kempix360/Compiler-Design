#!/bin/bash

NUMBER_OF_TESTS=4

for i in $(seq 1 $NUMBER_OF_TESTS);
do
	echo "---- Running test $i ----"

	if [ ! -f "tests/test$i.mod.expected" ]; then 
		echo "File 'tests/test$i.mod.expected' not found."
		echo "---- Test $i skipped ----"
		continue
	fi

	make -s
	if [ $? -ne 0 ]; then 
		exit $?
	fi

	./modula < "test$i.mod" > "tests/test$i.mod.actual"

	diff --color "tests/test$i.mod.actual" "tests/test$i.mod.expected"

	if [ $? -eq 0 ]; then 
		echo "---- Test $i passed ----"
	else
		echo "---- Test $i failed ----"
	fi
	echo
done
