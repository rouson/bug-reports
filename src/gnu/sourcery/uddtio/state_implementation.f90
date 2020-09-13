submodule(state_interface) state_implementation
  use kind_parameters, only : rkind
  implicit none

contains

  module procedure define
    use gas_interface, only : gas_t
    real(rkind) :: temperature_, pressure_
      integer, parameter :: success = 0
      character(len=128) error_message
      integer :: io_status, file_unit
    namelist/state_list/ temperature_, pressure_

    this%time_ = time
    this%burn_depth_ = burn_depth


      open(newunit=file_unit, file=input_file, status="old", iostat=io_status, iomsg=error_message)
      read(file_unit, nml=state_list)
      close(file_unit)

    associate(V => (volume), T => (temperature_), p => (pressure_))
      associate(R_gas => gas%R_gas(), c_v => gas%c_v())
        this%mass_ = p*V/(R_gas*T)
        this%energy_ = this%mass_*c_v*T
      end associate
    end associate
  end procedure

  module procedure new_state
    new_state%mass_ = mass
    new_state%energy_ = energy
    new_state%burn_depth_= burn_depth
    new_state%time_ = time
  end procedure

  module procedure row_vector
    row_vector = reshape([this%time_, this%mass_, this%energy_, this%burn_depth_], [1,4])
  end procedure

  module procedure time
    real(rkind) time
    time = this%time_
  end procedure

  module procedure burn_depth
    burn_depth = this%burn_depth_
  end procedure

  module procedure energy
    energy = this%energy_
  end procedure

  module procedure mass
    mass = this%mass_
  end procedure

  module procedure add
    total%time_       = lhs%time_       + rhs%time_
    total%burn_depth_ = lhs%burn_depth_ + rhs%burn_depth_
    total%mass_       = lhs%mass_       + rhs%mass_
    total%energy_     = lhs%energy_    + rhs%energy_
  end procedure

end submodule
