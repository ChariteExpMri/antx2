#!/bin/bash
#SBATCH --job-name=bum        #Specify job name
#SBATCH --output=bum.o%A_%a        #FileName of output with %A(jobID) and %a(array-index);(alternative: .o%j)
#SBATCH --error=bum.e%A_%a         #FileName of error with %A(jobID) and %a(array-index);alternative: .e%j)

#SBATCH --partition=compute         # Specify partition name
#SBATCH --nodes=1                   # Specify number of nodes
#SBATCH --cpus-per-task=100         # Specify number of CPUs (cores) per task
#SBATCH --time=48:00:00             # Set a limit on the total run time; example: 22:00:00(22hours) or 7-00(7days)
#SBATCH --array=1-3                 # Specify array elements (indices), i.e. indices of of parallel processed dataSets  

eval "$(/opt/conda/bin/conda shell.bash hook)" # Conda initialization in the bash shell
conda activate /sc-projects/sc-proj-agtiermrt/Daten-2/condaEnvs/dtistuff        # Activate conda virtual environment


animalID=$(printf "%03d" $SLURM_ARRAY_TASK_ID)                #obtain SLURM-array-ID 
cd /sc-projects/sc-proj-agtiermrt/Daten-2/Imaging/Paul_DTI/paul_TESTS_2022_exvivo_MPM_DTI/data/a$animalID
./../../shellscripts/run_mrtrix.sh


# ====================================================
#   INFOS:    DIRS   &   ANIMAL NAMES   
# ====================================================
# ___ animal [a001]: "20220725AB_MPM_12-4_DTI_T2_MPM" ___
# ___ animal [a002]: "20220725AB_MPM_18-9_DTI_T2_MPM" ___
# ___ animal [a003]: "20220726AB_MPM_12-5_DTI_T2_MPM" ___
