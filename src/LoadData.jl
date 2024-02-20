"""
Here is code for loading in data from .txt files
"""

struct RflData
    λ::Vector{Float64}
    rfl::Matrix{Float64}
end

struct LocData
    pointid::Vector{Float64}
    lat::Vector{Float64}
    long::Vector{Float64}
end


function load_rfl(datpath::String,WVL_MAX::Float64)
    f = open(datpath)
    datastream = readlines(f)
    datastream = [split(i,",") for i in datastream]
    datastream[1] = datastream[1][1:end-1]
    col_lbls = [i[1] for i in datastream]
    floatdata = [parse.(Float64,i[2:end]) for i in datastream]

    data = stack(floatdata)

    data = data[vec(map(!,any(isnan.(data),dims=2))),:]

    data = data[data[:,1].<WVL_MAX,:]

    data = RflData(data[:,1],data[:,2:end])

    return data
end

function load_loc(datpath::String)
    f = open(datpath)
    datastream = readlines(f)
    datastream = [split(i,",") for i in datastream]
    for i in eachindex(datastream)
        datastream[i] = [replace(j," "=>"") for j in datastream[i]]
    end

    col_lbs = datastream[1]
    floatdata = permutedims(stack([parse.(Float64,i) for i in datastream[2:end]]),(2,1))

    return LocData(floatdata[:,3],floatdata[:,1],floatdata[:,2])
end
