module SimpleSolver
using JuMP, CPLEX, Calculus, LinearAlgebra
export solve_1, s2, s3, fundif, invmat

function solve_1()
    model = Model(with_optimizer(CPLEX.Optimizer)) 

    @variable(model, x1 >= 0)
    @variable(model, x2 >= 0)

    @objective(model, Min, -x1 -2x2)
    @constraint(model, -2x1 + x2 <= 4)
    @constraint(model, x1 -3x2 <= 3)

    optimize!(model)
    print(model)
    @show objective_value(model)
    @show value(model[:x1])
    @show value(model[:x2])

    return model 
end 


function s2()
    model = Model(with_optimizer(CPLEX.Optimizer)) 

    @variable(model, x1 >= 0)
    @variable(model, x2 >= 0)

    @objective(model, Min, 3x1 -6x2)
    @constraint(model, 5x1 +7x2 <= 35)
    @constraint(model, -x1 +2x2 <= 2)

    optimize!(model)
    print(model)
    @show objective_value(model)
    @show value(model[:x1])
    @show value(model[:x2])

    return model 
end 

function s3() 
    model = Model(with_optimizer(CPLEX.Optimizer)) 
    l = 0
    @variable(model, x1 >= 0)
    @variable(model, x2 >= 0)

    @objective(model, Min, -(45 +l)*x1 - (80 +l)*x2)
    @constraint(model, 5x1 + 20x2 <= 400)
    @constraint(model, 10x1 + 15x2 <= 450)

    optimize!(model)
    print(model)
    @show objective_value(model)
    @show value(model[:x1])
    @show value(model[:x2])

    return model 

end 

function fundif()
    differentiate("-(45 +x)/(90+x)", :x)
end 

function invmat()
    mat = [5 20; 10 15]
    inv(mat) 
end 

end # module
