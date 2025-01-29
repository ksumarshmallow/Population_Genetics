##!/bin/sh

CHR=$1
SAMPLES=$2

DATA_PATH="${HOME}/PopGen_Models/data/HW1"
VCF0="${DATA_PATH}/1KGP_phase3_22chr.vcf.gz"
VCF="${DATA_PATH}/test.vcf.gz"

bcftools query -f '%POS\n' ${VCF0}|sort|uniq -cd > $DATA_PATH/dublicated.snps.txt
sed -i 's/^ *//' $DATA_PATH/dublicated.snps.txt
sed -i 's/.* //' $DATA_PATH/dublicated.snps.txt

# нужно поменять на нужный номер хромосомы
sed -i -e 's/^/22\t/' ${DATA_PATH}/dublicated.snps.txt 

bcftools view --types snps -m 2 -M 2 -S ${SAMPLES} -T ^$DATA_PATH/dublicated.snps.txt --force-samples ${VCF0} -Oz -o ${VCF}

plink --vcf ${VCF} --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 50 10 0.1 --out ${DATA_PATH}/test2

plink --vcf ${VCF} --double-id --allow-extra-chr --set-missing-var-ids @:# --maf 0.1 \
--extract ${DATA_PATH}/test2.prune.in \
--make-bed --out ${DATA_PATH}/test3

awk -vOFS='\t' '{ print $1,  $4 }' ${DATA_PATH}/test3.bim > ${DATA_PATH}/task3_var.chr${CHR}.txt
bcftools view -T ${DATA_PATH}/task3_var.chr${CHR}.txt ${VCF} -Oz -o ${DATA_PATH}/task3_chr${CHR}.pca.vcf.gz
bcftools query -f '%POS\t%REF\t%ALT\t[%GT ]\n' ${DATA_PATH}/task3_chr${CHR}.pca.vcf.gz > ${DATA_PATH}/task3_chr${CHR}.pca.txt

rm ${DATA_PATH}/test3.*
rm ${DATA_PATH}/test2.*
rm ${DATA_PATH}/dublicated.*
rm ${DATA_PATH}/test.*
