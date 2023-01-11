# Makefile
# Makefile for simplex and chi^2.
# Miroslav Broz (miroslav.broz@email.cz), Sep 6th 2015

f77 = gfortran
f90 = gfortran
cc = g++

opt = -O3 -pg -mcmodel=large -Jmod 

lib = -L. -lstdc++

obj = \
  misc/eps_earth.o \
  misc/interp.o \
  misc/interp2.o \
  misc/length.o \
  misc/nula2pi.o \
  misc/vproduct.o \
  misc/uvw.o \
  misc/uvw1.o \
  misc/uvw2.o \
  misc/gammln.o \
  misc/gammp.o \
  misc/gammq.o \
  misc/gcf.o \
  misc/gser.o \
  simplex/amoeba.o \
  simplex/amotry.o \
  subplex/calcc.o \
  subplex/dasum.o \
  subplex/daxpy.o \
  subplex/dcopy.o \
  subplex/dist.o \
  subplex/dscal.o \
  subplex/evalf.o \
  subplex/fstats.o \
  subplex/newpt.o \
  subplex/order.o \
  subplex/partx.o \
  subplex/setstp.o \
  subplex/simplx.o \
  subplex/sortd.o \
  subplex/start.o \
  subplex/subopt.o \
  subplex/subplx.o \

obj90 = \
  misc/const.o \
  misc/srtidx.o \
  misc/srtint.o \
  misc/uvw_nodes.o \
  shape/read_face.o \
  shape/read_node.o \
  shape/write_face.o \
  shape/write_node.o \
  shape/write_edge.o \
  shape/edge.o \
  shape/subdivide.o \
  multipole/read_bruteforce.o \
  multipole/vector_product.o \
  multipole/normalize.o \
  multipole/normal.o \
  multipole/rotate.o \
  ao/read_pnm.o \
  ao/write_pnm.o \
  ao/write_silh.o \
  ao/shadowing.o \
  ao/silhouette.o \
  lc_polygon/polytype.o \
  lc_polygon/input.o \
  lc_polygon/boundingbox.o \
  lc_polygon/revert.o \
  lc_polygon/clip.o \
  lc_polygon/hapke.o \
  lc_polygon/lambert.o \
  lc_polygon/lommel.o \
  lc_polygon/planck.o \
  lc_polygon/read_input.o \
  lc_polygon/surface.o \
  lc_polygon/to_poly.o \
  lc_polygon/to_three.o \
  lc_polygon/uvw.o \
  lc_polygon/write1.o \
  lc_polygon/write_poly.o \
  lc_polygon/xyz.o \
  lc_polygon/centre_of_p.o \
  lc_polygon/normal_of_p.o \
  lc_polygon/shadowing_of_p.o \
  lc_polygon/rotate_of_p.o \
  lc_polygon/lc_polygon1.o \
  adam/center_pnm.o \
  adam/intersect_AB_l.o \
  adam/inside_polygon.o \
  adam/raytrace.o \
  psf/psf.o \
  psf/wrap.o \
  psf/nrtype.o \
  psf/nrutil.o \
  psf/fourrow.o \
  psf/four2.o \
  psf/realft2.o \
  psf/convolve.o \
  psf/convolve_fft.o \
  chi2/read_ephemeris.o \
  chi2/write_poles.o \
  chi2/read_AO.o \
  chi2/read_LC2.o \
  chi2/chi2_func_AO.o \
  chi2/chi2_func_AO2.o \
  chi2/chi2_func_LC2.o \
  chi2/chi2_func.o \
  main/read_dependent.o \

objc = \
  lc_polygon/clip_in_c.o \
  clipper2/clipper.engine.o \

inc = \
  simplex/simplex.inc \
  simplex/dependent.inc \
  filters/filters.inc \

all: main/chi2 main/shapesimplex main/shapesubplex

main/chi2: main/chi2.f90 $(obj90) $(obj) $(objc) $(inc)
	$(f90) $(opt) $(obj) $(obj90) $(objc) -o $@ $< $(lib)

main/shapesimplex: main/shapesimplex.f90 $(obj90) $(obj) $(objc) $(inc)
	$(f90) $(opt) $(obj) $(obj90) $(objc) -o $@ $< $(lib)

main/shapesubplex: main/shapesubplex.f90 $(obj90) $(obj) $(objc) $(inc)
	$(f90) $(opt) $(obj) $(obj90) $(objc) -o $@ $< $(lib)

$(obj90) : %.o:%.f90 $(inc)
	$(f90) $(opt) -c -o $@ $<

$(obj) : %.o:%.f $(inc)
	$(f77) $(opt) -c -o $@ $<

$(objc) : %.o:%.cpp $(inc)
	$(cc) $(opt) -c -o $@ $<

clean : FORCE
	rm -f mod/*.mod
	rm -f $(obj) $(obj90) $(objc)

FORCE :


