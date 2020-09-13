submodule(oracle_interface) oracle_implementation
  !! define procedures corresponding to the interface bodies in oracle_interface
  implicit none

contains

  module procedure within_tolerance
    class(oracle), allocatable :: error

    error = this - reference
    in_tolerance = (error%norm() <= tolerance)

  end procedure

end submodule oracle_implementation
