#!/usr/bin/gawk -f

BEGIN{
  a = 1.5;
  b = 1.2;
  c = 1.0;

  OFMT="%22.16f";
}
(FNR==1){
  print;
}
(FNR>1) && !/^#/{
  i = $1;
  x = $2;
  y = $3;
  z = $4;
  print i,a*x,b*y,c*z;
}

