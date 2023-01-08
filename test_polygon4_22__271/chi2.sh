#!/bin/sh

cd ..
make main/chi2 || exit
cd test_polygon4_22__271

./chi2 < chi2.in > chi2.out

#./output.poly1.01.plt
#./output.poly2.01.plt
#./output.poly3.01.plt
#./output.polytmp.01.plt
#./output.poly4.01.plt
#./output.poly5.01.plt

#./chi2 < chi2.in > chi2.out

./chi2_AO.plt
#./chi2_LC2.plt
qiv output.*.res.pnm

