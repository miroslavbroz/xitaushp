! test_psf.f90
! Test the PSF subroutines.
! Miroslav Broz (miroslav.broz@email.cz), Jan 9th 2023

program test_psf

use psf_module
use write_pnm_module

implicit none
integer :: w, h
double precision, dimension(:,:), pointer :: psf

w = 16; h = 16

allocate(psf(w, h))

call psf_1(psf)
psf = psf/maxval(psf)*65535.d0
call write_pnm("psf1.pnm", psf)

call psf_gauss(2.d0, psf)
psf = psf/maxval(psf)*65535.d0
call write_pnm("psf2.pnm", psf)

call psf_moffat(2.d0, 2.d0, psf)
psf = psf/maxval(psf)*65535.d0
call write_pnm("psf3.pnm", psf)


deallocate(psf)

end program test_psf


