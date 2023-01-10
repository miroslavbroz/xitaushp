MODULE nrutil
! TABLE OF CONTENTS OF THE NRUTIL MODULE:
! routines that move data:
! array copy, swap, reallocate
! routines returning a location as an integer value
! ifirstloc, imaxloc, iminloc
! routines for argument checking and error handling:
! assert, assert eq, nrerror
! routines relating to polynomials and recurrences
! arth, geop, cumsum, cumprod, poly, polyterm,
! zroots unity
! routines for ”outer” operations on vectors
! outerand, outersum, outerdiff, outerprod, outerdiv
! routines for scatter-with-combine
! scatter add, scatter max
! routines for skewop erations on matrices
! diagadd, diagmult, get diag, put diag,
! unit matrix, lower triangle, upper triangle
! miscellaneous routines
! vabs
USE nrtype
! Parameters for crossover from serial to parallel algorithms (these are used only within this
! nrutil module):
IMPLICIT NONE
INTEGER(I4B), PARAMETER :: NPAR_ARTH=16,NPAR2_ARTH=8 ! Each NPAR2 must be ≤ the
INTEGER(I4B), PARAMETER :: NPAR_GEOP=4,NPAR2_GEOP=2 ! corresponding NPAR.
INTEGER(I4B), PARAMETER :: NPAR_CUMSUM=16
INTEGER(I4B), PARAMETER :: NPAR_CUMPROD=8
INTEGER(I4B), PARAMETER :: NPAR_POLY=8
INTEGER(I4B), PARAMETER :: NPAR_POLYTERM=8
! Next, generic interfaces for routines with overloaded versions. Naming conventions for appended
! codes in the names of overloaded routines are as follows: r=real, d=double precision,
! i=integer, c=complex, z=double-precision complex, h=character, l=logical. Any of
! r,d,i,c,z,h,l may be followed by v=vector or m=matrix (v,m suffixes are used only when
! needed to resolve ambiguities).
! Routines that move data:
INTERFACE array_copy
MODULE PROCEDURE array_copy_r, array_copy_d, array_copy_i
END INTERFACE
INTERFACE swap
MODULE PROCEDURE swap_i,swap_r,swap_rv,swap_c, &
swap_cv,swap_cm,swap_z,swap_zv,swap_zm, &
masked_swap_rs,masked_swap_rv,masked_swap_rm
END INTERFACE
INTERFACE reallocate
MODULE PROCEDURE reallocate_rv,reallocate_rm,&
reallocate_iv,reallocate_im,reallocate_hv
END INTERFACE
! Routines returning a location as an integer value (ifirstloc, iminloc are not currently overloaded
! and so do not have a generic interface here):
INTERFACE imaxloc
MODULE PROCEDURE imaxloc_r,imaxloc_i
END INTERFACE
! Routines for argument checking and error handling (nrerror is not currently overloaded):
INTERFACE assert
MODULE PROCEDURE assert1,assert2,assert3,assert4,assert_v
END INTERFACE
INTERFACE assert_eq
MODULE PROCEDURE assert_eq2,assert_eq3,assert_eq4,assert_eqn
END INTERFACE

! Other routines (vabs is not currently overloaded):
CONTAINS
! Routines that move data:
SUBROUTINE array_copy_r(src,dest,n_copied,n_not_copied)
! Copy array where size of source not known in advance.
REAL(SP), DIMENSION(:), INTENT(IN) :: src
REAL(SP), DIMENSION(:), INTENT(OUT) :: dest
INTEGER(I4B), INTENT(OUT) :: n_copied, n_not_copied
n_copied=min(size(src),size(dest))
n_not_copied=size(src)-n_copied
dest(1:n_copied)=src(1:n_copied)
END SUBROUTINE array_copy_r
SUBROUTINE array_copy_d(src,dest,n_copied,n_not_copied)
REAL(DP), DIMENSION(:), INTENT(IN) :: src
REAL(DP), DIMENSION(:), INTENT(OUT) :: dest
INTEGER(I4B), INTENT(OUT) :: n_copied, n_not_copied
n_copied=min(size(src),size(dest))
n_not_copied=size(src)-n_copied
dest(1:n_copied)=src(1:n_copied)
END SUBROUTINE array_copy_d
SUBROUTINE array_copy_i(src,dest,n_copied,n_not_copied)
INTEGER(I4B), DIMENSION(:), INTENT(IN) :: src
INTEGER(I4B), DIMENSION(:), INTENT(OUT) :: dest
INTEGER(I4B), INTENT(OUT) :: n_copied, n_not_copied
n_copied=min(size(src),size(dest))
n_not_copied=size(src)-n_copied
dest(1:n_copied)=src(1:n_copied)
END SUBROUTINE array_copy_i
SUBROUTINE swap_i(a,b)
! Swap the contents of a and b.
INTEGER(I4B), INTENT(INOUT) :: a,b
INTEGER(I4B) :: dum
dum=a
a=b
b=dum
END SUBROUTINE swap_i

SUBROUTINE swap_r(a,b)
REAL(SP), INTENT(INOUT) :: a,b
REAL(SP) :: dum
dum=a
a=b
b=dum
END SUBROUTINE swap_r
SUBROUTINE swap_rv(a,b)
REAL(SP), DIMENSION(:), INTENT(INOUT) :: a,b
REAL(SP), DIMENSION(SIZE(a)) :: dum
dum=a
a=b
b=dum
END SUBROUTINE swap_rv
SUBROUTINE swap_c(a,b)
COMPLEX(SPC), INTENT(INOUT) :: a,b
COMPLEX(SPC) :: dum
dum=a
a=b
b=dum
END SUBROUTINE swap_c
SUBROUTINE swap_cv(a,b)
COMPLEX(SPC), DIMENSION(:), INTENT(INOUT) :: a,b
COMPLEX(SPC), DIMENSION(SIZE(a)) :: dum
dum=a
a=b
b=dum
END SUBROUTINE swap_cv
SUBROUTINE swap_cm(a,b)
COMPLEX(SPC), DIMENSION(:,:), INTENT(INOUT) :: a,b
COMPLEX(SPC), DIMENSION(size(a,1),size(a,2)) :: dum
dum=a
a=b
b=dum
END SUBROUTINE swap_cm
SUBROUTINE swap_z(a,b)
COMPLEX(DPC), INTENT(INOUT) :: a,b
COMPLEX(DPC) :: dum
dum=a
a=b
b=dum
END SUBROUTINE swap_z
SUBROUTINE swap_zv(a,b)
COMPLEX(DPC), DIMENSION(:), INTENT(INOUT) :: a,b
COMPLEX(DPC), DIMENSION(SIZE(a)) :: dum
dum=a
a=b
b=dum
END SUBROUTINE swap_zv
SUBROUTINE swap_zm(a,b)
COMPLEX(DPC), DIMENSION(:,:), INTENT(INOUT) :: a,b
COMPLEX(DPC), DIMENSION(size(a,1),size(a,2)) :: dum
dum=a
a=b
b=dum
END SUBROUTINE swap_zm
SUBROUTINE masked_swap_rs(a,b,mask)
REAL(SP), INTENT(INOUT) :: a,b
LOGICAL(LGT), INTENT(IN) :: mask
REAL(SP) :: swp
if (mask) then
swp=a
a=b
b=swp
end if
END SUBROUTINE masked_swap_rs
SUBROUTINE masked_swap_rv(a,b,mask)
REAL(SP), DIMENSION(:), INTENT(INOUT) :: a,b
LOGICAL(LGT), DIMENSION(:), INTENT(IN) :: mask
REAL(SP), DIMENSION(size(a)) :: swp
where (mask)
swp=a
a=b
b=swp
end where
END SUBROUTINE masked_swap_rv
SUBROUTINE masked_swap_rm(a,b,mask)
REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: a,b
LOGICAL(LGT), DIMENSION(:,:), INTENT(IN) :: mask
REAL(SP), DIMENSION(size(a,1),size(a,2)) :: swp
where (mask)
swp=a
a=b
b=swp
end where
END SUBROUTINE masked_swap_rm
FUNCTION reallocate_rv(p,n)
! Reallocate a pointer to a newsi ze, preserving its previous contents.
REAL(SP), DIMENSION(:), POINTER :: p, reallocate_rv
INTEGER(I4B), INTENT(IN) :: n
INTEGER(I4B) :: nold,ierr
allocate(reallocate_rv(n),stat=ierr)
if (ierr /= 0) call &
nrerror('reallocate_rv: problem in attempt to allocate memory')
if (.not. associated(p)) RETURN
nold=size(p)
reallocate_rv(1:min(nold,n))=p(1:min(nold,n))
deallocate(p)
END FUNCTION reallocate_rv
FUNCTION reallocate_iv(p,n)
INTEGER(I4B), DIMENSION(:), POINTER :: p, reallocate_iv
INTEGER(I4B), INTENT(IN) :: n
INTEGER(I4B) :: nold,ierr
allocate(reallocate_iv(n),stat=ierr)
if (ierr /= 0) call &
nrerror('reallocate_iv: problem in attempt to allocate memory')
if (.not. associated(p)) RETURN
nold=size(p)
reallocate_iv(1:min(nold,n))=p(1:min(nold,n))
deallocate(p)
END FUNCTION reallocate_iv
FUNCTION reallocate_hv(p,n)
CHARACTER(1), DIMENSION(:), POINTER :: p, reallocate_hv
INTEGER(I4B), INTENT(IN) :: n
INTEGER(I4B) :: nold,ierr
allocate(reallocate_hv(n),stat=ierr)
if (ierr /= 0) call &
nrerror('reallocate_hv: problem in attempt to allocate memory')
if (.not. associated(p)) RETURN
nold=size(p)
reallocate_hv(1:min(nold,n))=p(1:min(nold,n))

deallocate(p)
END FUNCTION reallocate_hv
FUNCTION reallocate_rm(p,n,m)
REAL(SP), DIMENSION(:,:), POINTER :: p, reallocate_rm
INTEGER(I4B), INTENT(IN) :: n,m
INTEGER(I4B) :: nold,mold,ierr
allocate(reallocate_rm(n,m),stat=ierr)
if (ierr /= 0) call &
nrerror('reallocate_rm: problem in attempt to allocate memory')
if (.not. associated(p)) RETURN
nold=size(p,1)
mold=size(p,2)
reallocate_rm(1:min(nold,n),1:min(mold,m))=&
p(1:min(nold,n),1:min(mold,m))
deallocate(p)
END FUNCTION reallocate_rm
FUNCTION reallocate_im(p,n,m)
INTEGER(I4B), DIMENSION(:,:), POINTER :: p, reallocate_im
INTEGER(I4B), INTENT(IN) :: n,m
INTEGER(I4B) :: nold,mold,ierr
allocate(reallocate_im(n,m),stat=ierr)
if (ierr /= 0) call &
nrerror('reallocate_im: problem in attempt to allocate memory')
if (.not. associated(p)) RETURN
nold=size(p,1)
mold=size(p,2)
reallocate_im(1:min(nold,n),1:min(mold,m))=&
p(1:min(nold,n),1:min(mold,m))
deallocate(p)
END FUNCTION reallocate_im
! Routines returning a location as an integer value:
FUNCTION ifirstloc(mask)
! Index of first occurrence of .true. in a logical vector.
LOGICAL(LGT), DIMENSION(:), INTENT(IN) :: mask
INTEGER(I4B) :: ifirstloc
INTEGER(I4B), DIMENSION(1) :: loc
loc=maxloc(merge(1,0,mask))
ifirstloc=loc(1)
if (.not. mask(ifirstloc)) ifirstloc=size(mask)+1
END FUNCTION ifirstloc
FUNCTION imaxloc_r(arr)
! Index of maxloc on an array.
REAL(SP), DIMENSION(:), INTENT(IN) :: arr
INTEGER(I4B) :: imaxloc_r
INTEGER(I4B), DIMENSION(1) :: imax
imax=maxloc(arr(:))
imaxloc_r=imax(1)
END FUNCTION imaxloc_r
FUNCTION imaxloc_i(iarr)
INTEGER(I4B), DIMENSION(:), INTENT(IN) :: iarr
INTEGER(I4B), DIMENSION(1) :: imax
INTEGER(I4B) :: imaxloc_i
imax=maxloc(iarr(:))
imaxloc_i=imax(1)
END FUNCTION imaxloc_i
FUNCTION iminloc(arr)
! Index of minloc on an array.
REAL(SP), DIMENSION(:), INTENT(IN) :: arr
INTEGER(I4B), DIMENSION(1) :: imin
INTEGER(I4B) :: iminloc
imin=minloc(arr(:))
END FUNCTION iminloc
! Routines for argument checking and error handling:
SUBROUTINE assert1(n1,string)
! Report and die if any logical is false (used for arg range checking).
CHARACTER(LEN=*), INTENT(IN) :: string
LOGICAL, INTENT(IN) :: n1
if (.not. n1) then
write (*,*) 'nrerror: an assertion failed with this tag:', &
string
STOP 'program terminated by assert1'
end if
END SUBROUTINE assert1
SUBROUTINE assert2(n1,n2,string)
CHARACTER(LEN=*), INTENT(IN) :: string
LOGICAL, INTENT(IN) :: n1,n2
if (.not. (n1 .and. n2)) then
write (*,*) 'nrerror: an assertion failed with this tag:', &
string
STOP 'program terminated by assert2'
end if
END SUBROUTINE assert2
SUBROUTINE assert3(n1,n2,n3,string)
CHARACTER(LEN=*), INTENT(IN) :: string
LOGICAL, INTENT(IN) :: n1,n2,n3
if (.not. (n1 .and. n2 .and. n3)) then
write (*,*) 'nrerror: an assertion failed with this tag:', &
string
STOP 'program terminated by assert3'
end if
END SUBROUTINE assert3
SUBROUTINE assert4(n1,n2,n3,n4,string)
CHARACTER(LEN=*), INTENT(IN) :: string
LOGICAL, INTENT(IN) :: n1,n2,n3,n4
if (.not. (n1 .and. n2 .and. n3 .and. n4)) then
write (*,*) 'nrerror: an assertion failed with this tag:', &
string
STOP 'program terminated by assert4'
end if
END SUBROUTINE assert4
SUBROUTINE assert_v(n,string)
CHARACTER(LEN=*), INTENT(IN) :: string
LOGICAL, DIMENSION(:), INTENT(IN) :: n
if (.not. all(n)) then
write (*,*) 'nrerror: an assertion failed with this tag:', &
string
STOP 'program terminated by assert_v'
end if
END SUBROUTINE assert_v
FUNCTION assert_eq2(n1,n2,string)
! Report and die if integers not all equal (used for size checking).
CHARACTER(LEN=*), INTENT(IN) :: string
INTEGER, INTENT(IN) :: n1,n2
INTEGER :: assert_eq2
if (n1 == n2) then
assert_eq2=n1
else
write (*,*) 'nrerror: an assert_eq failed with this tag:', &
string
STOP 'program terminated by assert_eq2'
end if
END function assert_eq2

FUNCTION assert_eq3(n1,n2,n3,string)
CHARACTER(LEN=*), INTENT(IN) :: string
INTEGER, INTENT(IN) :: n1,n2,n3
INTEGER :: assert_eq3
if (n1 == n2 .and. n2 == n3) then
assert_eq3=n1
else
write (*,*) 'nrerror: an assert_eq failed with this tag:', &
string
STOP 'program terminated by assert_eq3'
end if
END FUNCTION assert_eq3
FUNCTION assert_eq4(n1,n2,n3,n4,string)
CHARACTER(LEN=*), INTENT(IN) :: string
INTEGER, INTENT(IN) :: n1,n2,n3,n4
INTEGER :: assert_eq4
if (n1 == n2 .and. n2 == n3 .and. n3 == n4) then
assert_eq4=n1
else
write (*,*) 'nrerror: an assert_eq failed with this tag:', &
string
STOP 'program terminated by assert_eq4'
end if
END FUNCTION assert_eq4
FUNCTION assert_eqn(nn,string)
CHARACTER(LEN=*), INTENT(IN) :: string
INTEGER, DIMENSION(:), INTENT(IN) :: nn
INTEGER :: assert_eqn
if (all(nn(2:) == nn(1))) then
assert_eqn=nn(1)
else
write (*,*) 'nrerror: an assert_eq failed with this tag:', &
string
STOP 'program terminated by assert_eqn'
end if
END FUNCTION assert_eqn
SUBROUTINE nrerror(string)
! Report a message, then die.
CHARACTER(LEN=*), INTENT(IN) :: string
write (*,*) 'nrerror: ',string
STOP 'program terminated by nrerror'
END SUBROUTINE nrerror
! Routines relating to polynomials and recurrences:
FUNCTION arth_r(first,increment,n)
! Array function returning an arithmetic progression.
REAL(SP), INTENT(IN) :: first,increment
INTEGER(I4B), INTENT(IN) :: n
REAL(SP), DIMENSION(n) :: arth_r
INTEGER(I4B) :: k,k2
REAL(SP) :: temp
if (n > 0) arth_r(1)=first
if (n <= NPAR_ARTH) then
do k=2,n
arth_r(k)=arth_r(k-1)+increment
end do
else
do k=2,NPAR2_ARTH
arth_r(k)=arth_r(k-1)+increment
end do
temp=increment*NPAR2_ARTH
k=NPAR2_ARTH
do
if (k >= n) exit
k2=k+k
arth_r(k+1:min(k2,n))=temp+arth_r(1:min(k,n-k))
temp=temp+temp
k=k2
end do
end if
END FUNCTION arth_r
FUNCTION arth_d(first,increment,n)
REAL(DP), INTENT(IN) :: first,increment
INTEGER(I4B), INTENT(IN) :: n
REAL(DP), DIMENSION(n) :: arth_d
INTEGER(I4B) :: k,k2
REAL(DP) :: temp
if (n > 0) arth_d(1)=first
if (n <= NPAR_ARTH) then
do k=2,n
arth_d(k)=arth_d(k-1)+increment
end do
else
do k=2,NPAR2_ARTH
arth_d(k)=arth_d(k-1)+increment
end do
temp=increment*NPAR2_ARTH
k=NPAR2_ARTH
do
if (k >= n) exit
k2=k+k
arth_d(k+1:min(k2,n))=temp+arth_d(1:min(k,n-k))
temp=temp+temp
k=k2
end do
end if
END FUNCTION arth_d
FUNCTION arth_i(first,increment,n)
INTEGER(I4B), INTENT(IN) :: first,increment,n
INTEGER(I4B), DIMENSION(n) :: arth_i
INTEGER(I4B) :: k,k2,temp
if (n > 0) arth_i(1)=first
if (n <= NPAR_ARTH) then
do k=2,n
arth_i(k)=arth_i(k-1)+increment
end do
else
do k=2,NPAR2_ARTH
arth_i(k)=arth_i(k-1)+increment
end do
temp=increment*NPAR2_ARTH
k=NPAR2_ARTH
do
if (k >= n) exit
k2=k+k
arth_i(k+1:min(k2,n))=temp+arth_i(1:min(k,n-k))
temp=temp+temp
k=k2
end do
end if
END FUNCTION arth_i
!FUNCTION geop_r(first,factor,n)
!Array function returning a geometric progression.
!REAL(SP), INTENT(IN) :: first,factor

END module nrutil
