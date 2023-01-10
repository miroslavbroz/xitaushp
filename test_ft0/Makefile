
f90 = gfortran
opt = -O3 -J../mod

obj = \
  ../misc/const.o \
  ../ao/read_pnm.o \
  ../ao/write_pnm.o \
  ../psf/ft.o \
  print_pnm.o \

all: test_ft

test_ft: test_ft.f90 $(obj)
	$(f90) $(opt) $(obj) -o $@ $<

$(obj): %.o:%.f90
	$(f90) -c $(opt) -o $@ $<

clean:
	rm $(obj)
	rm ../mod/*.mod


