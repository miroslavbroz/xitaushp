#!/usr/bin/gnuplot

set term x11
set colors classic

set xl "x"
set yl "y"
set zl "z"

set xyplane 0.0
set view equal xyz

sp \
  "<./edge.awk output.node output.twice" u 2:3:4 w lp,\

pa -1

