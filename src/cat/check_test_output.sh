#!/bin/bash

if [ -f "diff.txt" ];
then
	input="diff.txt"
	while IFS= read -r line
	do
  		if [[ $line != "Files s21_cat.txt and cat.txt are identical" ]] ; then
			exit -1
		fi
	done < "$input"
else
	echo "diff.txt file doesn't exist"
	echo "Run the tests to generate the file"
	exit 1
fi
