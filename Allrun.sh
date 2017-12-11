#________________________RORY ADD_____________________________________
module add foam-extend/4.0 
. $FOAM_SRC_FILE
. $WM_PROJECT_DIR/bin/tools/CleanFunctions
. $WM_PROJECT_DIR/bin/tools/RunFunctions

NB_CORES=3

m4 ./fluid/constant/polyMesh/blockfluidMesh.m4 > fluid/constant/polyMesh/blockMeshDict
m4 ./solid/constant/polyMesh/blocksolidMesh.m4 > solid/constant/polyMesh/blockMeshDict

sed -i s/tcsh/sh/g *Links
./removeSerialLinks fluid solid           #takes fluid and solid as input $1 and $2
./makeSerialLinks fluid solid


cd fluid

# Source tutorial clean functions
cleanCase
\rm -f constant/polyMesh/boundary
\rm -rf history
\rm -f constant/solid/polyMesh/boundary
\rm -rf constant/solid/polyMesh/[c-z]*
\rm -rf ../solid/VTK

\rm -f *.ps
\rm -f *.pdf

cd ../solid
cleanCase     %removes times directories, log files, processor directories, etc...

cd ..
./removeSerialLinks fluid
cd fluid
touch fluid.foam

#__________________________________________

# Get application name
application=`getApplication`   #i.e. fsifoam

runApplication -l log.blockMesh.solid blockMesh -case ../solid
runApplication -l log.setSet.solid setSet -case ../solid -batch ../solid/setBatch
runApplication -l log.setToZones.solid setsToZones -case ../solid -noFlipMap


cd ../solid

runApplication blockMesh
runApplication setSet -batch setBatch
runApplication setsToZones -noFlipMap
runApplication decomposePar -cellDist

for d in processor*/; do
echo $d
scp -r setBatch $d
cd $d
runApplication setSet -batch setBatch
runApplication setsToZones -noFlipMap
cd ..
done


cd ../fluid
runApplication blockMesh
runApplication setSet -batch setBatch
runApplication setsToZones -noFlipMap
runApplication decomposePar -cellDist 


for d in processor*/; do
echo $d
scp -r setBatch $d
cd $d
runApplication setSet -batch setBatch
runApplication setsToZones -noFlipMap
cd ..
done






cd ..


./makeLinks fluid solid


for d in processor*/; do
    cp -rf solid/$d/0 fluid/$d/0/solid
    cp -rf solid/$d/constant fluid/$d/constant/solid
done


cd fluid
runParallel $application 3
mpirun -np $NB_CORES --allow-run-as-root fsiFoam -parallel &> log.fsiFoam
