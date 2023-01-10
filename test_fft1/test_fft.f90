! test_fft.f90
! Test the FFT subroutines.
! Miroslav Broz (miroslav.broz@email.cz), Jan 9th 2023

program test_fft

use const_module, grav => g
use read_pnm_module
use write_pnm_module
use print_pnm_module
use realft2_module

implicit none
integer :: i, j, n, m
double precision, dimension(:,:), pointer :: a, b, c, d
double complex, dimension(:,:), allocatable :: spec, b_cmplx
double complex, dimension(:), allocatable :: speq
double precision :: s, f, g

n = 16
m = 16

call read_pnm("input.pnm", a)

allocate(b(size(a,1), size(a,2)))
allocate(c(size(a,1), size(a,2)))
allocate(d(size(a,1), size(a,2)))
allocate(spec(size(a,1)/2, size(a,2)))
allocate(speq(size(a,2)))
allocate(b_cmplx(size(a,1), size(a,2)))

call realft2(a, spec, speq, 1)

do i = 1, n/2
  do j = 1, m
    b_cmplx(i,j) = spec(i,j)
  enddo
enddo
do j = 1, m
  b_cmplx(n/2+1,j) = speq(j)
enddo
do i = 2, n/2
  do j = 1, m
    b_cmplx(n-i+2,mod(m-j+2-1,m)+1) = conjg(spec(i,j))
  enddo
enddo

b_cmplx = 2.d0/(n*m) * b_cmplx

b = dble(b_cmplx)
c = aimag(b_cmplx)

call realft2(d, spec, speq, -1)

d = 2.d0/(n*m) * d

call print_pnm(a)
call print_pnm(b)
call print_pnm(c)
!call print_pnm(d)

call write_pnm("a.pnm", a)
call write_pnm("b.pnm", b)
call write_pnm("c.pnm", c)
!call write_pnm("d.pnm", d)

deallocate(a)
deallocate(b)
deallocate(c)
deallocate(d)
deallocate(spec)
deallocate(speq)
deallocate(b_cmplx)

end program test_fft


