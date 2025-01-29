
#!/bin/bash

DATA_FOLDER=$HOME/PopGen_Models/data/HW1

ANNOTATION_URL="https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/integrated_call_samples_v3.20200731.ALL.ped"
ANNOTATION_PATH=$DATA_FOLDER/1KGP_phase3_22chr_annotation
SAMPLE_PATH=$DATA_FOLDER/1KGP_phase3_22chr_samples

# Get all samples
bcftools query -l ${DATA_FOLDER}/1KGP_phase3_22chr.vcf.gz > all_samples

# Install annotation
wget ${ANNOTATION_URL} -q -O tmp.csv

# Query populations -> 'SAMPLE-POPULATION' file
awk '$7 == "GBR" || $7 == "CHB" || $7 == "LWK" || $7 == "JPT" {print $2 "	" $3 "	" $2 "	" $7}' tmp.csv > annotation_samples

# Intersect with .vcf samples
join -1 1 -2 1 -t $'	' <(sort all_samples) <(sort annotation_samples) > ${ANNOTATION_PATH}
echo "Annotation saved in ${ANNOTATION_PATH}"

# 'SAMPLE' file
awk '{print $1}' ${ANNOTATION_PATH} > ${SAMPLE_PATH}
echo "Samples saved in ${SAMPLE_PATH}"

rm tmp.csv annotation_samples all_samples

