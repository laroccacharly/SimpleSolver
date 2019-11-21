export meteo
function meteo()
    p = Float64[0.8  0.2; 0.6 0.4]
    for n in 1:5
        @show n 
        @show p^n
    end 
end 