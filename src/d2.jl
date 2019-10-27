export a1 
new_model() = Model(with_optimizer(CPLEX.Optimizer)) 
function a1() 
    model = new_model() 
    ids = 1:6
    @variable(model, x[ids] >= 0)
    costs = [3, 1, 1, 0, 0, 0]

    @objective(model, Min,  sum(costs' * x))
    @constraint(model, -x[1] - 2x[2] + x[4] == -8)
    @constraint(model, -3x[1] + 2x[2] + x[3] + x[5] == -6)
    @constraint(model, x[1] + x[2] - 4x[3] + x[6] == -2)

    optimize!(model)
    print(model)
    @show objective_value(model)
    @show value.(model[:x]).data

    A = [-1 -2 0 1 0 0; -3 2 1 0 1 0; 1 1 -4 0 0 1]
    b = [-8 -6 -2] |> vec 
    c = [3, 1, 1, 0, 0, 0]
    z = 0 
    lp = LinearProgram(A, b, c, z)
    lp = pivot(lp, 2, 1) |> print_lp
    lp = pivot(lp, 1, 2) |> print_lp
    lp = pivot(lp, 3, 3) |> print_lp

    return nothing
end 

export a6 
function a6() 
    function base_model(;relaxed=true ) 
        model = new_model() 
        if relaxed 
            @variable(model, x1 >= 0)
            @variable(model, x2 >= 0)
        else 
            @variable(model, x1 >= 0, Int)
            @variable(model, x2 >= 0, Int)
        end 

        @objective(model, Min,  -x1 -2x2)
        @constraint(model, 2x1 + x2 <= 5.5)
        @constraint(model, x2 <= 2)
        return model 
    end 

    function opt_and_print(model)
        optimize!(model)
        print(model)
        @show objective_value(model)
        @show termination_status(model)
        @show value.(model[:x1])
        @show value.(model[:x2])
    end 
    #model_int = base_model(relaxed=false)
    #opt_and_print(model_int)
    
    model = base_model() 
    opt_and_print(model)
    
    #= 
    @constraint(model, model[:x1] >= 2)
    opt_and_print(model)
    # @constraint(model, model[:x2] >= 2) # Inf 
    @constraint(model, model[:x2] <= 1)
    opt_and_print(model)
    # @constraint(model, model[:x1] >= 3) # Inf 
    @constraint(model, model[:x1] <= 2)
    opt_and_print(model)
    =# 

    @constraint(model, model[:x1] <= 1)
    opt_and_print(model)

    return nothing 
end 

struct LinearProgram
    A::Array{Number, 2}
    b::Array{Number, 1}
    c::Array{Number, 1}
    z::Number
end 
function print_lp(lp::LinearProgram)
    println("A = ")
    display(lp.A)
    @show lp.b
    @show lp.c
    @show lp.z
    return lp 
end 

function pivot(LP::LinearProgram, entry::Int, exit::Int)::LinearProgram
    A, b, c, z = LP.A, LP.b, LP.c, LP.z 
    # Step 1: Update the exit row to have a 1 at the entry point 
    v = A[exit, entry]
    A[exit, :] = A[exit, :] .//v 
    b[exit] = b[exit] //v
    @assert A[exit, entry] == 1 
    # Step 2: Update the entry col to have 0 everywhere but at the exit row 
    for row_index in 1:size(A, 1)
        if row_index == exit 
            # Don't need to update the exit row. 
            continue 
        end 
        m = A[row_index, entry]
        A[row_index, :] = A[row_index, :] .- (A[exit, :] * m) 
        @assert A[row_index, entry] == 0 
        b[row_index] = b[row_index] - b[exit] * m 
    end 
    # Step 3: Update the cost to have 0 at the entry point 
    n = c[entry]
    c = c - (A[exit, :] * n) 
    @assert c[entry] == 0 
    # Step 4: Update the objective 
    z = z - b[exit] * n 
    return LinearProgram(A, b, c, z)
end 