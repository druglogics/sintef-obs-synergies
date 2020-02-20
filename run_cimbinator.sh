#!/bin/bash

# where is the rbbt image?
rbbt_img="/home/john/soft/rbbt.SINTEF.img"

# the cell lines
cell_lines="A498 AGS Colo205 DU145 MDA-MB-468 SF295 SW620 UACC62"

echo "--- Bliss Analysis CImbinator ---\n"

for cell_line in $cell_lines; do
  echo Cell line: "$cell_line"
  start=`date +%s`
  singularity exec -e $rbbt_img rbbt workflow task SINTEF bliss --cell_line=$cell_line > /dev/null 2>&1
  runtime=$(($(date +%s)-$start))
  echo Execution Time: "$(($runtime / 60)) minutes and $(($runtime % 60)) seconds"
  printf "\n"
done

echo "--- HSA Analysis CImbinator ---\n"

for cell_line in $cell_lines; do
  echo Cell line: "$cell_line"	
  start=`date +%s`      
  singularity exec -e $rbbt_img rbbt workflow task SINTEF hsa --cell_line=$cell_line > /dev/null 2>&1
  runtime=$(($(date +%s)-$start))
  echo Execution Time: "$(($runtime / 60)) minutes and $(($runtime % 60)) seconds"
  printf "\n"
done
