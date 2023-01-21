#!/bin/bash

if [ -f "clang_output.txt" ];
then
	if [ -s "clang_output.txt" ];
	then
		exit 1
	else
		echo "No style errors were found"
		echo "Code is clang-formatted"
	fi
else
	echo "clang_output.txt file doesn't exist"
	echo "Run the code style check to generate the file"
	exit 1
fi