# aladdin.jl
# File started by Jarvist Moore Frost 2017-01-27
# Codes to read Phono3py HDF5 and play with Phonon scattering terms
# Heavily dependent on:
# Pkg.add("HDF5")

using HDF5

# Documentation:
# https://atztogo.github.io/phono3py/output-files.html#kappa-hdf5-file

# This file prepared by Jonathan, is ~4.5G and resident on Cobalt: /share/Jarv-MAPbI3-Kappa/kappa-2x2x2-m161616.hdf5
fid=h5open("kappa-2x2x2-m161616.hdf5","r")
gamma_dset=fid["gamma"]

gamma=read(gamma_dset)

display(gamma)
