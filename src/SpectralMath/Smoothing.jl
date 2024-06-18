using Statistics
"""
Here we define spectral smoothing functions
"""

function movingavg(rfldata::RflData, box_size::Int64)
    """
    input_array: Array of size [nbands,nsamples], contains reflectance data
    input_λvector: Vector of size [nbadnds], contains band wavelength values
    box_size: The number of bands to average from.
    """
    input_array = rfldata.rfl
    input_λvector = rfldata.λ
    
    if box_size%2==0
        throw(DomainError(box_size,"Box Size must be odd!"))
    end

    split_index::Int = (box_size-1)/2
    avg_arr_size = (size(input_array)[1]-(2*split_index),size(input_array)[2])
    avg_arr = Array{Float64}(undef,avg_arr_size)

    for band ∈ 1:size(avg_arr)[1]
        subset_arr = input_array[band:band+(2*split_index),:]
        av_subset = mean(subset_arr,dims=3)
        sd_subset = std(subset_arr,dims=3)
        upperlim_subset = av_subset.+(2*sd_subset)
        lowerlim_subset = av_subset.-(2*sd_subset)

        subset_arr[(subset_arr.<lowerlim_subset).||(subset_arr.>upperlim_subset)].=0.0
        wiseav_missingvals = convert(Array{Union{Float64,Missing}},subset_arr)
        wiseav_missingvals[wiseav_missingvals.==0.0].=missing

        wiseav_denom = size(wiseav_missingvals)[1].-sum(ismissing.(wiseav_missingvals),dims=1)

        avg_arr[band,:] = sum(subset_arr,dims=1)./wiseav_denom
        #println("$(avg_im[20,20,band])...$band")
    end

    avg_λvector = input_λvector[split_index+1:size(input_array)[1]-split_index]

    return avg_arr,avg_λvector
    println("Size of Image: $(size(input_image))")
end