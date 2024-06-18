using LazySets
using Interpolations
"""
Here we define functions and helper functions for removing spectral continuum slopes.
"""

function findλ(wvls::Vector{Float64},targetλ::Real)
    diff_vec = abs.(wvls.-targetλ)
    located_ind = findall(diff_vec.==minimum(diff_vec))
    actualλ = wvls[located_ind]
    return located_ind[1],actualλ[1]
end

function doubleLine_removal(array::Array{<:AbstractFloat,2},λ::Vector{Float64})
    """
    Following method presented in Henderson et al., 2023
    First, a rough continuum is removed using fixed points at 700, 1550 and 2600 nm
    Next, three points are chosen from the maxima of this spectrum at:
     + 650 - 1000 nm
     + 1350 - 1600 nm
     + 2000 - 2600 nm
    Finally, with these endpoints, the final continuum is calculated from the rfl values at these points on the original spectrum
    """
    
    #Getting initial continuum line
    cont1_band_indices = [findλ(λ,i)[1] for i ∈ [700,1550,2600]]
    cont1_wvls = [findλ(λ,i)[2] for i ∈ [700,1550,2600]]
    cont1_bands = array[cont1_band_indices,:]

    function run_linearinterp1(ys::Vector{Float64})
        #Interpolating between convex hull points and applying to desired wavelengths
        lin_interp = linear_interpolation(cont1_wvls,ys,extrapolation_bc=Interpolations.Line())
        return lin_interp.(λ)
    end

    # for i in eachindex(cont1_bands[1,:])
    #     println(typeof(cont1_bands[:,i]))
    # end

    cont1_complete = stack([run_linearinterp1(cont1_bands[:,i]) for i in eachindex(cont1_bands[1,:])])

    # println(size(cont1_complete))

    cont1_rem = array./cont1_complete

    range1 = (650,1000)
    range2 = (1350,1600)
    range3 = (2000,2600)

    cont2_band_indices = Array{Int64}(undef,(3,size(array,2)))
    n = 1
    for (i,j) ∈ [range1,range2,range3]
        min_index = findλ(λ,i)[1]
        max_index = findλ(λ,j)[1]

        # cont2_band_indices[n,:] .= getindex.(argmax(cont1_rem[range(min_index,max_index),:],dims=1),1).+(min_index-1)
        cont2_band_indices[n,:] = getindex.(argmax(cont1_rem[range(min_index,max_index),:],dims=1),1).+(min_index-1)
        n+=1

    end

    cont2_wvls = stack([λ[cont2_band_indices[:,i]] for i in eachindex(cont2_band_indices[1,:])])

    cont2_bands = stack([array[cont2_band_indices[:,i],i] for i in eachindex(cont2_band_indices[1,:])])

    function run_linearinterp2(xs::Vector{Float64},ys::Vector{Float64})
        #Interpolating between convex hull points and applying to desired wavelengths
        # xs = cont2_wvls[pt...]
        # ys = cont2_bands[pt...,:][1]
        lin_interp = linear_interpolation(xs,ys,extrapolation_bc=Interpolations.Line())
        return lin_interp.(λ)
    end

    cont2_complete = stack([run_linearinterp2(cont2_wvls[:,i],cont2_bands[:,i]) for i in eachindex(cont2_wvls[1,:])])

    # cont2_complete = permutedims([cont2_complete[I][k] for k=eachindex(cont2_complete[1,1]),I=CartesianIndices(cont2_complete)],(2,3,1))

    cont2_rem = array./cont2_complete

    return cont2_rem
    
    # return cont1_band_indices,cont1_rem,cont1_complete,cont2_band_indices,cont2_wvls,cont2_complete,cont2_rem

end