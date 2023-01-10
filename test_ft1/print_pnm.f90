! print_pnm.f90
! Print PNM image.
! Miroslav Broz (miroslav.broz@email.cz), Aug 28th 2020

module print_pnm_module

contains

subroutine print_pnm(pnm)

implicit none
double precision, dimension(:,:), pointer :: pnm

integer :: i, j

write(*,*) '--'
do i = 1, size(pnm,1)
  write(*,'(i3,1x,$)') i-1
  do j = 1, size(pnm,2)
    write(*,'(i5,$)') int(pnm(i,j)/256.)
  enddo
  write(*,*)
enddo
write(*,*) '--'

return

end subroutine print_pnm

end module print_pnm_module


