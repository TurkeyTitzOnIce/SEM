transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/sem_v4_1_16
vlib activehdl/xil_defaultlib

vmap sem_v4_1_16 activehdl/sem_v4_1_16
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work sem_v4_1_16  -v2k5 "+incdir+../../../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" -l sem_v4_1_16 -l xil_defaultlib \
"../../../ipstatic/hdl/sem_v4_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../../../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" -l sem_v4_1_16 -l xil_defaultlib \
"../../../../SEM_test.gen/sources_1/ip/sem_0/sim/sem_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

