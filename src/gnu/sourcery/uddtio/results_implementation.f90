submodule(results_interface) results_implementation
  implicit none

contains

  module procedure write_formatted
    integer i

    if (allocated(this%header))write(unit,'(*(G0,:,18x))') this%header, new_line('a')

    do i=1,size(this%body,1)
      write(unit,*) this%body(i,:), new_line('a')
    end do
  end procedure

  module procedure new_results_t
    new_results_t%header = header
    new_results_t%body = body
  end procedure

  module procedure norm
    norm_of_this = maxval(abs(this%body))
  end procedure

  module procedure subtract

    type(results_t) local_difference

    select type(rhs)
      class is (results_t)
        if (allocated(this%header) .and. allocated(rhs%header)) then
          local_difference%header = "difference of " // this%header // "-" // rhs%header
        end if
        local_difference%body = this%body - rhs%body
      class default
        error stop "results_t%difference: unsupported rhs class"
    end select
    difference = local_difference
  end procedure
end submodule results_implementation
