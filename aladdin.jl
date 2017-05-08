# aladdin.jl
# File started by Jarvist Moore Frost 2017-01-27
# Codes to read Phono3py HDF5 and play with Phonon scattering terms
# Heavily dependent on:
# Pkg.add("HDF5")

using HDF5

# Documentation:
# https://atztogo.github.io/phono3py/output-files.html#kappa-hdf5-file

# Structural dump: 
# > h5dump -n kappa-2x2x2-m161616.hdf5
# HDF5 "kappa-2x2x2-m161616.hdf5" {
# FILE_CONTENTS {
# group      /
# dataset    /ave_pp
# dataset    /frequency
# dataset    /gamma
# dataset    /group_velocity
# dataset    /heat_capacity
# dataset    /kappa
# dataset    /kappa_unit_conversion
# dataset    /mode_kappa
# dataset    /qpoint
# dataset    /temperature
# dataset    /weight
# }
#}

# This file prepared by Jonathan, is ~4.5G and resident on Cobalt: /share/Jarv-MAPbI3-Kappa/kappa-2x2x2-m161616.hdf5
fid=h5open("kappa-2x2x2-m161616.hdf5","r")

# > ls CsPbI3/
# fc2.hdf5            fc3.hdf5            kappa-m111111.hdf5  pulldown_data.sh
# Simplified cubic CsPbI3; on Titanium
#fid=h5open("./CsPbI3/kappa-m111111.hdf5","r")

gamma_dset=fid["gamma"]
gamma=read(gamma_dset)
show(size(gamma))
# (36,2052,1001)
# So I think that's:
# * Phonon mode (of 36)
# * K-point (16x16x16 mesh -> 4096; ~ divided by two due to k=-k, plus gamma point)
# * ???
# Docu says: The array shape for all grid-points (irreducible q-points) is (temperature, irreducible q-point, phonon band).
# So I guess that 1001 must be the temperature range. Don't know why things are reversed order.
#display(gamma)

qpoint_dset=fid["qpoint"]
qpoint=read(qpoint_dset)
# OK, qpoint[:,N] pulls out a tuple of q-vector locations to match with the below gamma

ave_pp_dset=fid["ave_pp"]
# Average phonon-phonon interaction, units eV^2
ave_pp=read(ave_pp_dset)
# 36×2052 Array{Float64,2}:
# So that's:
# * phonon
# * q-point

const Nphonons=36 #hard code, could alternatively read from the HDF5 file

# Playing with looking over the 'gamma' and 'ave_pp' data
for i in 1:Nphonons
    for q in 1:2052
        @printf("Q-point: %d, k-space: [%f,%f,%f] ",q,qpoint[1,q],qpoint[2,q],qpoint[3,q])
        @printf("\t Gamma (Phonon: %d, qpoint: %d, T=1) = %f \n",i,q,gamma[i,q,1])
        @printf("\tave_pp(Phonon: %d, qpoint: %d) = %g\n",i,q,ave_pp[i,q])
    end
end

# Playing with integrating across the BZ for the average phonon-phonon interaction strength
for i in 1:Nphonons
    sum=0
    for q in 1:2052
#        @printf("Q-point: %d, k-space: [%f,%f,%f] ",q,qpoint[1,q],qpoint[2,q],qpoint[3,q])
        #@printf("\t Gamma (Phonon: %d, qpoint: %d, T=1) = %f \n",i,q,gamma[i,q,1])
        
#        @printf("\tave_pp(Phonon: %d, qpoint: %d) = %g\n",i,q,ave_pp[i,q])
        sum+=ave_pp[i,q]
    end
    sum=sum/2052
    @printf("\t Phonon: %d Average phonon-phonon interaction across BZ: %g\n",i,sum)
end


