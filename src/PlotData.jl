using GLMakie

"""
Here we define some functions for plotting Kaguya Spectral Profiler Data
"""

function plot_rfl(dat::RflData,pointid::Union{Int,Vector{Int}})
    f = Figure()
    ax = Axis(f[1,1])

    for pt in pointid
        lines!(ax,dat.λ,dat.rfl[:,pt])
    end

    display(GLMakie.Screen(),f)
end

function plot_pointmap(rfldat::RflData)
    f = Figure()
    ax1 = Axis(f[1,1])

    for i in eachindex(rfldat.rfl[:,1])
        println(i)
    end

    #display(GLMakie.Screen(),f)
end