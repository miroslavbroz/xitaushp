#!/usr/bin/gawk -f

(ARGIND==1) && (FNR>1){
  s[$1] = $2+0;
}
(ARGIND!=1) && (NF==0){
  print;
}
(ARGIND!=1) && (FNR>1){
  if (s[$1] < -1.0e-8) print;
}

