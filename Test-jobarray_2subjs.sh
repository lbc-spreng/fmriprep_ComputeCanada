#!/bin/bash
#!/bin/bash
#SBATCH --job-name=fMRIprep_array
#SBATCH --output=test_fmriprep_job_3subjs_%A_%a.out
#SBATCH --time=15:00:00
#SBATCH --mem-per-cpu=30GB
#SBATCH --mail-user=giulia.baracchini@mail.mcgill.ca
#SBATCH --mail-type=ALL
#SBATCH --array=1-2
#SBATCH --account=def-nspreng

module load singularity

unset PYTHONPATH
export SINGULARITYENV_TEMPLATEFLOW_HOME=/opt/templateflow

echo "Starting task $SLURM_ARRAY_TASK_ID"
sub=$(sed -n "${SLURM_ARRAY_TASK_ID}p" filenames_prova.txt)
echo $sub

singularity run --cleanenv -B /scratch/giuliab/fmriprep_prova:/bids_data \
-B /scratch/giuliab/fmriprep_prova/derivatives:/output \
-B /scratch/giuliab/license.txt:/license \
-B /scratch/giuliab/Templateflow:/opt/templateflow \
/scratch/giuliab/poldracklab_fmriprep_1.5.9-2020-02-15-f366d90ed47d.simg \
--fs-license-file /license /bids_data /output participant --participant_label $sub \
--skip_bids_validation --work-dir /output/work_dir --output-spaces T1w OASIS30ANTs fsaverage5
