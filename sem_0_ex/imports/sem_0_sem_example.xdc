#############################################################################
##
##
##
#############################################################################
##   ____  ____
##  /   /\/   /
## /___/  \  /
## \   \   \/    Core:          sem
##  \   \        Module:        sem_0_sem_example
##  /   /        Filename:      sem_0_sem_example.xdc
## /___/   /\    Purpose:       Constraints for the example design.
## \   \  /  \   *
##  \___\/\___\
##
#############################################################################
##
## (c) Copyright 2010 - 2019 AMD, Inc. All rights reserved.
##
## This file contains confidential and proprietary information
## of AMD, Inc. and is protected under U.S. and
## international copyright and other intellectual property
## laws.
##
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## AMD, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) AMD shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or AMD had been advised of the
## possibility of the same.
##
## CRITICAL APPLICATIONS
## AMD products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of AMD products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
##
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES. 
##
#############################################################################
## Constraint Description:
##
## These constraints are for physical implementation of the system level
## design example.
##
## The SEM controller initializes and manages the FPGA integrated silicon
## features for soft error mitigation.  When the controller is included
## in a design, do not include any design constraints related to these
## features.  Similarly, do not use any related bitgen options other than
## those for generating essential bit data files.
#############################################################################

########################################
## Controller: Internal Timing constraints
########################################

## The controller clock PERIOD constraint is propagated into the controller
## from the system level design example, where a PERIOD constraint is applied
## on the external clock input pin.

## The FRAME_ECC primitive is not considered a synchronous timing point,
## although it is. As a result, paths between FRAME_ECC and the controller
## are not analyzed by the PERIOD constraint. These constraints are placed
## to supplement the PERIOD coverage to ensure the nets are fully constrained.

set_max_delay 124.0 -from [get_pins example_cfg/example_frame_ecc/*] -quiet -datapath_only
set_max_delay 250.0 -from [get_pins example_cfg/example_frame_ecc/*] -to [all_outputs] -quiet -datapath_only

########################################
## Example Design: Master Clock
########################################

## Constraints on the clock net, including the clock PERIOD constraint.

create_clock -name clk -period 125.0 [get_ports clk]
set_property IOSTANDARD LVCMOS25 [get_ports clk]

########################################
## Example Design: Status Pins
########################################

## Constraints on the external status pins. These are expected to
## be used as asynchronous "flag" outputs, although they can be used
## as synchronous outputs with respect to the "clk" input signal.
## The timing constraints are therefore intended to make sure the
## timing paths are analyzed, rather than unconstrained. It is also
## possible to use these as internal signals between the status port
## and user-supplied logic to observe the status port. In such use,
## the signals would be covered by PERIOD constraint.

set_property DRIVE 8 [get_ports status_initialization]
set_property SLEW FAST [get_ports status_initialization]
set_property IOSTANDARD LVCMOS25 [get_ports status_initialization]

set_property DRIVE 8 [get_ports status_observation]
set_property SLEW FAST [get_ports status_observation]
set_property IOSTANDARD LVCMOS25 [get_ports status_observation]

set_property DRIVE 8 [get_ports status_correction]
set_property SLEW FAST [get_ports status_correction]
set_property IOSTANDARD LVCMOS25 [get_ports status_correction]

set_property DRIVE 8 [get_ports status_classification]
set_property SLEW FAST [get_ports status_classification]
set_property IOSTANDARD LVCMOS25 [get_ports status_classification]

set_property DRIVE 8 [get_ports status_injection]
set_property SLEW FAST [get_ports status_injection]
set_property IOSTANDARD LVCMOS25 [get_ports status_injection]

set_property DRIVE 8 [get_ports status_uncorrectable]
set_property SLEW FAST [get_ports status_uncorrectable]
set_property IOSTANDARD LVCMOS25 [get_ports status_uncorrectable]

set_property DRIVE 8 [get_ports status_essential]
set_property SLEW FAST [get_ports status_essential]
set_property IOSTANDARD LVCMOS25 [get_ports status_essential]

set_property DRIVE 8 [get_ports status_heartbeat]
set_property SLEW FAST [get_ports status_heartbeat]
set_property IOSTANDARD LVCMOS25 [get_ports status_heartbeat]

set_output_delay -clock clk -125.0 [get_ports [list status_observation status_correction status_classification status_injection status_uncorrectable status_essential status_heartbeat status_initialization]] -max
set_output_delay -clock clk 0 [get_ports [list status_observation status_correction status_classification status_injection status_uncorrectable status_essential status_heartbeat status_initialization]] -min

########################################
## Example Design: MON Shim and Pins
########################################

## Constraints on the MON shim external pins, for reproducibility.
## The timing analysis by trce need not be reviewed for these pins
## as the serial communications interface is asynchronous.

set_property DRIVE 8 [get_ports monitor_tx]
set_property SLEW FAST [get_ports monitor_tx]
set_property IOSTANDARD LVCMOS25 [get_ports monitor_tx]

set_property IOSTANDARD LVCMOS25 [get_ports monitor_rx]

set_input_delay -clock clk -max -125.0 [get_ports monitor_rx]
set_input_delay -clock clk -min 250.0 [get_ports monitor_rx]
set_output_delay -clock clk -125.0 [get_ports monitor_tx] -max
set_output_delay -clock clk 0 [get_ports monitor_tx] -min

########################################
## Example Design: EXT Shim and Pins
########################################

## Constraints on the EXT shim external pins, for reproducibility.
## The timing analysis by trce must be reviewed in conjunction with
## the documented external memory timing budget to determine the
## maximum frequency of the design, including the effects of the
## external memory system design.

set_property IOB TRUE [get_cells example_ext/example_ext_byte/ext_c_ofd]
set_property IOB TRUE [get_cells example_ext/example_ext_byte/ext_d_ofd]
set_property IOB TRUE [get_cells example_ext/example_ext_byte/ext_q_ifd]
set_property IOB TRUE [get_cells example_ext/ext_s_ofd]

set_property DRIVE 8 [get_ports external_c]
set_property SLEW FAST [get_ports external_c]
set_property IOSTANDARD LVCMOS25 [get_ports external_c]

set_property DRIVE 8 [get_ports external_d]
set_property SLEW FAST [get_ports external_d]
set_property IOSTANDARD LVCMOS25 [get_ports external_d]

set_property DRIVE 8 [get_ports external_s_n]
set_property SLEW FAST [get_ports external_s_n]
set_property IOSTANDARD LVCMOS25 [get_ports external_s_n]

set_property IOSTANDARD LVCMOS25 [get_ports external_q]

set_input_delay -clock clk -max -125.0 [get_ports external_q]
set_input_delay -clock clk -min 250.0 [get_ports external_q]
set_output_delay -clock clk -125.0 [get_ports [list external_d external_s_n external_c]] -max
set_output_delay -clock clk 0 [get_ports [list external_d external_s_n external_c]] -min

########################################
## Example Design: HID Shim and Pins
########################################

## Constraints on the external error injection pins. Although
## the example design brings these to external pins and they may
## be used as synchronous inputs with respect to the "clk" input
## signal, these are expected to be used as internal signals
## between the error injection port and user-supplied logic to
## control the error injection port. In such use, the signals
## would be covered by PERIOD constraint. Timing constraints
## are therefore intended to make sure the timing paths are
## analyzed, rather than unconstrained.

set_property IOSTANDARD LVCMOS25 [get_ports inject_strobe]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[4]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[5]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[6]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[7]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[8]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[9]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[10]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[11]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[12]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[13]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[14]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[15]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[16]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[17]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[18]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[19]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[20]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[21]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[22]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[23]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[24]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[25]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[26]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[27]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[28]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[29]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[30]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[31]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[32]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[33]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[34]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[35]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[36]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[37]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[38]}]
set_property IOSTANDARD LVCMOS25 [get_ports {inject_address[39]}]

set_input_delay -clock clk -max -125.0 [get_ports [list {inject_address[0]} {inject_address[1]} {inject_address[2]} {inject_address[3]} {inject_address[4]} {inject_address[5]} {inject_address[6]} {inject_address[7]} {inject_address[8]} {inject_address[9]} {inject_address[10]} {inject_address[11]} {inject_address[12]} {inject_address[13]} {inject_address[14]} {inject_address[15]} {inject_address[16]} {inject_address[17]} {inject_address[18]} {inject_address[19]} {inject_address[20]} {inject_address[21]} {inject_address[22]} {inject_address[23]} {inject_address[24]} {inject_address[25]} {inject_address[26]} {inject_address[27]} {inject_address[28]} {inject_address[29]} {inject_address[30]} {inject_address[31]} {inject_address[32]} {inject_address[33]} {inject_address[34]} {inject_address[35]} {inject_address[36]} {inject_address[37]} {inject_address[38]} {inject_address[39]} inject_strobe]]
set_input_delay -clock clk -min 250.0 [get_ports [list {inject_address[0]} {inject_address[1]} {inject_address[2]} {inject_address[3]} {inject_address[4]} {inject_address[5]} {inject_address[6]} {inject_address[7]} {inject_address[8]} {inject_address[9]} {inject_address[10]} {inject_address[11]} {inject_address[12]} {inject_address[13]} {inject_address[14]} {inject_address[15]} {inject_address[16]} {inject_address[17]} {inject_address[18]} {inject_address[19]} {inject_address[20]} {inject_address[21]} {inject_address[22]} {inject_address[23]} {inject_address[24]} {inject_address[25]} {inject_address[26]} {inject_address[27]} {inject_address[28]} {inject_address[29]} {inject_address[30]} {inject_address[31]} {inject_address[32]} {inject_address[33]} {inject_address[34]} {inject_address[35]} {inject_address[36]} {inject_address[37]} {inject_address[38]} {inject_address[39]} inject_strobe]]

########################################
## Example Design: Logic Placement
########################################

## Constraints on logic placement. The controller and its
## shims, which are the soft error mitigation solution, need
## to be reasonably area constrained.  This keeps everything
## near the configuration logic and also helps in generating
## a reasonable slice count estimate for reliability estimates.

create_pblock SEM_CONTROLLER
resize_pblock -pblock SEM_CONTROLLER -add RAMB18_X0Y0:RAMB18_X0Y3
resize_pblock -pblock SEM_CONTROLLER -add RAMB36_X0Y2:RAMB36_X0Y6
resize_pblock -pblock SEM_CONTROLLER -add SLICE_X0Y0:SLICE_X30Y20
add_cells_to_pblock -pblock SEM_CONTROLLER -cells [get_cells example_controller]
add_cells_to_pblock -pblock SEM_CONTROLLER -cells [get_cells example_mon/*]
add_cells_to_pblock -pblock SEM_CONTROLLER -cells [get_cells example_ext/*]

## Prohibit addition of unrelated logic into this group...
## UCF: AREA_GROUP "SEM_CONTROLLER" GROUP = CLOSED ;
## There is currently no equivalent to this.

## Allow placement of unrelated components in the range...
## UCF: AREA_GROUP "SEM_CONTROLLER" PLACE = OPEN ;
## There is currently no equivalent to this.

## Force ICAP to the required (top) site in the device.
## Force FRAME_ECC to the required (only) site in the device.
set_property LOC FRAME_ECC_X0Y0 [get_cells example_cfg/example_frame_ecc]
set_property LOC ICAP_X0Y1 [get_cells example_cfg/example_icap]

########################################
## Example Design: I/O Placement
########################################

## To place the I/O, uncomment the following template and
## annotate with desired pin location for each signal.

## set_property LOC <pin loc> [get_ports clk]
## set_property LOC <pin loc> [get_ports status_initialization]
## set_property LOC <pin loc> [get_ports status_observation]
## set_property LOC <pin loc> [get_ports status_correction]
## set_property LOC <pin loc> [get_ports status_classification]
## set_property LOC <pin loc> [get_ports status_injection]
## set_property LOC <pin loc> [get_ports status_uncorrectable]
## set_property LOC <pin loc> [get_ports status_essential]
## set_property LOC <pin loc> [get_ports status_heartbeat]
## set_property LOC <pin loc> [get_ports monitor_tx]
## set_property LOC <pin loc> [get_ports monitor_rx]
## set_property LOC <pin loc> [get_ports external_c]
## set_property LOC <pin loc> [get_ports external_d]
## set_property LOC <pin loc> [get_ports external_q]
## set_property LOC <pin loc> [get_ports external_s_n]
## set_property LOC <pin loc> [get_ports inject_strobe]
## set_property LOC <pin loc> [get_ports {inject_address[0]}]
## set_property LOC <pin loc> [get_ports {inject_address[1]}]
## set_property LOC <pin loc> [get_ports {inject_address[2]}]
## set_property LOC <pin loc> [get_ports {inject_address[3]}]
## set_property LOC <pin loc> [get_ports {inject_address[4]}]
## set_property LOC <pin loc> [get_ports {inject_address[5]}]
## set_property LOC <pin loc> [get_ports {inject_address[6]}]
## set_property LOC <pin loc> [get_ports {inject_address[7]}]
## set_property LOC <pin loc> [get_ports {inject_address[8]}]
## set_property LOC <pin loc> [get_ports {inject_address[9]}]
## set_property LOC <pin loc> [get_ports {inject_address[10]}]
## set_property LOC <pin loc> [get_ports {inject_address[11]}]
## set_property LOC <pin loc> [get_ports {inject_address[12]}]
## set_property LOC <pin loc> [get_ports {inject_address[13]}]
## set_property LOC <pin loc> [get_ports {inject_address[14]}]
## set_property LOC <pin loc> [get_ports {inject_address[15]}]
## set_property LOC <pin loc> [get_ports {inject_address[16]}]
## set_property LOC <pin loc> [get_ports {inject_address[17]}]
## set_property LOC <pin loc> [get_ports {inject_address[18]}]
## set_property LOC <pin loc> [get_ports {inject_address[19]}]
## set_property LOC <pin loc> [get_ports {inject_address[20]}]
## set_property LOC <pin loc> [get_ports {inject_address[21]}]
## set_property LOC <pin loc> [get_ports {inject_address[22]}]
## set_property LOC <pin loc> [get_ports {inject_address[23]}]
## set_property LOC <pin loc> [get_ports {inject_address[24]}]
## set_property LOC <pin loc> [get_ports {inject_address[25]}]
## set_property LOC <pin loc> [get_ports {inject_address[26]}]
## set_property LOC <pin loc> [get_ports {inject_address[27]}]
## set_property LOC <pin loc> [get_ports {inject_address[28]}]
## set_property LOC <pin loc> [get_ports {inject_address[29]}]
## set_property LOC <pin loc> [get_ports {inject_address[30]}]
## set_property LOC <pin loc> [get_ports {inject_address[31]}]
## set_property LOC <pin loc> [get_ports {inject_address[32]}]
## set_property LOC <pin loc> [get_ports {inject_address[33]}]
## set_property LOC <pin loc> [get_ports {inject_address[34]}]
## set_property LOC <pin loc> [get_ports {inject_address[35]}]
## set_property LOC <pin loc> [get_ports {inject_address[36]}]
## set_property LOC <pin loc> [get_ports {inject_address[37]}]
## set_property LOC <pin loc> [get_ports {inject_address[38]}]
## set_property LOC <pin loc> [get_ports {inject_address[39]}]

########################################
## Vivado Properties: Essential Bits
########################################

## This property enables essential bits generation in Vivado.

set_property bitstream.seu.essentialbits yes [current_design]

#############################################################################
##
#############################################################################
