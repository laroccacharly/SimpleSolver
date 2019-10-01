module SimpleSolver
using JuMP, CPLEX, Calculus, LinearAlgebra
export solve_1, s2, s3, fundif, invmat, q6, q2


function q2() 
    model = Model(with_optimizer(CPLEX.Optimizer)) 

    @variable(model, x >= 0)
    @variable(model, y >= 0)

    @objective(model, Max,  100x + 60y)
    @constraint(model, 20x + 40y <= 400)
    @constraint(model, 5x +2y <= 40)
    @constraint(model, x<=6)
    @constraint(model, y<=9)


    optimize!(model)
    print(model)
    @show objective_value(model)
    @show value(model[:x])
    @show value(model[:y])

    return model 
end 


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

function q6()
    model = Model(with_optimizer(CPLEX.Optimizer)) 
    @variable(model, x1 >= 0)
    @variable(model, x2 >= 0)
    @variable(model, x3 >= 0)
    @variable(model, x4 >= 0)
    @variable(model, x5 >= 0)
    @variable(model, x6 >= 0)


    @objective(model, Min, -8x1 -9x2 -7x3 -6x4 -8x5 -9x6)
    @constraint(model, x1 + x3 + x5 == 4)
    @constraint(model, x2 + x4 + x6 ==2)
    @constraint(model, x1 + x4 == 2)
    @constraint(model, x2 + x5 == 1)

    optimize!(model)
    print(model)

    @show objective_value(model)
    @show value(model[:x1])
    @show value(model[:x2])
    @show value(model[:x3])
    @show value(model[:x4])
    @show value(model[:x5])
    @show value(model[:x6])


    Bi = [0 0 1 0; 0 0 0 1; 1 0 -1 0; 0 1 0 -1]
    A = [1 0 1 0 1 0; 0 1 0 1 0 1; 1 0 0 1 0 0; 0 1 0 0 1 0]
    cb = [-8 -9 -7 -9]
    c = [-8 -9 -7 -6 -8 -9]
    b = transpose([4 2 2 1])
    pt = cb * Bi 
    @show pt 
    An = Bi * A 
    @show An 
    zn = pt*b
    @show zn    
    cn = c - pt * A
    @show cn 
    bn = Bi * b 
    @show bn 
    @show db = transpose([1 1 -1 -1])
    xb = [1,5,3,6]
    @show Bopt = A[:, xb]
    @show Bopti = inv(Bopt)
    @show Bopti * b 
    @show  Bopti * db 

    @show bopt = Bopti * b + Bopti * db 


    cb2 = c[1, xb]
    @show cb2 
    @show size(cb2)
    @show ptopt = transpose(cb2) * Bopti
    @show zopt = ptopt * (b + db)
end 

end # module
