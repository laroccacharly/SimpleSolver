# Importing packages
using JuMP, CPLEX, DelimitedFiles
export mcf 

function mcf() 
    # Data Preparation
    network_data_file = "simple_network.csv"
    network_data = readdlm(network_data_file, ',', header=true)
    data = network_data[1]
    header = network_data[2]

    start_node = round.(Int64, data[:,1])
    end_node = round.(Int64, data[:,2])
    c = data[:,3]
    u = data[:,4]

    network_data2_file = "simple_network_b.csv"
    network_data2 = readdlm(network_data2_file, ',', header=true)
    data2 = network_data2[1]
    hearder2 = network_data2[2]

    b = data2[:,2]

    # number of nodes and number of links
    no_node = max( maximum(start_node), maximum(end_node) )
    no_link = length(start_node)

    # Creating a graph
    nodes = 1:no_node
    links = Tuple( (start_node[i], end_node[i]) for i in 1:no_link )
    c_dict = Dict(links .=> c)
    u_dict = Dict(links .=> u)


    ### Finding entry and exit variables for given base and hb 
    #= 
    base = [
        (1,2),
        (2,4),
        (2,5),
        (3,4),
        (5,6)    
    ]

    hb = [
        (1,3),
        (2,3),
        (3,5),
        (4,6),
        (5,4)
    ]
    =#
    base = [
        (1,2),
        (2,4),
        (3,4),
        (5,6),
        (3,5)    
    ]

    hb = [
        (2,5),
        (1,3),
        (2,3),
        (4,6),
        (5,4)
    ]

    m = Model(with_optimizer(CPLEX.Optimizer))
    
    @variable(m, x[1:6])
    @objective(m, Min, 3)
    @constraint(m, x[1] == 0)
    for link in base
        @constraint(m, c_dict[link] - x[link[1]] + x[link[2]] == 0)
    end
    print(m)
    JuMP.optimize!(m)
    @info "Solution to Pi's "
    pi = JuMP.value.(x) 
    @show pi 
    @info "Reduced costs for hb"
    for link in hb 
        @show link 
        # println("c_dict[link] $(c_dict[link]), pi[link[1]] $(pi[link[1]]), pi[link[2]] $(pi[link[2]])")
        reduced_cost = c_dict[link] - pi[link[1]] + pi[link[2]]
        @show reduced_cost
    end 

    # Preparing an optimization model
    mcnf = Model(with_optimizer(CPLEX.Optimizer)) 

    # Defining decision variables
    @variable(mcnf, 0<= x[link in links] <= u_dict[link])

    # Setting the objective
    @objective(mcnf, Min, sum( c_dict[link] * x[link] for link in links)  )

    # Adding the flow conservation constraints
    for i in nodes
    @constraint(mcnf, sum(x[(ii,j)] for (ii,j) in links if ii==i )
                    - sum(x[(j,ii)] for (j,ii) in links if ii==i ) == b[i])
    end

    print(mcnf)
    JuMP.optimize!(mcnf)
    obj = JuMP.objective_value(mcnf)
    x_star = JuMP.value.(x)
    println("The optimal objective function value is = $obj")
    println(x_star.data)
    @show links 
    x_star
end 