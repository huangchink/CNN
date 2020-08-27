gui_start

read_file {../include ../src} -autoread -recursive -format verilog -top top

current_design top

source ../script/DC.sdc

compile -exact_map

check_timing
report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group
report_timing -path full -delay min -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group

write -hierarchy -format verilog -output ../syn/top_syn.v

write_sdf -version 2.1 -context verilog ../syn/top_syn.sdf
