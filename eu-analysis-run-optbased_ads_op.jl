using TulipaEnergyModel
using Gurobi 
using DataFrames
using CSV
using Dates

models = Dict(
    "NWEU_1h" => Dict(
        "input" => "NWEU_Zhi",
        "output" => "output_NWEU_Zhi_new"
    ),
    "NWEU_2h_mean" => Dict(
        "input" => "NWEU_2h/NWEU_2h_mean",
        "output" => "NWEU_2h/output_NWEU_2h_mean"
    ),
    "NWEU_3h_mean" => Dict(
        "input" => "NWEU_3h/NWEU_3h_mean",
        "output" => "NWEU_3h/output_NWEU_3h_mean"
    ),
    "NWEU_4h_mean" => Dict(
        "input" => "NWEU_4h/NWEU_4h_mean",
        "output" => "NWEU_4h/output_NWEU_4h_mean"
    ),
    "NWEU_op_ads_1over2_th" => Dict(
        "input" => "advanced_ds/ads_op_1over2_theta",
        "output" => "advanced_ds/output/output_ads_op_1over2_theta"
    ),
    "NWEU_op_ads_1over2_th_max" => Dict(
        "input" => "advanced_ds/ads_op_1over2_theta_max",
        "output" => "advanced_ds/output/output_ads_op_1over2_theta_max"
    ),
    "NWEU_op_ads_1over2_th_min" => Dict(
        "input" => "advanced_ds/ads_op_1over2_theta_min",
        "output" => "advanced_ds/output/output_ads_op_1over2_theta_min"
    ),
    "NWEU_op_ads_1over3_th_maxmin" => Dict(
        "input" => "advanced_ds/ads_op_1over3_theta_maxmin",
        "output" => "advanced_ds/output/output_ads_op_1over3_theta_maxmin"
    ),
    "NWEU_op_ads_1over3_th" => Dict(
        "input" => "advanced_ds/ads_op_1over3_theta",
        "output" => "advanced_ds/output/output_ads_op_1over3_theta"
    ),
    "NWEU_op_ads_1over3_th_max" => Dict(
        "input" => "advanced_ds/ads_op_1over3_theta_max",
        "output" => "advanced_ds/output/output_ads_op_1over3_theta_max"
    ),
    "NWEU_op_ads_1over3_th_min" => Dict(
        "input" => "advanced_ds/ads_op_1over3_theta_min",
        "output" => "advanced_ds/output/output_ads_op_1over3_theta_min"
    ),
    "NWEU_op_ads_1over3_th_maxmin" => Dict(
        "input" => "advanced_ds/ads_op_1over3_theta_maxmin",
        "output" => "advanced_ds/output/output_ads_op_1over3_theta_maxmin"
    ),
    "NWEU_op_ads_1over4_th_maxmin" => Dict(
        "input" => "advanced_ds/ads_op_1over4_theta_maxmin",
        "output" => "advanced_ds/output/output_ads_op_1over4_theta_maxmin"
    ),
    "NWEU_op_ads_1over4_th" => Dict(
        "input" => "advanced_ds/ads_op_1over4_theta",
        "output" => "advanced_ds/output/output_ads_op_1over4_theta"
    ),
    "NWEU_op_ads_1over4_th_max" => Dict(
        "input" => "advanced_ds/ads_op_1over4_theta_max",
        "output" => "advanced_ds/output/output_ads_op_1over4_theta_max"
    ),
    "NWEU_op_ads_1over4_th_min" => Dict(
        "input" => "advanced_ds/ads_op_1over4_theta_min",
        "output" => "advanced_ds/output/output_ads_op_1over4_theta_min"
    ),
    "NWEU_op_ads_1over4_th_maxmin" => Dict(
        "input" => "advanced_ds/ads_op_1over4_theta_maxmin",
        "output" => "advanced_ds/output/output_ads_op_1over4_theta_maxmin"
    ),
    "NWEU_op_LP_diff_2h" => Dict(
        "input" => "advanced_ds/LP_op_diff_2h",
        "output" => "advanced_ds/output/output_LP_op_diff_2h"
    ),
    "NWEU_op_LP_diff_area_2h" => Dict(
        "input" => "advanced_ds/LP_op_diff_area_2h",
        "output" => "advanced_ds/output/output_LP_op_diff_area_2h"
    ),
    "NWEU_op_LP_diff_3h" => Dict(
        "input" => "advanced_ds/LP_op_diff_3h",
        "output" => "advanced_ds/output/output_LP_op_diff_3h"
    ),
    "NWEU_op_LP_diff_area_3h" => Dict(
        "input" => "advanced_ds/LP_op_diff_area_3h",
        "output" => "advanced_ds/output/output_LP_op_diff_area_3h"
    ),
    "NWEU_op_LP_diff_4h" => Dict(
        "input" => "advanced_ds/LP_op_diff_4h",
        "output" => "advanced_ds/output/output_LP_op_diff_4h"
    ),
    "NWEU_op_LP_diff_area_4h" => Dict(
        "input" => "advanced_ds/LP_op_diff_area_4h",
        "output" => "advanced_ds/output/output_LP_op_diff_area_4h"
    ),
    "NWEU_op_scipy_COBYLA_2h" => Dict(
        "input" => "advanced_ds/scipy_op_COBYLA_2h",
        "output" => "advanced_ds/output/output_scipy_op_COBYLA_2h"
    ),
    "NWEU_op_scipy_COBYLA_3h" => Dict(
        "input" => "advanced_ds/scipy_op_COBYLA_3h",
        "output" => "advanced_ds/output/output_scipy_op_COBYLA_3h"
    ),
    "NWEU_op_scipy_COBYLA_4h" => Dict(
        "input" => "advanced_ds/scipy_op_COBYLA_4h",
        "output" => "advanced_ds/output/output_scipy_op_COBYLA_4h"
    ),
    "NWEU_op_scipy_Powell_2h" => Dict(
        "input" => "advanced_ds/scipy_op_Powell_2h",
        "output" => "advanced_ds/output/output_scipy_op_Powell_2h"
    ),
    "NWEU_op_scipy_Powell_3h" => Dict(
        "input" => "advanced_ds/scipy_op_Powell_3h",
        "output" => "advanced_ds/output/output_scipy_op_Powell_3h"
    ),
    "NWEU_op_scipy_Powell_4h" => Dict(
        "input" => "advanced_ds/scipy_op_Powell_4h",
        "output" => "advanced_ds/output/output_scipy_op_Powell_4h"
    ),
    "NWEU_op_MILP_flexres_2h" => Dict(
        "input" => "advanced_ds/MILP_flexres_op_2h",
        "output" => "advanced_ds/output/output_MILP_flexres_op_2h"
    ),
    "NWEU_op_MILP_flexres_3h" => Dict(
        "input" => "advanced_ds/MILP_flexres_op_3h",
        "output" => "advanced_ds/output/output_MILP_flexres_op_3h"
    ),
    "NWEU_op_MILP_flexres_4h" => Dict(
        "input" => "advanced_ds/MILP_flexres_op_4h",
        "output" => "advanced_ds/output/output_MILP_flexres_op_4h"
    ),
)

df = DataFrame(ModelName = String[], ObjectiveValue = Float64[], SolveTimes = Array{Float64,1}[])

for (model_name, paths) in models
    input_path = joinpath(@__DIR__, paths["input"])
    output_path = joinpath(@__DIR__, paths["output"])
    # Since objective value is assumed to be constant, it's taken from the first run
    obj_value = 0.0
    solve_times = Float64[]

    for _ in 1:1 # change to number of time syou want the scenario to be run 
        energy_problem = run_scenario(input_path)
        save_solution_to_file(output_path, energy_problem)

        if obj_value == 0.0  # Assuming objective value is fetched only once
            obj_value = energy_problem.objective_value
        end
        
        push!(solve_times, energy_problem.time_solve_model)
    end
    
    push!(df, (model_name, obj_value, solve_times))
end

csv_file_name = "model_results_optbased_op_18062024" * ".csv"
CSV.write(csv_file_name, df)

println("Results exported to $csv_file_name")


