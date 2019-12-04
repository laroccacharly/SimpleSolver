
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
    print(model)
    @show value(x1)
    @show value(x2)

    n = 2 
    linked_constrain_index = 1
    #x0 = Float64[0.5, 3/4]
    x0 = Float64[0, 1] #second iteration 
    a1 = Float64[1, 2]
    a2 = Float64[-1, 0]
    a3 = Float64[0, -1]
    as = [a1, a2, a3]
    b = [2, 0, 0]
    f(x) = -4*x[1] -6*x[2] +4*x[1]*x[2]
    f1(x1, x2) = -4*x1 -6*x2 +4*x1*x2
    g = Calculus.gradient(f)
    @show f(x0)
    @show g(x0)
    model = new_model() 
    @variable(model, d[1:n])
    @objective(model, Min, sum(g(x0)' * d))
    @constraint(model, as[1]' * d <= 0)
    @constraint(model, as[2]' * d <= 0)

    @constraint(model, d[1:n] .>= -1)
    @constraint(model, d[1:n] .<= 1)
    JuMP.optimize!(model)
    print(model)
    dk = value.(d)
    @show descent = dot(g(x0), dk)
    @show dk
    ab = nothing 
    for (i, a) in enumerate(as)
        @show v =  dot(a, dk)
        if v > 0 
            @show ab = (b[i] - dot(a, x0))/dot(a, dk)
        end 
    end 
    model = new_nl_model()
    @variable(model, alpha)
    register(model, :f1, 2, f1, autodiff=true)
    @NLobjective(model, Min, f1(x0[1] + alpha * dk[1], x0[2] + alpha * dk[2]))
    @constraint(model, alpha <= ab)
    @constraint(model, alpha >= -2)
    JuMP.optimize!(model)
    print(model)
    @show value(alpha)
    @show x1 = x0 + value(alpha) * dk 
    @show f(x0)
    @show f(x1)
    @show f([0, 2])
    alphas = -2:0.2:10
    f3(a) = -4*(0.5 - a) - 6* (3/4 +a/2) + 4 * (0.5 - a) * (3/4 +a/2)
    
    
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

export d4_q6 
function d4_q6()
    
    @show l = 20/8 # u/h 
    @show u = 1 / 36 * 60/1 # u/h 
    s = 3 
    
    
    @show r = l/(s*u)
    q(n) = ((l/u)^n) * (1/factorial(n))
    # sq = sum
    @show p0 = 1/((sum(q(n) for n in 0:s-1)) + (q(s) * 1/(1-r))) # Summation 
    
    @show Lq = p0 * q(s) * r/((1-r)^2) 
    @show Wq = Lq/l 
    @show p1 = q(1) * p0 
    @show p2 = q(2) * p0 
    @show p3 = q(3) * p0 
    @show 1 - (p0 + p1 + p2 + p3)
    @show log(2)/u
end 
