"""
A MinimalContext object provides one piece of information:

* The current trial number
"""
struct MinimalContext <: Context
    t::Int
end
