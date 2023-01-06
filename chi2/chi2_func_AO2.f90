! chi2_func_AO2.f90
! Calculate chi^2 for adaptive-optics data; ADAM version.
! Miroslav Broz (miroslav.broz@email.cz), Aug 27th 2022

module chi2_func_AO2_module

contains

subroutine chi2_func_AO2(NOUT, tout, rh, vh, chi2, n)

use const_module
use read_ao_module
use read_pnm_module
use read_ephemeris_module
use write_pnm_module
use rotate_module
use lc_polygon1_module
use raytrace_module

implicit none
include '../filters/filters.inc'
include '../simplex/simplex.inc'
include '../simplex/dependent.inc'

integer, intent(in) :: NOUT
double precision, dimension(OUTMAX), intent(in) :: tout
double precision, dimension(OUTMAX,NBODMAX,3), intent(in) :: rh, vh
double precision, intent(out) :: chi2
integer, intent(out) :: n

! observational data
integer, save :: m_OBS = 0
integer, dimension(AOMAX), save :: dataset
double precision, dimension(AOMAX), save :: t_OBS, sigma, pixel_scale, vardist, ecl, ecb
character(len=255), dimension(AOMAX), save :: file_OBS

integer, save :: N_s
double precision, dimension(OUTMAX), save :: t_s, vardist_s, ecl_s, ecb_s

! internal variables
double precision, dimension(:,:), pointer :: pnm, pnm_OBS, pnm_res
integer :: i, j, j1, j2, k, w, h
integer :: i2nd
integer :: iband
double precision :: t_interp, lite, l, b
double precision :: mag, scl, sigma2, chi_
double precision :: d_ts, d_to
double precision, dimension(3) :: n_ts, n_to
double precision :: xh_interp, yh_interp, zh_interp
double precision, dimension(NBODMAX,3) :: r_interp
double precision, dimension(3) :: hatu, hatv, hatw
double precision :: eps, zeta
character(len=80) :: str, str_

! functions
double precision, external :: interp, interp2, eps_earth

integer, save :: i1st = 0

if (.not.use_adam) return

!
! read observational data
!
if (i1st.eq.0) then

  call read_AO(file_AO2, m_OBS, t_OBS, sigma, pixel_scale, vardist, ecl, ecb, dataset, file_OBS)

  if (debug) then
    write(*,*) "# m_AO2 = ", m_OBS
  endif

! Sun ephemeris
  if (m_OBS.gt.0) then
    call read_ephemeris("ephemeris_S.dat", N_s, t_s, vardist_s, ecl_s, ecb_s)
  endif

  i1st = 1
endif  ! i1st

j1 = 2
j2 = 2
i2nd = 0
iband = 7

!pixel_scale = 0.0036d0 / 16  ! dbg

do i = 1, m_OBS

! target-observer
  l = ecl(i)
  b = ecb(i)
  d_to = vardist(i)

  n_to = -(/cos(l)*cos(b), sin(l)*cos(b), sin(b)/)

! light-time effect
  if (use_vardist) then
    lite = -d_to/clight * AU/day 
  else
    lite = 0.d0
  endif
  t_interp = t_OBS(i) + lite

! target-sun
  do while ((j2.lt.N_s).and.(t_s(j2).le.t_interp))
    j2 = j2+1
  enddo

  l = interp2(t_s(j2-1), t_s(j2), ecl_s(j2-1), ecl_s(j2), t_interp)
  b = interp(t_s(j2-1), t_s(j2), ecb_s(j2-1), ecb_s(j2), t_interp)
  d_ts = interp(t_s(j2-1), t_s(j2), vardist_s(j2-1), vardist_s(j2), t_interp)

  n_ts = -(/cos(l)*cos(b), sin(l)*cos(b), sin(b)/)

! orbiting bodies
  do while ((j1.lt.NOUT).and.(tout(j1).le.t_interp))
    j1 = j1+1
  enddo

  do j = 1, nbod
    xh_interp = interp(tout(j1-1), tout(j1), rh(j1-1,j,1), rh(j1,j,1), t_interp)  ! l-th body, x coordinate
    yh_interp = interp(tout(j1-1), tout(j1), rh(j1-1,j,2), rh(j1,j,2), t_interp)  ! y coordinate
    zh_interp = interp(tout(j1-1), tout(j1), rh(j1-1,j,3), rh(j1,j,3), t_interp)  ! z coordinate

    r_interp(j,:) = (/xh_interp, yh_interp, zh_interp/)
  enddo  ! j
!
! observed image
!
  call read_pnm(file_OBS(i), pnm_OBS)

  w = size(pnm_OBS,1)
  h = size(pnm_OBS,2)

! centering

!
! synthetic image; computed with lc_polygon
!
  call lc_polygon1(t_interp, lite, r_interp*au, n_ts, n_to, d_ts*au, d_to*au, &
    lambda_eff(iband), band_eff(iband), calib(iband), mag, i2nd)

! Note: polys5, Phi_e .. lc_polygon module variables
  call raytrace(polys5, Phi_e, d_to*au, pixel_scale(i), w, h, pnm)

! scale w. total signal
!  scl = sum(pnm_OBS)/sum(pnm)
  scl = maxval(pnm_OBS)/maxval(pnm)
  pnm = pnm*scl

  if (debug) then
    write(*,*) '# scl = ', scl
  endif
!
! chi^2 computation
!
  allocate(pnm_res(w, h))
  pnm_res = 0.d0

  do j = 1, w
    do k = 1, h
      if ((pnm(j,k).gt.0.d0).or.(pnm_OBS(j,k).gt.0.d0)) then
        sigma2 = max(pnm_OBS(j,k), 1.d0)
        pnm_res(j,k) = pnm(j,k) - pnm_OBS(j,k)
        chi_ = (pnm(j,k) - pnm_OBS(j,k))**2/sigma2
        chi2 = chi2 + chi_
        n = n+1
      endif
    enddo
  enddo

  pnm_res = min(max(pnm_res + 32768.d0, 0.d0), 65535.d0)

  if (debug) then
    write(str_,'(i4.4)') i
    str = 'output.' // trim(str_) // '.syn.pnm'
    call write_pnm(str, pnm)

    str = 'output.' // trim(str_) // '.obs.pnm'
    call write_pnm(str, pnm_OBS)

    str = 'output.' // trim(str_) // '.res.pnm'
    call write_pnm(str, pnm_res)
  endif

  deallocate(pnm)
  deallocate(pnm_OBS)
  deallocate(pnm_res)

enddo  ! i

return
end subroutine chi2_func_AO2

end module chi2_func_AO2_module

