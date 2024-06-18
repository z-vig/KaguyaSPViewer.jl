module KaguyaSPViewer

export load_rfl,
       load_loc,
       plot_rfl,
       plot_pointmap,
       movingavg,
       findλ,
       doubleLine_removal

export RflData,
       LocData

include("LoadData.jl")

include("PlotData.jl")

include("SpectralMath/Smoothing.jl")

include("SpectralMath/ContinuumRemoval.jl")

end
