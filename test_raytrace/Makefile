
f90 = gfortran

opt = -O3 -pg -mcmodel=large -J../mod

lib = -L.

inc = \

obj90 = \
  ../misc/const.o \
  ../lc_polygon/polytype.o \
  ../lc_polygon/to_poly.o \
  ../lc_polygon/write_poly.o \
  ../lc_polygon/boundingbox.o \
  ../adam/intersect_AB_l.o \
  ../adam/inside_polygon.o \
  ../adam/raytrace.o \
  ../ao/write_pnm.o \
  ../shape/read_face.o \
  ../shape/read_node.o \

test_raytrace: test_raytrace.f90 $(obj90) $(inc)
	$(f90) $(opt) $(obj90) -o $@ $< $(lib)

$(obj90) : %.o:%.f90 $(inc)
	$(f90) $(opt) -c -o $@ $<

clean : FORCE
	rm -f ../mod/*.mod
	rm -f $(obj90)

FORCE :


