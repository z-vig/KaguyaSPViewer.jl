using KaguyaSPViewer
using HDF5

rfl = load_rfl("C:/Users/zvig/.julia/dev/KaguyaSPViewer.jl/Data/SpectralProfile_RFL.txt",2200.)

loc = load_loc("C:/Users/zvig/.julia/dev/KaguyaSPViewer.jl/Data/SpectralProfile_LATLONG.txt")

plot_rfl(rfl,[1,2,3])
# h5file = h5open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/gamma_maps_target.hdf5")
# baseimage = h5file["VectorDatasets/SmoothSpectra"][:,:,end]

plot_pointmap(rfl)