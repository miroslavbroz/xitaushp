
f90 = gfortran
opt = -O3 -J../mod

obj = \
	../ao/read_pnm.o \
	../ao/write_pnm.o \
	../ao/write_silh.o \
        ../ao/shadowing.o \
        ../ao/silhouette.o \

all: test_silh

test_silh: test_silh.f90 $(obj)
	$(f90) $(obj) $(opt) -o $@ $<

$(obj): %.o:%.f90
	$(f90) $(opt) -c -o $@ $<

clean:
	rm $(obj)


