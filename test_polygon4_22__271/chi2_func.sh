#!/bin/sh

awk '{ print $NF,$0; }' chi2_func.tmp | sort -g > chi2_func.srt

