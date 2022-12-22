#!/usr/bin/gnuplot

set term x11
set colors classic

set xl "x"
set yl "y"
set zl "z"

set xyplane 0.0
set view equal xyz

sp \
  "<./face.awk input.node input.face" u 2:3:4 w lp,\
  "<./face.awk output.node output.face" u 2:3:4 w lp,\

pa -1

