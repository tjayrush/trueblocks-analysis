#!/usr/bin/env bash
#
# Wrangles data exported by the FileMaker Pro demo

name=$1
address=$2
path=$3

echo "Processing: ----- $name --- $address -----------------"

# The caller will tell the script where to run (this is an option in FileMaker Pro)
cd $path

# put the header row into the file
cat "header.line" | tr '\r' '\n' >data/output.csv

# fix a few things (remove AM/PM and change 'invocation' to 'call'). Append results to end of file
cat "data/$name-$address.csv" | tr '\r' '\n' | sed 's/ PM//g' | sed 's/ AM//' | sed 's/invocation/call/' >>data/output.csv

# process the data in R
Rscript -e "rmarkdown::render('output.Rmd', params = list(filepath = 'data/output.csv', address = '$address', name = '$name' ))"

# And view it
open output.html
