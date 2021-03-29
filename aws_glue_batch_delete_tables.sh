#!/bin/sh
# A simple script to batch delete athena tables. Note: The AWS Api has a limit of 100 table names per query
echo Input arg: $1
response=$(aws glue get-tables --database-name sampledb)
table_names=$(echo $response| grep -Po '"Name": *\K"'$1'[^"]*"' |sed  's/\"//g')
i=0
name_list=""
for name in $table_names;
do
	name_list="$name_list $name"
	i=$((i+1))
	if [ $i -eq 100 ]
	then
		resonse=$(aws glue batch-delete-table --database-name sampledb --tables-to-delete $name_list)
		i=0
		name_list=""
	fi;
done
