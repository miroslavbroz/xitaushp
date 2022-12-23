#!/usr/bin/gawk -f

(NR==1){
  i=1;
  while (($i!="nlc") && (i<=NF)) {
    printf("# % 2d %s\n", i, $i);  # dbg
    i++;
  }
  n=i-2*15;

  prn();
}
(NR>=1){
  printf("%04d ", NR);
  for (i=1; i<=n; i++) {
    if ($i!=s[i]) {
      printf 1 " ";
    } else {
      printf 0 " ";
    }
    s[i]=$i;
  }
  print $NF;
}
END{
  prn();
}

func prn() {
  printf "     ";
  j=0;
  for (i=1; i<=n; i++) {
    j++;
    if (j>9) {
      j=0;
      printf "| ";
    } else {
      printf j " ";
    }
  }
  print "chi2";
}

