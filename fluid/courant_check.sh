#!/bin/bash
set logscale y
set title "Courant number"
set ylabel 'Co'
set xlabel 'Iteration'
plot "< cat log.fsiFoam | grep 'Courant Number mean' | cut -d' ' -f4 | tr -d ','" title 'Co mean' with lines,\
"< cat log.fsiFoam | grep 'Courant Number mean' | cut -d' ' -f6 | tr -d ','" title 'Co max' with lines
pause 1
reread

# the code sed -n 'p;N;N' chooses which line of pressure correction to plot. The number of 'N' determines how many the ploting ignores. If 3 GAMG pressure solvers are employed, then 'p;N;N' will plot the FIRST GAMG, ignore the next two.

# -f9 determines which field to plot, counted after 'GAMG:', for example: "solving for p". e.g. GAMG: Solving for p, Initial residual = 0.193462, Final residual = 1.37372e-05, No Iterations 8. In this example the 9th field is 1.37372e-05.
