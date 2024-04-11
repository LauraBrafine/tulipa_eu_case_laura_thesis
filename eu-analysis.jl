using TulipaEnergyModel
using Gurobi 

input_dir = joinpath(@__DIR__, "NWEU_4h/NWEU_4h_pint") # download EU file github
output_dir = joinpath(@__DIR__, "NWEU_4h/output_NWEU_4h_pint")
energy_problem = run_scenario(input_dir)
#energy_problem = create_energy_problem(input_dir, optimizer = Gurobi)
#energy_problem = create_energy_problem_from_csv_folder(input_dir)

save_solution_to_file(output_dir, energy_problem)

# Print objective value --> maybe write to csv good idea as well as
# solve time
energy_problem.objective_value
#energy_problem.time_solve_model


#graph = energy_problem.graph   # e.g. if you want to extarct flows, to use graph function add meta graph next package

# Look at tulipa tutorial 
# Note: in julia functions can have same name --> depending on arguments it works differently

# To help find infeasibilities :

    #using JuMP
    #compute_conflict!(energy_problem.model)
    
    #if get_attribute(energy_problem.model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
    #    iis_model, reference_map = copy_conflict(energy_problem.model)
    #    print(iis_model)
    #end

# To plot some results, energy_problem.dataframe

#using Plots, DataFrames, StatsPlots
#plotly()
#df_storage_level = energy_problem.dataframes[:lowest_storage_level_intra_rp]
    
#unit_ranges = df_storage_level[!, :time_block]
#end_values = [range[end] for range in unit_ranges]
#df_storage_level[!, :time] = end_values
    
#@df df_storage_level plot(
#    :time,
#    :solution,
#    group = (:asset, :rp),
#    legend = :topleft,
#    layout = 2,
#    legend_font_pointsize = 6,
#    size = (800, 600),
#)
