! test_silh.f90
! Test silhouette computation.
! Miroslav Broz (miroslav.broz@email.cz), Aug 27th 2020

program test_silh

use read_pnm_module
use write_pnm_module
use write_silh_module
use silhouette_module

implicit none

double precision, dimension(:,:), pointer :: pnm
double precision, dimension(:,:), pointer :: silh
double precision :: silh_factor
double precision, dimension(2) :: c_
integer :: i

silh_factor = 0.5d0
!silh_factor = 0.1d0

allocate(silh(nsilh,2))

call read_pnm("input.pnm", pnm)

c_ = (/0.d0, 0.d0/)

call silhouette2(pnm, silh_factor, c_, silh, use_multipoint=.false.)

call write_pnm("output.pnm", pnm)
call write_silh("output.silh", silh)

call silhouette2(pnm, silh_factor, c_, silh, use_multipoint=.true.)

do i = 1, size(silh,1)
  silh(i,:) = silh(i,:) + (/0.5d0, -0.5d0/)
enddo

call write_silh("output.silh_", silh)

end program test_silh


