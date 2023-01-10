
f90 = gfortran
opt = -O3 -J../mod

obj = \
  ../misc/const.o \
  ../ao/read_pnm.o \
  ../ao/write_pnm.o \
  ../psf/nrtype.o \
  ../psf/nrutil.o \
  ../psf/fourrow.o \
  ../psf/four2.o \
  ../psf/realft2.o \
  print_pnm.o \

all: test_fft

test_fft: test_fft.f90 $(obj)
	$(f90) $(opt) $(obj) -o $@ $<

$(obj): %.o:%.f90
	$(f90) -c $(opt) -o $@ $<

clean:
	rm $(obj)
	rm ../mod/*.mod


