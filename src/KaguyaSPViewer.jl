module KaguyaSPViewer

export load_rfl,
       load_loc,
       plot_rfl,
       plot_pointmap

export RflData,
       LocData

include("LoadData.jl")

include("PlotData.jl")

end
