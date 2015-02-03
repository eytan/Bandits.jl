@doc """
A MinimalContext object provides one piece of information:

* The current trial number
""" ->
immutable MinimalContext <: Context
    t::Int
end
