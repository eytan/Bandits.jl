@doc """
A StochasticContext object provides two pieces of information:

* The current trial number
* The number of arms
""" ->
immutable StochasticContext <: Context
    t::Int
    K::Int
end
