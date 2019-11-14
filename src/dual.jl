export dual_test

function dual_test() 
    model = Model()
    @variable(model, x1)
    @variable(model, x2)

    @objective(model, Min, 2x1 + 3x2)


    @constraint(model, eq1, 2x1 + 3x2 == 6 )
    @constraint(model, eq2, 4x1 + 5x2 == 7 )
    
    @constraint(model, u1, x1 <= 10 )
    @constraint(model, l1, x1 >= 1 )
    @constraint(model, u2, x2 <= 7 )
    @constraint(model, l2, x2  >= 2 )
    
    print(model)
    dual_model = dualize(model)
    print(dual_model)
    return dual_model 
end 

export dual_test2
function dual_test2()

    model = Model()
    @variable(model, x)
    @variable(model, y)
    @variable(model, z)
    @constraint(model, soccon, [x; y; z] in SecondOrderCone())
    @constraint(model, eqcon, x == 1)
    @objective(model, Min, y + z)
    dual_model = dualize(model)
    print(dual_model)
    return dual_model 
end 
export dual_test3 
function dual_test3() 
    model = Model()
    @variable(model, x1)
    @variable(model, x2)

    @objective(model, Max, 8x1 + 6x2)


    @constraint(model, eq1, 5x1 + 3x2 <= 30 )
    @constraint(model, eq2, 2x1 + 3x2 <= 24 )
    @constraint(model, eq3, x1 + 3x2 <= 18 )
    print(model)
    dual_model = dualize(model)
    print(dual_model)
    return dual_model 
end 