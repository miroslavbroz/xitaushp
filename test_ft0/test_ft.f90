! test_ft.f90
! Test the FT subroutines.
! Miroslav Broz (miroslav.broz@email.cz), Jan 9th 2023

program test_ft

use const_module, grav => g
use read_pnm_module
use write_pnm_module
use print_pnm_module
use ft_module

implicit none
integer :: i, j, n, m
double precision, dimension(:,:), pointer :: a, b, c, d
double complex, dimension(:,:), pointer :: a_cmplx, b_cmplx
double precision :: s, f, g

n = 16
m = 16

allocate(a(n, m))
allocate(b(size(a,1), size(a,2)))
allocate(c(size(a,1), size(a,2)))
allocate(d(size(a,1), size(a,2)))
allocate(a_cmplx(size(a,1), size(a,2)))
allocate(b_cmplx(size(a,1), size(a,2)))

f = n/16
f = n/8
!f = n/4
f = n/2  ! i.e., Nyquist

!f = n/8; g = n/8

! Note: Unfortunately, sin(x) cannot be sampled at f = n/2!

do i = 1, n
  do j = 1, m
    s = 0.d0
!    s = s + 32768.d0
    s = s + 32768.d0*cos(2.d0*pi*f*dble(i-1)/n)
!    s = s + 32768.d0*cos(2.d0*pi*f*dble(j-1)/m)
!    s = s + 32768.d0*cos(2.d0*pi*g*dble(j-1)/m)
!    s = s + 32768.d0*cos(2.d0*pi*f*dble(i-1)/n)*cos(2.d0*pi*g*dble(j-1)/m)
!    s = s + 32768.d0*sin(2.d0*pi*f*dble(i-1)/n)
    a(i,j) = s
  enddo
enddo

a_cmplx = a

call ft(a_cmplx, b_cmplx)

b_cmplx = 2.d0/(n*m) * b_cmplx

b = dble(b_cmplx)
c = aimag(b_cmplx)

call print_pnm(a)
call print_pnm(b)
call print_pnm(c)

call write_pnm("a.pnm", a)
call write_pnm("b.pnm", b)
call write_pnm("c.pnm", c)

deallocate(a)
deallocate(b)
deallocate(c)
deallocate(a_cmplx)
deallocate(b_cmplx)

end program test_ft


