vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/sem_v4_1_16
vlib questa_lib/msim/xil_defaultlib

vmap sem_v4_1_16 questa_lib/msim/sem_v4_1_16
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work sem_v4_1_16  -incr -mfcu  "+incdir+../../../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" \
"../../../ipstatic/hdl/sem_v4_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" \
"../../../../SEM_test.gen/sources_1/ip/sem_0/sim/sem_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

