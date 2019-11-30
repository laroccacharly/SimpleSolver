
function iter(p, nmax)
    for n in 1:nmax 
        @show n 
        display(p^n) 
    end 
end 

export d4_q1
function d4_q1() 
    model = new_nl_model() 
    @variable(model, x1, start = 0.5)
    @variable(model, x2, start =3/4)

    @NLobjective(model, Min, -4x1 -6x2 +4*x1*x2)
    @constraint(model, x1 + 2x2 <= 2)
    @constraint(model, x1 >= 0)
    @constraint(model, x2 >= 0)

    JuMP.optimize!(model)
    @show value(x1)
    @show value(x2)

end 

export d4_q2
function d4_q2() 
    p = [0 4/5 0 1/5 0; 
        1/4 0 0.5 0.25 0; 
        0 0.5 0 0.1 2/5;
        0 0 0 1 0; 
        1/3 0 1/3 1/3 0
        ]
    iter(p, 100) 

end 

export d4_q3
function d4_q3()
    p = Float64[0 0.5 0 0.5; 1/3 0 1/3 1/3; 0 1 0 0; 0.5 0.5 0 0]
    iter(p, 20) 

end     

export d4_q4 
function d4_q4() 
    a = 0.1 
    b = 0.5 
    c = 1 - a - b
    p = [
        1 0 0; 
        0 1 0; 
        a b c
    ]
    
    iter(p, 20)
    @show a /(1-c)
    @show b /(1-c)
end 