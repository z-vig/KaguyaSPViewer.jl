using KaguyaSPViewer
using HDF5
using CairoMakie
using Statistics

rfl = load_rfl("C:/Users/zvig/.julia/dev/KaguyaSPViewer.jl/Data/SpectralProfile_RFL.txt",1600.)

loc = load_loc("C:/Users/zvig/.julia/dev/KaguyaSPViewer.jl/Data/SpectralProfile_LATLONG.txt")

# plot_rfl(rfl,[1,2,3])

smooth_arr,smooth_λ = movingavg(rfl,9)

cont2_rem = doubleLine_removal(smooth_arr,smooth_λ)

olspec1,olspec2,olspec3 = open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/SavedGUIData/all_olivine.txt") do f
    return [parse.(Float64,i) for i in split.(readlines(f),",")][1:3]
end

m3spec_glob1 = open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/SavedGUIData/global1_ol.txt") do f
    return [parse.(Float64,i) for i in split.(readlines(f),",")][1]
end

m3spec_glob2 = open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/SavedGUIData/global2_ol.txt") do f
    return [parse.(Float64,i) for i in split.(readlines(f),",")][1]
end

m3λ = h5open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/targeted.hdf5") do f
    return read_attribute(f,"smooth_wavelengths")./1000
end

m3λ_globe = h5open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/global1.hdf5") do f
    return read_attribute(f,"smooth_wavelengths")./1000
end


# println("Done")

f = Figure(backgroundcolor=:transparent)
ax1 = Axis(
    f[1,1],
    xticks = 1:0.5:3,
    xminorticksvisible = true,
    xminorticks = IntervalsBetween(5),
    xminorticksize= 4,
    xticksize = 6,
    xgridvisible=true,
    backgroundcolor = :transparent,
    xticklabelsize=20,xticklabelfont="Verdana",
    yticklabelsize=20,yticklabelfont="Verdana",
    limits = (minimum(m3λ),maximum(m3λ),0.85,1.05)
    )
#ax2 = Axis(f[1,2])
#lines!(ax,smooth_λ,smooth_arr[:,1])
# for i in range(2,6) #range(size(cont2_rem,2)-8,size(cont2_rem,2))
#     #lines!(ax1,smooth_λ,smooth_arr[:,i],color=i,colormap=:viridis,colorrange=(1,49),label="$i")
#     #lines!(ax2,smooth_λ,cont2_rem[:,i],color=i,colormap=:viridis,colorrange=(1,49))
# end

println(size(mean(cont2_rem,dims=2)))
lines!(ax1,smooth_λ./1000,mean(cont2_rem,dims=2)[:,1],color=:red)
lines!(ax1,m3λ,m3spec,color=:green)
lines!(ax1,m3λ_globe,m3spec_glob1,color=:blue)
lines!(ax1,m3λ_globe,m3spec_glob2,color=:purple)

# CairoMakie.save("G:/Shared drives/Zach Lunar-VISE/Research Presentations/LPSC24/Compare_Datasets.svg",f,size=(600,500))

f
# #axislegend(ax1)
# display(GLMakie.Screen(),f)
#GLMakie.save("examples/KagSP_shortwvls.png",f)
# h5file = h5open("C:/Users/zvig/.julia/dev/JENVI.jl/Data/gamma_maps_target.hdf5")
# baseimage = h5file["VectorDatasets/SmoothSpectra"][:,:,end]

#plot_pointmap(rfl)