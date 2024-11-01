#!/bin/bash

echo "---- Running test ----"

if [ ! -f "test.mod.expected" ]; then 
	echo "File 'test.mod.expected' not found."
	echo "---- Test skipped ----"
	continue
fi

make -s
if [ $? -ne 0 ]; then 
	exit $?
fi

./modula < "test.mod" > "test.mod.actual"

diff --color "test.mod.actual" "test.mod.expected"

if [ $? -eq 0 ]; then 
	echo "---- Test passed ----"
else
	echo "---- Test failed ----"
fi

echo