module SimpleSolver
using JuMP, CPLEX, Calculus, LinearAlgebra
include("d1.jl")
include("d2.jl")

include("dual.jl")
include("mcf.jl")
end # module
