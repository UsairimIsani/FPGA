
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name led_test -dir "D:/X9/LED_test/led_test/planAhead_run_1" -part xc6slx9tqg144-2
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/X9/LED_test/led_test/ledwater.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/X9/LED_test/led_test} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "ledwater.ucf" [current_fileset -constrset]
add_files [list {ledwater.ucf}] -fileset [get_property constrset [current_run]]
link_design
