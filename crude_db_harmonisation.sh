#!/bin/bash

# set up dirs
mkdir -p dbs

# get the resfinder database (skipping pointfinder for now)
git clone https://bitbucket.org/genomicepidemiology/resfinder_db
cat resfinder_db/*.fsa > dbs/resfinder.fna
rm -rf resfinder_db

# get the resfinderFG database
git clone https://github.com/BigDataBiology/ResFinderFG
cp ResFinderFG/ResFinder_FG.txt dbs/resfinder_fg.faa

# get the NCBI databases
wget -c https://ftp.ncbi.nlm.nih.gov/pathogen/Antimicrobial_resistance/AMRFinderPlus/database/latest/AMRProt
mv AMRProt dbs/ncbi_amr.faa

# get the SARG database
wget -c https://smile.hku.hk/SARGs/static/images/Ublastx_stageone2.3.tar.gz
tar zxf Ublastx_stageone2.3.tar.gz
cp Ublastx_stageone2.3/DB/SARG.2.2.fasta dbs/sarg.faa

# get DeepARG-DB
# Deprecated because of low mapping rate. 
# wget -c http://bench.cs.vt.edu/ftp/argminer/release/ARGminer-v1.1.0.A.fasta -O dbs/deeparg.faa
# Use this one instead
git clone https://bitbucket.org/gusphdproj/deeparg-largerepo/
cp deeparg-largerepo/database/v2/features.fasta dbs/deeparg.faa

# get latest CARD database
wget -c -O dbs/card.tar.bz2 https://card.mcmaster.ca/latest/data 
tar -xvf dbs/card.tar.bz2 -C dbs
ls -hl dbs

# get latest megares database
wget -c -O dbs/megares.fna https://megares.meglab.org/download/megares_v2.00/megares_full_database_v2.00.fasta

# get latest argannot database
wget -c -O dbs/argannot.fna https://raw.githubusercontent.com/tseemann/abricate/master/db/argannot/sequences

# load latest card into rgi
rgi load -i dbs/card.json

# run rgi on both of these databases
# got to do CDS as resfinder doesn't have 
mkdir -p mapping
rgi main -i dbs/resfinder.fna -o mapping/resfinder_rgi -t contig -a BLAST --clean --include_loose
rgi main -i dbs/ncbi_amr.faa -o mapping/ncbi_rgi -t protein -a BLAST --clean --include_loose
rgi main -i dbs/sarg.faa -o mapping/sarg_rgi -t protein -a BLAST --clean --include_loose
rgi main -i dbs/resfinder_fg.faa -o mapping/resfinder_fg_rgi -t protein -a BLAST --clean --include_loose
rgi main -i dbs/deeparg.faa -o mapping/deeparg_rgi -t protein -a BLAST --clean --include_loose
rgi main -i dbs/argannot.fna -o mapping/argannot_rgi -t contig -a BLAST --clean --include_loose
rgi main -i dbs/megares.fna -o mapping/megares_rgi -t contig -a BLAST --clean --include_loose

# reconcile the databases
python reconcile.py -f dbs/resfinder.fna -r mapping/resfinder_rgi.txt -d resfinder
python reconcile.py -f dbs/ncbi_amr.faa -r mapping/ncbi_rgi.txt -d ncbi
python reconcile.py -f dbs/sarg.faa -r mapping/sarg_rgi.txt -d sarg
python reconcile.py -f dbs/resfinder_fg.faa -r mapping/resfinder_fg_rgi.txt -d resfinder_fg
python reconcile.py -f dbs/deeparg.faa -r mapping/deeparg_rgi.txt -d deeparg
python reconcile.py -f dbs/argannot.fna -r mapping/argannot_rgi.txt -d argannot
python reconcile.py -f dbs/megares.fna -r mapping/megares_rgi.txt -d megares

# Maybe post-process sarg output

# tidy up
mv {megares,ncbi,resfinder,argannot,sarg,deeparg,resfinderfg}_ARO_mapping.tsv mapping

# combine outputs
awk -F $'\t' 'NR == 1 || FNR > 1'  mapping/*_ARO_mapping.tsv > resfinder_ncbi_sarg_resfinderfg_deeparg_ARO_mapping.tsv


