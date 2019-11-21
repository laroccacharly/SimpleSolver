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


function fibo_optim(f, n::Int, a::Number, b::Number)
    @info "Fib optimization"
    fib_numbers = [1, 1, 2, 3, 5, 8, 13, 21, 34]
    fn(n) = fib_numbers[n + 1]
    x_left(bk, ak, n, k) = round(bk - (fn(n - k)/fn(n - k +1)) * (bk - ak); digits=2)
    x_right(bk, ak, n, k) = round(ak + (fn(n - k)/fn(n - k +1)) * (bk - ak); digits=2)
    
    k = 1 
    ak = a 
    bk = b 
    while k <= n 
        @show k 
        @show fn(n - k)
        @show fn(n - k +1)
        @show fn(n - k)/fn(n - k +1)
        @show xk_left = x_left(bk, ak, n, k)
        @show xk_right = x_right(bk, ak, n, k)
        @show f(xk_left)
        @show f(xk_right)

        if f(xk_left) < f(xk_right)
            println("moving the b")
            bk = xk_right
        elseif f(xk_left) > f(xk_right)
            println("moving the a")
            ak = xk_left 
        else 
            println("Same f for left and right")
            return xk_left 
        end 
        @show ak 
        @show bk 
        @show k += 1 
    end 
end 

function gold_optim(f, a::Number, b::Number, epsilon::Number)
    @info "Gold optimization"
    gold_number = 1.618 
    x_left(bk, ak) = round(bk - (1/gold_number) * (bk - ak); digits=2)
    x_right(bk, ak) = round(ak + (1/gold_number) * (bk - ak); digits=2)
    k = 1 
    ak = a 
    bk = b 
    d = Inf 
    while d > epsilon
        @show k 
        @show d 
        @show xk_left = x_left(bk, ak)
        @show xk_right = x_right(bk, ak)
        @show f(xk_left)
        @show f(xk_right)

        if f(xk_left) < f(xk_right)
            println("moving the b")
            bk = xk_right
        elseif f(xk_left) > f(xk_right)
            println("moving the a")
            ak = xk_left 
        else 
            println("Same f for left and right")
            return xk_left 
        end 
        @show ak 
        @show bk 
        d = bk - ak 
        k += 1 
    end 
    @show d 
    return nothing 
end 

export d3_q1
f(x) = round(x * (x -5 *pi); digits=2) 
function d3_q1() 
    pi = 3.1416
    a = 0 
    b = 20
    n = 7 
    epsilon = 2
    fibo_optim(f, n, a, b)
    gold_optim(f, a, b, epsilon)

end 