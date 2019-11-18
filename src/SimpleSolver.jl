module SimpleSolver
using JuMP, CPLEX, Calculus, LinearAlgebra, Dualization, Ipopt
include("d1.jl")
include("d2.jl")
include("d3.jl")
include("dual.jl")
include("mcf.jl")
end # module
