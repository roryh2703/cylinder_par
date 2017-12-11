/*--------------------------------*- C++ -*----------------------------------*\
| ========= | |
| \\ / F ield | OpenFOAM: The Open Source CFD Toolbox |
| \\ / O peration | Version: 5.0 |
| \\ / A nd | Web: www.OpenFOAM.org |
| \\/ M anipulation | |
\*---------------------------------------------------------------------------*/
FoamFile
{
version 2.0;
format ascii;
class dictionary;
location "constant/polyMesh";
object blockMeshDict;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
changecom(//)changequote([,])
define(calc, [esyscmd(perl -e 'printf ($1)')])
define(VCOUNT, 0)
define(vlabel, [[// ]Vertex $1 = VCOUNT define($1, VCOUNT)define([VCOUNT], incr(VCOUNT))])


meshGenApp blockMesh;
convertToMeters 1;

define(D, 0.024)
define(PI, 3.1416)
define(Lz, calc(10*PI*D))              

define(Nx1, 60)       
define(Nx2, 40)
define(Nx3, 100)
define(Ny1, 60)
define(Ny4, calc(Nx2))
define(Nz, 100)


define(xmin, calc(-5*D))
define(xmax, calc(7*D))
define(ymax, calc(4*D))
define(ymin, calc(-1*ymax))
define(rplus, calc(0.5*D))
define(rminus, calc(-1.0*rplus))
define(diagplus, calc(rplus/sqrt(2)))
define(diagminus, calc(-1.0*diagplus))


vertices
(
    (xmin  ymax  0 )     vlabel(v0)
    (diagminus  ymax   0 )     vlabel(v1)
    (diagplus  ymax   0 )     vlabel(v2)
    (xmax  ymax  0 )     vlabel(v3)

    (xmin  diagplus   0 )     vlabel(v4)
    (diagminus   diagplus  0 )     vlabel(v5)
    (diagplus  diagplus   0 )     vlabel(v6)
    (xmax  diagplus   0 )     vlabel(v7)

    (xmin   diagminus 0 )     vlabel(v8)
    (diagminus   diagminus 0 )     vlabel(v9)
    ( diagplus   diagminus 0 )     vlabel(v10)
    (  xmax  diagminus 0 )     vlabel(v11)

    (xmin  ymin  0 )     vlabel(v12)
    ( diagminus  ymin  0 )     vlabel(v13)
    (  diagplus  ymin  0 )     vlabel(v14)
    ( xmax  ymin   0 )       vlabel(v15) 

    (xmin   ymax  Lz)      vlabel(v16) 
    (  diagminus  ymax    Lz )      vlabel(v17) 
    (  diagplus  ymax    Lz )      vlabel(v18) 
    (  xmax  ymax  Lz )      vlabel(v19) 

    ( xmin  diagplus   Lz)      vlabel(v20) 
    ( diagminus   diagplus    Lz)      vlabel(v21) 
    ( diagplus   diagplus   Lz)      vlabel(v22) 
    (  xmax   diagplus  Lz)      vlabel(v23) 

    (xmin  diagminus    Lz)      vlabel(v24) 
    ( diagminus   diagminus    Lz)      vlabel(v25) 
    (  diagplus   diagminus    Lz)      vlabel(v26) 
    (  xmax  diagminus    Lz)      vlabel(v27) 

    ( xmin   ymin     Lz)      vlabel(v28) 
    (diagminus   ymin   Lz)      vlabel(v29) 
    ( diagplus   ymin   Lz)      vlabel(v30) 
    ( xmax  ymin    Lz)      vlabel(v31) 

);	

blocks
(
    hex (v4 v5 v1 v0 v20 v21 v17 v16) (Nx1 Ny1 Nz) simpleGrading (0.05 20 1)
    hex (v5 v6 v2 v1 v21 v22 v18 v17) (Nx2 Ny1 Nz) simpleGrading (1 20 1)
    hex (v6 v7 v3 v2 v22 v23 v19 v18) (Nx3 Ny1 Nz) simpleGrading (20 20 1)
    hex (v8 v9 v5 v4 v24 v25 v21 v20) (Nx1 Ny4 Nz) simpleGrading (0.05 1 1)
    hex (v10 v11 v7 v6 v26 v27 v23 v22) (Nx3 Ny4 Nz) simpleGrading (20 1 1)
    hex (v12 v13 v9 v8 v28 v29 v25 v24) (Nx1 Ny1 Nz) simpleGrading (0.05 0.05 1)
    hex (v13 v14 v10 v9 v29 v30 v26 v25) (Nx2 Ny1 Nz) simpleGrading (1 0.05 1)
    hex (v14 v15 v11 v10 v30 v31 v27 v26) (Nx3 Ny1 Nz) simpleGrading (20 0.05 1)
);


//create the quarter circles
edges
(
arc v5 v6 ( 0 rplus 0 )
arc v6 v10 (rplus  0 0 )
arc v9 v10 ( 0 rminus 0 )
arc v9 v5 (rminus  0 0 )

arc v21 v22 ( 0 rplus  Lz)
arc v26 v22 (rplus 0  Lz)
arc v25 v26 ( 0 rminus  Lz)
arc v25 v21 (rminus 0  Lz)
);

boundary
(

    interface
    {
    type   wall;
    faces
    ((v5 v21 v22 v6) (v6 v22 v26 v10) (v10 v26 v25 v9) (v9 v25 v21 v5));
    }

    IN
    {
    type   patch;
    faces
    ((v4 v20 v16 v0) (v8 v24 v20 v4) (v12 v28 v24 v8));
    }

    OUT
    {
    type   patch;
    faces
    ((v3 v19 v23 v7) (v7 v23 v27 v11) (v11 v27 v31 v15));
    }

    SYM1
    {
    type   symmetryPlane;
    faces
    ((v16 v17 v1 v0) (v17 v18 v2 v1) (v18 v19 v3 v2) );
    }

    SYM2
    {
    type   symmetryPlane;
    faces
    ((v12 v13 v29 v28) (v13 v14 v30 v29) (v14 v15 v31 v30));
    }

    PER1
    {
    type   symmetryPlane;
    faces
    ((v0 v1 v5 v4) (v1 v2 v6 v5) (v2 v3 v7 v6) (v4 v5 v9 v8) (v6 v7 v11 v10) (v8 v9 v13 v12) 
     (v9 v10 v14 v13) (v10 v11 v15 v14));
    }

    PER2
    {
    type   symmetryPlane;
    faces
    ((v20 v21 v17 v16) (v21 v22 v18 v17) (v22 v23 v19 v18) 
     (v24 v25 v21 v20) (v26 v27 v23 v22) (v28 v29 v25 v24) (v29 v30 v26 v25) (v30 v31 v27 v26));
    }

);

// ************************************************** *********************** //

