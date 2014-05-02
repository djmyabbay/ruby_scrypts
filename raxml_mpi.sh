#!/bin/sh                                                                                           
#$ -S /bin/sh                                                                                       
#$ -cwd                                                                                             
#$ -pe mpi-fillup 4-8                                                                               
export LANG=C

/usr/local/package/openmpi/1.5.4/bin/mpirun \
      -np $NSLOTS \
      -machinefile $TMPDIR/machines \
      /nshare3/home/yabbay/bin/RAxML-7.2.6/raxmlHPC-MPI-SSE3 \
      -N 1000 -f a -m PROTGAMMAIWAGF -x 12345 -p 12345 \
      -s $1 -n $1

