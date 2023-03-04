#!/bin/bash

set -x
set -e
set -u
set -o pipefail


echo "-- START --"
date

cpus=`grep -c ^processor /proc/cpuinfo`

PROJECT=/projects/coral-microbiome-review

in=coral-microbiome
trimmed=$in.trimmed

cd $PROJECT/tree/

set +e
grep -v -f exclude.txt $in.txt > $in.clean.txt
set -e

rm -fr $in.*.log
rm -fr $in.*.fas
rm -fr $in.*.aln
rm -fr $in.*.tre 
rm -fr "RAxML_"$in*

seqkit grep -f $in.clean.txt $PROJECT/data/db.fas > $in.fas

mafft --globalpair --reorder --maxiterate 1000 --thread $cpus $in.fas > $in.aln

trimal -in $in.aln -out $trimmed.aln -gappyout

time FastTreeMP -gamma -nt -gtr -slow -notop -nj -boot 1000 $in.aln > $in.tre 2>$in.fasttree.log

time FastTreeMP -gamma -nt -gtr -slow -notop -nj -boot 1000 $trimmed.aln > $trimmed.tre 2>$trimmed.fasttree.log

time raxmlHPC -T $cpus -f a -m GTRGAMMA -p 12345 -x 12345 -N 100 -s $in.aln -n $in.raxml > $in.raxml.log 2>&1

time raxmlHPC -T $cpus -f a -m GTRGAMMA -p 12345 -x 12345 -N 100 -s $trimmed.aln -n $trimmed.raxml > $trimmed.raxml.log 2>&1

date
echo "-- DONE -- "

