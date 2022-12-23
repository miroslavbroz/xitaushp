#!/usr/bin/gnuplot

set term x11

set xl "x"
set yl "y"
set zl "z"

set view equal xyz
set xyplane 0.0

sp "<./face.awk ellipsoid.1.node ellipsoid.1.face" u 2:3:4 w lp

pa -1


