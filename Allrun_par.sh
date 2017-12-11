#________________________RORY ADD_____________________________________
rm -rf sed*                #sed* files start to build in the current directory

module add foam-extend/4.0 
. $FOAM_SRC_FILE
. $WM_PROJECT_DIR/bin/tools/CleanFunctions
. $WM_PROJECT_DIR/bin/tools/RunFunctions

rm -rf sed*       #random 

NB_CORES=4

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
cd ..

#__________________________________________

# Get application name
application=`getApplication`   #i.e. fsifoam


cd fluid
touch fluid.foam
runApplication blockMesh
runApplication renumberMesh -overwrite
runApplication checkMesh
runApplication setSet -batch setBatch
runApplication setsToZones -noFlipMap
runApplication decomposePar -cellDist
cd -

cd solid
touch fluid.foam
runApplication blockMesh
runApplication renumberMesh -overwrite
runApplication checkMesh
runApplication setSet -batch setBatch
runApplication setsToZones -noFlipMap
runApplication decomposePar -cellDist
cd -



#____________________________________________________________
# include...?
#cp -r solid/0 fluid/0/solid
#cp -r solid/constant fluid/constant/solid
#cp -r solid/system fluid/system/solid


./makeLinks fluid solid


cd fluid
mpirun -np $NB_CORES --allow-run-as-root fsiFoam -parallel &> log.fsiFoam

