struct DataQueue{C <: Context}
    c::Vector{C}
    a::Vector{Int}
    r::Vector{Float64}
end

function store!(queue::DataQueue, c::Context, a::Integer, r::Real)
    push!(queue.c, c)
    push!(queue.a, a)
    push!(queue.r, r)
    return
end

function clear!(queue::DataQueue)
    empty!(queue.c)
    empty!(queue.a)
    empty!(queue.r)
    return
end
