#!/bin/sh

# update dependencies
cmd="buf dep update"

echo "Running '$cmd'"
$cmd

status=$?

if [ "$status" != 0 ]
then
	echo "Error: $cmd failed"
	exit 1
fi

# Check lint
cmd="buf lint"
echo "Running '$cmd'"
$cmd

status=$?

if [ "$status" != 0 ]
then
	echo "Error: $cmd failed"
	exit 1
fi

# Empty tmp destination
rm -rdf tmp

# Generate output and docs
cmd="buf generate"

echo "Running '$cmd'"
$cmd

status=$?

if [ "$status" != 0 ]
then
	echo "Error: $cmd failed"
	exit 1
fi

# Set output files to match go project layout schema
rm -rdf pkg/api; mkdir pkg/api
mv tmp/pkg/api/proto/* pkg/api
rm -rdf api/swagger; mkdir api/swagger
mv tmp/api/api/proto/* api/swagger

# Empty tmp destination
rm -rdf tmp

# Generate versions.txt
ls api/swagger | grep "^v[0-9]" >| api/swagger/versions.txt

# Move swagger data to docs
rm -rdf docs/swagger
mv api/swagger docs/swagger