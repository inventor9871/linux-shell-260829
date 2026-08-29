#!/bin/bash
mkdir {a,b,c}' dir'

for f in $(ls)
do
echo $f
done

IFS=$'\n'

for f in $(ls)
do
echo $f
done