# aladdin.jl
# File started by Jarvist Moore Frost 2017-01-27
# Codes to read Phono3py HDF5 and play with Phonon scattering terms
# Heavily dependent on:
# Pkg.add("HDF5")

using HDF5

# This file prepared by Jonathan, is ~4.5G and resident on Cobalt: /share/Jarv-MAPbI3-Kappa/kappa-2x2x2-m161616.hdf5
# MAPI
#fid=h5open("kappa-2x2x2-m161616.hdf5","r")
# > ls CsPbI3/
# fc2.hdf5            fc3.hdf5            kappa-m111111.hdf5  pulldown_data.sh
# Simplified cubic CsPbI3; on Titanium

#fid=h5open("./CsPbI3-m111111.hdf5","r")


for file in ["kappa-2x2x2-m161616.hdf5","CsPbI3-m111111.hdf5"]
    @printf("Opening file: %s\n",file)
    fid=h5open("$file","r")

gamma_dset=fid["gamma"]
gam=read(gamma_dset)
show(size(gam))
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

# Average phonon-phonon interaction, across BZ, units eV^2
#  ave_pp_dset=fid["ave_pp"]
#  ave_pp=read(ave_pp_dset)
# 36×2052 Array{Float64,2}:
# So that's:
# * phonon
# * q-point

const Nphonons=size(gam)[1] #hard code, could alternatively read from the HDF5 file

# Playing with looking over the 'gamma' and 'ave_pp' data
for q in 1:1 #2052 # which BZ points
    for T in 1:1 #:10:100 # by data point, so T=1 = 0K
            @printf("Q-point: %d, k-space: [%f,%f,%f]. T=%d\n",q,qpoint[1,q],qpoint[2,q],qpoint[3,q],T)
        for i in 1:Nphonons
            @printf("\t Mode: %d Gamma(T=%d)= %f (raw) = %f ps\n",i,T,gam[i,q,T],1/(2*2pi*gam[i,q,T]))
#            @printf("\tave_pp(Phonon: %d, qpoint: %d) = %g\n",i,q,ave_pp[i,q])
        end
        @printf("\n")
    end
end

close(fid)
end
