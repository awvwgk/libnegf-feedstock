#!/usr/bin/env bash
set -ex

if [ "${mpi}" != "nompi" ]; then
  MPI=ON
else
  MPI=OFF
fi

if [ "${mpi}" == "openmpi" ]; then
  export OPAL_PREFIX=$PREFIX
  export OMPI_MCA_plm=isolated
  export OMPI_MCA_btl_vader_single_copy_mechanism=none
  export OMPI_MCA_rmaps_base_oversubscribe=yes
fi

cmake_options=(
   "-DBUILD_SHARED_LIBS=ON"
   "-DWITH_MPI=${MPI}"
   "-DBUILD_TESTING=OFF"
)

cmake -B_build -GNinja -DCMAKE_VERBOSE_MAKEFILE=1 ${CMAKE_ARGS} "${cmake_options[@]}"
# cmake --build _build
cd _build
ninja -v
cd ..
cmake --install _build
