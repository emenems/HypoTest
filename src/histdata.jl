"""
	prepdata(x)
Remove NaNs. Will return reduced vector if any NaN in input data
"""
function prepdata(x::Vector{Float64})::Vector{Float64}
	return any(isnan.(x)) ? filter(!isnan,x) : copy(x)
end
