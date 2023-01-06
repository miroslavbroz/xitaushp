! test_raytrace.f90
! Test raytracing subroutine.
! Miroslav Broz (miroslav.broz@email.cz), Dec 25h 2022

program test_raytrace

use const_module
use polytype_module
use read_face_module
use read_node_module
use write_pnm_module
use to_poly_module
use write_poly_module
use raytrace_module

implicit none
integer, dimension(:,:), pointer :: faces
double precision, dimension(:,:), pointer :: nodes
type(polystype), dimension(:), pointer :: polys
double precision, dimension(:), pointer :: Phi_e
double precision, dimension(:,:), pointer :: pnm
integer :: w, h
double precision :: d_to, pixel_scale, unit

call read_face("input.face", faces)
call read_node("input.node", nodes)

unit = 1.d0
nodes = nodes-0.5d0
nodes = unit*nodes
d_to = 1.d0*au
pixel_scale = 3.6e-3*arcsec

allocate(polys(size(faces,1)))
allocate(Phi_e(size(faces,1)))

call to_poly(faces, nodes, polys)

Phi_e = 65535.d0
w = 256
h = 256

call raytrace(polys, Phi_e, d_to, pixel_scale, w, h, pnm)

call write_poly("output.poly", polys)
call write_pnm("output.pnm", pnm)

end program test_raytrace


