
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name COE203-project1 -dir "/home/ise/Xilinx_project_VM/COE203-project1/planAhead_run_5" -part xc7a100tcsg324-3
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/ise/Xilinx_project_VM/COE203-project1/AlarmClock.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/ise/Xilinx_project_VM/COE203-project1} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "timer.ucf" [current_fileset -constrset]
add_files [list {timer.ucf}] -fileset [get_property constrset [current_run]]
link_design
