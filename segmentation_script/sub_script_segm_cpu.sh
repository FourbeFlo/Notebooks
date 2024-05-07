#!/bin/bash

#SBATCH --partition=shared-cpu 
#SBATCH --time=00:45:00
#SBATCH --ntasks=6
#SBATCH --mem-per-cpu=6000 # in MB
#SBATCH --output=yaltai-out.%j 

# Load necessary modules.
module load CUDA/11.8.0 GCCcore/11.3.0 Python/3.9.6

# Activate a Python virtual environment from a folder named 'yaltai-env' in the user's home directory.
source ~/yaltai-env/bin/activate

#load the segmentation model 
python Test/seg.py

#use the model with a cpu
srun yaltai kraken --device cpu -I "content/image/*" --suffix ".xml" segment --yolo content/seg_model.pt

# use the python script for changing the name of the file
python Test/change_xml_file_name.py
#zip the file 
zip -r altos_segmented.zip content/image/*xml