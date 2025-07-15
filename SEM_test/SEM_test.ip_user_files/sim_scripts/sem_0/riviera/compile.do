transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/sem_v4_1_16
vlib riviera/xil_defaultlib

vmap sem_v4_1_16 riviera/sem_v4_1_16
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work sem_v4_1_16  -incr -v2k5 "+incdir+../../../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" -l sem_v4_1_16 -l xil_defaultlib \
"../../../ipstatic/hdl/sem_v4_1_vl_rfs.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" -l sem_v4_1_16 -l xil_defaultlib \
"../../../../SEM_test.gen/sources_1/ip/sem_0/sim/sem_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

