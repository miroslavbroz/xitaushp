#!/usr/bin/gnuplot

set term x11

set xl "x"
set yl "y"
set zl "z"

#tmp=2.5
#set xr [-tmp:tmp]
#set yr [-tmp:tmp]
#set zr [-tmp:tmp]

set view 0,0
set view equal xyz
set size ratio -1
set xyplane 0.0
set surface hidden3d
set pm3d depthorder
set hidden3d front
unset colorbox
#set palette grayscale

p \
  "<./poly.awk output.poly" u 4:5 w lp lw 3 not,\
  "uv.dat" u 1:2 w p pt 1 not,\


pa -1

q

  "<./face.awk input.node input.face" u 2:3:4 w lp lc 'green' not,\

