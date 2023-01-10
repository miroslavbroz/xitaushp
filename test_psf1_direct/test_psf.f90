! test_psf.f90
! Test the PSF subroutines.
! Miroslav Broz (miroslav.broz@email.cz), Jan 9th 2023

program test_psf

use psf_module
use convolve_module
use read_pnm_module
use write_pnm_module

implicit none
double precision, dimension(:,:), pointer :: a, b, c, psf

call read_pnm("output.0001.syn.pnm", a)
a(1,1) = 1.d0

allocate(psf(16, 16))

!call psf_1(psf)
call psf_gauss(3.d0, psf)
!call psf_moffat(2.d0, 2.d0, psf)

allocate(b(size(a,1),size(a,2)))
allocate(c(size(a,1),size(a,2)))

call convolve(a, psf, b)

psf = psf/maxval(psf)*65535.d0

call write_pnm("psf.pnm", psf)
call write_pnm("a.pnm", a)
call write_pnm("b.pnm", b)

deallocate(psf)

end program test_psf


