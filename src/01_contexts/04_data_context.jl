@doc """
A DataContext object provides three pieces of information:

* The current trial number
* The number of arms
* The contextual data of the pull
""" ->
immutable DataContext <: Context
    t::Float64
    K::Int
    data::Vector{Float64}
	
	function DataContext(t::Float64, K::Int, data=zeros(1)::Vector{Float64})
		return new(t, K, data)
	end
end

