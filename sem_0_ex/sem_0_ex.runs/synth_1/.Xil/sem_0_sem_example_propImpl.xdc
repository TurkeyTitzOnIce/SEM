set_property SRC_FILE_INFO {cfile:c:/Users/j48s677/Desktop/vivado_stuff/SEM/SEM/sem_0_ex/imports/sem_0_sem_example.xdc rfile:../../../imports/sem_0_sem_example.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:90 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay 124.0 -from [get_pins example_cfg/example_frame_ecc/*] -quiet -datapath_only
set_property src_info {type:XDC file:1 line:91 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay 250.0 -from [get_pins example_cfg/example_frame_ecc/*] -to [all_outputs] -quiet -datapath_only
set_property src_info {type:XDC file:1 line:272 export:INPUT save:INPUT read:READ} [current_design]
create_pblock SEM_CONTROLLER
add_cells_to_pblock [get_pblocks SEM_CONTROLLER] [get_cells example_mon/*]
add_cells_to_pblock [get_pblocks SEM_CONTROLLER] [get_cells example_ext/*]
add_cells_to_pblock [get_pblocks SEM_CONTROLLER] [get_cells {example_controller example_ext example_mon}]
resize_pblock [get_pblocks SEM_CONTROLLER] -add {SLICE_X0Y0:SLICE_X31Y20}
resize_pblock [get_pblocks SEM_CONTROLLER] -add {RAMB18_X0Y0:RAMB18_X0Y3}
resize_pblock [get_pblocks SEM_CONTROLLER] -add {RAMB36_X0Y2:RAMB36_X0Y6}
set_property src_info {type:XDC file:1 line:290 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC FRAME_ECC_X0Y0 [get_cells example_cfg/example_frame_ecc]
set_property src_info {type:XDC file:1 line:291 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC ICAP_X0Y1 [get_cells example_cfg/example_icap]
