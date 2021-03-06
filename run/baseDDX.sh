#!/bin/bash
 
#SBATCH --partition=all
#SBATCH --constraint=P100
#SBATCH --no-requeue 
#SBATCH --time=80:00:00           # Maximum time request
#SBATCH --nodes=1                       # Number of nodes
#SBATCH --workdir   /home/anovak/data/Mauro/DeepJet/run
#SBATCH --job-name  DDX
#SBATCH --output    run-%j.out  # File to which STDOUT will be written
#SBATCH --error     run-%j.out  # File to which STDERR will be written
#SBATCH --mail-type FAIL, END                 # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user novak@physik.rwth-aachen.de  # Email to which notifications will be sent

INDIR=~/data/dev/80x/DDX
#rm -r $INDIR
mkdir $INDIR   
cd ~/data/Mauro/DeepJet
source gpu_env.sh
cd Train
convertFromRoot.py -i ../list_80x_train.txt -o $INDIR/dctrain -c TrainData_DeepDoubleX_reference
python Train.py -i $INDIR/dctrain/dataCollection.dc -o $INDIR/training --batch 4096 --epochs 100 --resume

convertFromRoot.py -i ../list_80x_test.txt -o $INDIR/dctest --testdatafor $INDIR/training/trainsamples.dc
python Eval.py -i $INDIR/dctest/dataCollection.dc -t $INDIR/dctrain/dataCollection.dc -d $INDIR/training_nodec -o $INDIR/res


