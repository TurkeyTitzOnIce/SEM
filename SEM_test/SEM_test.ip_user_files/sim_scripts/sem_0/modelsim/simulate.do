onbreak {quit -f}
onerror {quit -f}

vsim -voptargs="+acc"  -L xil_defaultlib -L sem_v4_1_16 -L unisims_ver -L unimacro_ver -L secureip -lib xil_defaultlib xil_defaultlib.sem_0 xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {sem_0.udo}

run 1000ns

quit -force
