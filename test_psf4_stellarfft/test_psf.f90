! test_psf.f90
! Test the PSF subroutines.
! Miroslav Broz (miroslav.broz@email.cz), Jan 9th 2023

program test_psf

use psf_module
use convolve_fft_module
use read_pnm_module
use write_pnm_module

implicit none
double precision, dimension(:,:), pointer :: a, b, c, psf, psf_
integer :: i, j, n, m

call read_pnm("output.0001.syn.pnm", a)

n = size(a,1)
m = size(a,2)

call read_pnm("stellar.pnm", psf)
psf = psf/sum(psf)

allocate(b(size(a,1),size(a,2)))
allocate(psf_(size(psf,1),size(psf,2)))

! wrap-around order
do i = 1, n
  do j = 1, m
    psf_(mod(n/2+i,n)+1,mod(m/2+j,m)+1) = psf(i,j)
  enddo
enddo

call convolve_fft(a, psf_, b)

b = b/maxval(b)*65535.d0
psf = psf/maxval(psf)*65535.d0
psf_ = psf_/maxval(psf_)*65535.d0

call write_pnm("psf.pnm", psf)
call write_pnm("psf_.pnm", psf_)
call write_pnm("a.pnm", a)
call write_pnm("b.pnm", b)

deallocate(a)
deallocate(b)
deallocate(psf)
deallocate(psf_)

end program test_psf


