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
double precision :: factor
double precision, dimension(2) :: c_

factor = 0.50d0

allocate(silh(nsilh,2))

call read_pnm("input.pnm", pnm)

c_ = (/0.d0, 0.d0/)

call silhouette2(pnm, factor, c_, silh, use_multipoint=.true.)

call write_pnm("output.pnm", pnm)
call write_silh("output.silh", silh)

end program test_silh


