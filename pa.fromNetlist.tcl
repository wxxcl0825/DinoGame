
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name DinoGame -dir "/home/wxxcl/ISE_workspace/DinoGame/planAhead_run_2" -part xc7k160tffg676-1
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/wxxcl/ISE_workspace/DinoGame/Top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/wxxcl/ISE_workspace/DinoGame} }
set_property target_constrs_file "Sword_Original.ucf" [current_fileset -constrset]
add_files [list {Sword_Original.ucf}] -fileset [get_property constrset [current_run]]
link_design
