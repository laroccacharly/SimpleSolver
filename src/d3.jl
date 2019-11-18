new_nl_model() = Model(with_optimizer(Ipopt.Optimizer))
export d3_q6
function d3_q6() 
    model = new_nl_model() 
    @variable(model, x1, start = 0.0)
    @variable(model, x2, start = 0.0)

    @NLobjective(model, Min, x1^4 +x2^4 +12x1^2 +6x2^2 - x1*x2 -x1 -x2)
    @constraint(model, x1 + x2 >= 6)
    @constraint(model, 2x1 - x2 >= 3)
    @constraint(model, x1 >= 0)
    @constraint(model, x2 >= 0)

    JuMP.optimize!(model)
    @show value(x1)
    @show value(x2)
    x1 = 3
    x2 = 3 
    model = new_model() 
    @variable(model, l1 >=0)
    @variable(model, l2 >=0)
    @objective(model, Min, 3)
    @constraint(model, 4 * x1 ^3 + 24 * x1 - x2 - 1 -l1 - 2l2 ==0)
    @constraint(model, 4 * x2 ^3 + 12 * x1 - x1 - 1 -l1 + l2 ==0)

    JuMP.optimize!(model)
    @show value(l1)
    @show value(l2)

    return nothing 
end 

export d3_q5

function d3_q5() 


    model = new_nl_model() 
    @variable(model, x1, start = 3.0)
    @variable(model, x2, start = 3.0)
    @NLobjective(model, Min, 36x1 + 36x2 + 5x1^2 + 8*x1*x2 + 5x2^2)
    JuMP.optimize!(model)
    @show value(x1)
    @show value(x2)

    h =hessian(x -> 36*x[1] + 36*x[2] + 5*x[1]^2 + 8*x[1]*x[2] + 5*x[2]^2, [0.0, 0.0])
    @show hinv = inv([10//1 8//1; 8//1 10//1])
    @show d = hinv * [90;90]
    return nothing 
end 