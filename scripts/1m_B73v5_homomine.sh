#!/bin/bash

qrygene=$1
genome=$2

# output directory
outdir=/mnt/data1/home/liu3zhen/shiny/maizeHM/output/$genome

if [ ! -d $outdir ]; then
	mkdir $outdir
fi

# homomine command
hm=/mnt/data1/home/liu3zhen/shiny/maizeHM/homotools/homomine

# genome data
dbdir=/mnt/data1/home/liu3zhen/shiny/maizeHM/genomes

# run homomine
if [ ! -f ${outdir}/${qrygene}/${qrygene}.homomine.report.html ]; then
	cd $outdir
	perl $hm \
		--qrygene $qrygene \
		--qrydir ${dbdir}/B73-5.0 \
		--qrybase B73-5.0 \
		--tgtdir ${dbdir}/$genome \
		--tgtbase $genome \
		--cleanup
fi
