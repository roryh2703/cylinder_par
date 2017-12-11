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
define(Nz, 100) 
define(Ns, 5) 

define(rplus, calc(0.5*D))
define(rminus, calc(-1.0*rplus))
define(rhalfplus, calc(0.25*D))
define(rhalfminus, calc(-0.25*D))
define(diagplus, calc(sqrt(rhalfplus*rhalfplus+rhalfplus*rhalfplus)))
define(diagminus, calc(-1.0*diagplus))


vertices
(

    (rhalfplus   rhalfplus  0)   vlabel(v0)
    (rhalfminus  rhalfplus  0)    vlabel(v1)
    (rhalfminus  rhalfminus  0)   vlabel(v2)
    (rhalfplus   rhalfminus  0)   vlabel(v3)

    (diagplus    diagplus  0)  vlabel(v4)
    (diagminus   diagplus  0)  vlabel(v5)
    (diagminus   diagminus  0)  vlabel(v6)
    (diagplus    diagminus  0)    vlabel(v7)

    (rhalfplus    rhalfplus  Lz)  vlabel(v8)
    (rhalfminus   rhalfplus  Lz)  vlabel(v9)
    (rhalfminus   rhalfminus  Lz)  vlabel(v10)
    (rhalfplus    rhalfminus  Lz)  vlabel(v11) 

    (diagplus   diagplus Lz) vlabel(v12)
    (diagminus  diagplus Lz)  vlabel(v13)
    (diagminus  diagminus Lz)  vlabel(v14)
    (diagplus   diagminus Lz)  vlabel(v15)

);	

blocks
(

hex (v9 v8 v11 v10 v1 v0 v3 v2)  (Ns Ns Nz)  simpleGrading (1 1 1)
hex (v13 v12 v8 v9 v5 v4 v0 v1)  (Ns Ns Nz)  simpleGrading (1 1 1)
hex (v9 v10 v14 v13 v1 v2 v6 v5)  (Ns Ns Nz)  simpleGrading (1 1 1)
hex (v10 v11 v15 v14 v2 v3 v7 v6)  (Ns Ns Nz)  simpleGrading (1 1 1)
hex (v11 v8 v12 v15 v3 v0 v4 v7)  (Ns Ns Nz)  simpleGrading (1 1 1)

);


//create the quarter circles
edges
(
        arc v4 v5 (0 rplus  0)
        arc v5 v6 (rminus 0 0)
        arc v6 v7 (0 rminus  0)
        arc v7 v4 (rplus 0 0.0)

        arc v12 v13 (0 rplus Lz)
        arc v13 v14 (rminus 0.0 Lz)
        arc v14 v15 (0.0 rminus Lz)
        arc v15 v12 (rplus 0.0 Lz)
);

boundary
(
cylinder_bottom
    {
        type wall;
        faces
        ((v0 v3 v2 v1) (v0 v4 v7 v3) (v4 v0 v1 v5) (v1 v2 v6 v5) (v3 v7 v6 v2));
    }

cylinder_top
    {
        type wall;
        faces
        ((v8 v11 v10 v9) (v8 v12 v15 v11) (v12 v8 v9 v13) (v9 v10 v14 v13) (v11 v15 v14 v10));
    }
interface
    {
        type wall;
        faces
        ((v5 v4 v12 v13) (v5 v13 v14 v6) (v6 v14 v15 v7) (v7 v15 v12 v4));
    }


);

// ************************************************** *********************** //

