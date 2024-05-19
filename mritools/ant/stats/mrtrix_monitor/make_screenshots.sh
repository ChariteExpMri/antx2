#!/bin/bash
cd /mnt/sc-project-agtiermrt/Daten-2/Imaging/Paul_DTI/paul_TESTS_2022_exvivo_MPM_DTI/data
rm done.txt; #delete "done"-file

#./../shellscripts/qa_otherMachine.sh 1 a027
./../shellscripts/qa_otherMachine.sh 0

echo DONE!
cd /home/expmrtuser
touch done.txt #writ txt-file to know that job is finished
echo DONE2!
