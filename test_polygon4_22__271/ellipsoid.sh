#!/bin/sh

#./ellipsoid.awk sphere.1.node > ellipsoid.1.node
#cp sphere.1.face ellipsoid.1.face

#./ellipsoid.plt

awk 'BEGIN{ OFMT="%12.8f" }(NR>1){ print sqrt($2**2+$3**2+$4**2)+1.0e-10; }' < ellipsoid.1.node > ellipsoid.tmp

