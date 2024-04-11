using TulipaEnergyModel
using Gurobi 
using DataFrames
using CSV
using Dates

# Assuming you have a predefined list of model names and their corresponding input directories
models = Dict(
    "NWEU_1h" => "NWEU_Zhi",
    #"NWEU_2h_first" => "NWEU_2h/NWEU_2h_first",
    #"NWEU_2h_last" => "NWEU_2h/NWEU_2h_last",
    #"NWEU_2h_max" => "NWEU_2h/NWEU_2h_max",
    #"NWEU_2h_min" => "NWEU_2h/NWEU_2h_min",
    #"NWEU_2h_mean" => "NWEU_2h/NWEU_2h_mean",
    #"NWEU_2h_median" => "NWEU_2h/NWEU_2h_median",
    #"NWEU_2h_mid" => "NWEU_2h/NWEU_2h_mid",
    #"NWEU_3h_first" => "NWEU_3h/NWEU_3h_first",
    #"NWEU_3h_last" => "NWEU_3h/NWEU_3h_last",
    #"NWEU_3h_max" => "NWEU_3h/NWEU_3h_max",
    #"NWEU_3h_min" => "NWEU_3h/NWEU_3h_min",
    #"NWEU_3h_mean" => "NWEU_3h/NWEU_3h_mean",
    #"NWEU_3h_median" => "NWEU_3h/NWEU_3h_median",
    #"NWEU_3h_mid" => "NWEU_3h/NWEU_3h_mid",
    #"NWEU_4h_first" => "NWEU_4h/NWEU_4h_first",
    #"NWEU_4h_last" => "NWEU_4h/NWEU_4h_last",
    #"NWEU_4h_max" => "NWEU_4h/NWEU_4h_max",
    #"NWEU_4h_min" => "NWEU_4h/NWEU_4h_min",
    #"NWEU_4h_mean" => "NWEU_4h/NWEU_4h_mean",
    #"NWEU_4h_median" => "NWEU_4h/NWEU_4h_median",
    #"NWEU_4h_mid" => "NWEU_4h/NWEU_4h_mid",
    # Add more models as needed
)

df = DataFrame(ModelName = String[], ObjectiveValue = Float64[], SolveTimes = Array{Float64,1}[])

for (model_name, input_dir) in models
    input_path = joinpath(@__DIR__, input_dir)
    
    # Since objective value is assumed to be constant, it's taken from the first run
    obj_value = 0.0
    solve_times = Float64[]

    for _ in 1:10 # change to number of time syou want the scenario to be run 
        energy_problem = run_scenario(input_path)
        
        if obj_value == 0.0  # Assuming objective value is fetched only once
            obj_value = energy_problem.objective_value
        end
        
        push!(solve_times, energy_problem.time_solve_model)
    end
    
    push!(df, (model_name, obj_value, solve_times))
end

csv_file_name = "model_results_1h_obj_solve_" * Dates.format(now(), "YYYYmmdd_HHMMSS") * ".csv"
CSV.write(csv_file_name, df)

println("Results exported to $csv_file_name")


