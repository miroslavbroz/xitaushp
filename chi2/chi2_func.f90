! chi2_func.f90
! Calculate chi^2 for a given state vector x().
! Miroslav Broz (miroslav.broz@email.cz), Feb 18th 2022

! Notation:
!
! rb .. barycentric coordinates [au]
! rh .. heliocentric coordinates [au]
! R_shp .. control-shape radii, scaled [1]
! R_star .. additional scaling [1]
! nodes .. nodes coordinates [km]
! faces .. surface faces, triangular [1]

module chi2_func_module

contains

double precision function chi2_func(x)

use const_module
use normalize_module
use subdivide_module
use read_face_module
use read_node_module
use write_face_module
use write_node_module
use chi2_func_AO_module
use chi2_func_AO2_module
use chi2_func_LC2_module

implicit none
include 'chi2.inc'
include 'dependent.inc'

double precision, dimension(ndim) :: x

! variables for numerical integration
integer, save :: NOUT
double precision, dimension(OUTMAX), save :: tout
double precision, dimension(OUTMAX,NBODMAX,3), save :: rb, vb, rh, vh

! variables for controlling the shape
double precision, dimension(NDIMMAX) :: R_shp
double precision, dimension(:,:), pointer, save :: nodes, nodes2, nodes3, nodes4, nodes5
integer, dimension(:,:), pointer, save :: faces, faces2, faces3, faces4, faces5

! internal variables
integer :: i, j, k, l, ierr, iu=10
integer, save :: i1st=0
double precision :: chi2

! get both free and fixed parameters

j = 0
do i = 1, nparam
  if (variable(i)) then
    j = j+1
    x_param(i) = x(j)
  endif
enddo

write(*,'(a,$)') "# x() array:"
write(*,*) (x(i), i=1,ndim)

! parameters -> variables, arrays for easy manipulation

j = 0
do i = 1, nshp
  j = j+1
  R_shp(i) = x_param(j)
enddo

do i = 1, nbod
  j = j+1
  R_star(i) = x_param(j)
enddo
do i = 1, nbod
  j = j+1
  P_rot(i) = x_param(j)
enddo
do i = 1, nbod
  j = j+1
  pole_l(i) = x_param(j)*deg
enddo
do i = 1, nbod
  j = j+1
  pole_b(i) = x_param(j)*deg
enddo
do i = 1, nbod
  j = j+1
  phi0(i) = x_param(j)*deg
enddo
do i = 1, nbod
  j = j+1
  albedo(i) = x_param(j)
enddo

do i = 1, 4
  j = j+1
  scattering(i) = x_param(j)
enddo
scattering(4) = scattering(4)*deg  ! bartheta

do i = 1, 2
  j = j+1
  psf_param(i) = x_param(j)
enddo

if (j.ne.nparam) then
  write(*,*) "chi2_func.f: Error number of parameters is ", j, ".ne.nparam = ", nparam
  stop
endif

if (i1st.eq.0) then

! read previous xitau output

  open(unit=iu,file="out_JDATE_barycentric.dat",status="unknown")

  i = 0
  ierr = 0
  do while (ierr.eq.0)
    i = i+1
    if (i.gt.OUTMAX) then
      write(*,*) "chi2_func.f: Error number of out_*.dat points is .gt.OUTMAX = ", OUTMAX
      stop
    endif
    do j = 1, nbod
      read(iu,*,iostat=ierr) tout(i), k, rb(i,j,1), rb(i,j,2), rb(i,j,3), vb(i,j,1), vb(i,j,2), vb(i,j,3)
    enddo
  enddo

  close(iu)
  NOUT = i-1

! convert to heliocentric (1-centric) coordinates

  do i = 1, NOUT
    do j = 1, nbod
      do k = 1, 3
        rh(i,j,k) = rb(i,j,k) - rb(i,1,k)
        vh(i,j,k) = vb(i,j,k) - vb(i,1,k)
      enddo
    enddo
  enddo

! read control shape

  call read_node("input.node", nodes)
  call read_face("input.face", faces)

  if (size(nodes,1).ne.nshp) then
    write(*,*) "chi2_func.f: Error number of nodes ", size(nodes,1), ".ne.nshp = ", nshp
    stop
  endif

  if (debug) then
    call write_node("shape1.node", nodes)
    call write_face("shape1.face", faces)
  endif

! allocation

  allocate(nodes2(size(nodes,1),size(nodes,2)))
  allocate(faces2(size(faces,1),size(faces,2)))

  i1st = 0
endif

! deform shape (only r, NOT theta, phi)

do i = 1,size(nodes,1)
  nodes2(i,:) = R_shp(i) * nodes(i,:)
enddo
faces2 = faces

if (debug) then
  call write_node("shape2.node", nodes2)
  call write_face("shape2.face", faces2)
endif

! subdivide several times

if (nsub.eq.0) then
  allocate(nodesforchi(size(nodes2,1),size(nodes2,2)))
  allocate(facesforchi(size(faces2,1),size(faces2,2)))
  nodesforchi = nodes2
  facesforchi = faces2
else if (nsub.eq.1) then
  call subdivide(nodes2, faces2, nodesforchi, facesforchi)
else if (nsub.eq.2) then
  call subdivide(nodes2, faces2, nodes3, faces3)
  call subdivide(nodes3, faces3, nodesforchi, facesforchi)
else if (nsub.eq.3) then
  call subdivide(nodes2, faces2, nodes3, faces3)
  call subdivide(nodes3, faces3, nodes4, faces4)
  call subdivide(nodes4, faces4, nodesforchi, facesforchi)
else if (nsub.eq.4) then
  call subdivide(nodes2, faces2, nodes3, faces3)
  call subdivide(nodes3, faces3, nodes4, faces4)
  call subdivide(nodes4, faces4, nodes5, faces5)
  call subdivide(nodes5, faces5, nodesforchi, facesforchi)
else
  write(*,*) 'Error: number of subdivisions nsub = ', nsub, '.gt.4'
  stop
endif

if (debug) then
  call write_node("shape3.node", nodesforchi)
  call write_face("shape3.face", facesforchi)
endif

lns = 0.d0  ! sum of ln sigma_i (for MCMC)

!
! calculate the chi^2 values
!

!  1. adaptive-optics imaging (u. silhouettes)
!  2. adaptive-optics imaging (u. lc_polygon algorithm)
!  3. light curve (u. lc_polygon algorithm)

call chi2_func_AO(chi2_AO, n_AO)

call chi2_func_AO2(NOUT, tout, rh, vh, chi2_AO2, n_AO2)

call chi2_func_LC2(NOUT, tout, rh, vh, chi2_LC, n_LC)

n_fit = n_LC + n_AO + n_AO2

chi2 = w_LC*chi2_LC + w_AO*chi2_AO + w_AO2*chi2_AO2

write(*,'(a,$)') "# n values: "
write(*,*) n_LC, n_AO, n_AO2, n_fit

write(*,'(a,$)') "# chi^2 values: "
write(*,*) chi2_LC, chi2_AO, chi2_AO2, chi2

! write hi-precision output

open(unit=iu, file="chi2_func.tmp", access="append")
write(iu,*) (x_param(j), j = 1,nparam), &
  n_SKY, n_RV, n_TTV, n_ECL, n_VIS, n_CLO, n_T3, n_LC, n_SYN, n_SED, &
  n_AO, n_AO2, n_SKY2, n_SKY3, n_OCC, n_fit, &
  chi2_SKY, chi2_RV, chi2_TTV, chi2_ECL, chi2_VIS, chi2_CLO, chi2_T3, chi2_LC, chi2_SYN, chi2_SED, &
  chi2_AO, chi2_AO2, chi2_SKY2, chi2_SKY3, chi2_OCC, chi2_MASS, chi2
close(iu)

chi2_func = chi2

! deallocate

deallocate(nodesforchi)
deallocate(facesforchi)
if (nsub.ge.2) deallocate(nodes3)
if (nsub.ge.2) deallocate(faces3)
if (nsub.ge.3) deallocate(nodes4)
if (nsub.ge.3) deallocate(faces4)
if (nsub.ge.4) deallocate(nodes5)
if (nsub.ge.4) deallocate(faces5)

return
end function chi2_func

end module chi2_func_module


