transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+sem_0  -L xil_defaultlib -L sem_v4_1_16 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.sem_0 xil_defaultlib.glbl

do {sem_0.udo}

run 1000ns

endsim

quit -force
