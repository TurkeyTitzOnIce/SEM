// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Tue Jul 15 14:05:48 2025
// Host        : BZ-ECE-BL-LAB01 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/j48s677/Desktop/vivado_stuff/SEM/SEM/SEM_test/SEM_test.gen/sources_1/ip/sem_0/sem_0_stub.v
// Design      : sem_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* CHECK_LICENSE_TYPE = "sem_0,sem_v4_1_16_x7_sem_controller,{}" *) (* CORE_GENERATION_INFO = "sem_0,sem_v4_1_16_x7_sem_controller,{x_ipProduct=Vivado 2025.1,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=sem,x_ipVersion=4.1,x_ipCoreRevision=16,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,c_xdevice=artix7,c_xpackage=cpg236,c_xspeedgrade=-1,c_xdevicefamily=artix7,c_family=artix7,c_device_array=16777218,c_icapwidth=32,c_eipwidth=40,c_farwidth=26,c_component_name=sem_0,c_clock_per=125000,c_feature_set=8,c_hardware_cfg=2,c_software_cfg=1,b_debug=0,b_cosim=0,b_dfset=0,b_gen_user_app=0,x_ipLicense=sem@2014.04(unknown)}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) 
(* X_CORE_INFO = "sem_v4_1_16_x7_sem_controller,Vivado 2025.1" *) 
module sem_0(status_heartbeat, status_initialization, 
  status_observation, status_correction, status_classification, status_injection, 
  status_essential, status_uncorrectable, fetch_txdata, fetch_txwrite, fetch_txfull, 
  fetch_rxdata, fetch_rxread, fetch_rxempty, fetch_tbladdr, monitor_txdata, monitor_txwrite, 
  monitor_txfull, monitor_rxdata, monitor_rxread, monitor_rxempty, inject_strobe, 
  inject_address, icap_o, icap_csib, icap_rdwrb, icap_i, icap_clk, icap_request, icap_grant, 
  fecc_crcerr, fecc_eccerr, fecc_eccerrsingle, fecc_syndromevalid, fecc_syndrome, fecc_far, 
  fecc_synbit, fecc_synword)
/* synthesis syn_black_box black_box_pad_pin="status_heartbeat,status_initialization,status_observation,status_correction,status_classification,status_injection,status_essential,status_uncorrectable,fetch_txdata[7:0],fetch_txwrite,fetch_txfull,fetch_rxdata[7:0],fetch_rxread,fetch_rxempty,fetch_tbladdr[31:0],monitor_txdata[7:0],monitor_txwrite,monitor_txfull,monitor_rxdata[7:0],monitor_rxread,monitor_rxempty,inject_strobe,inject_address[39:0],icap_o[31:0],icap_csib,icap_rdwrb,icap_i[31:0],icap_request,icap_grant,fecc_crcerr,fecc_eccerr,fecc_eccerrsingle,fecc_syndromevalid,fecc_syndrome[12:0],fecc_far[25:0],fecc_synbit[4:0],fecc_synword[6:0]" */
/* synthesis syn_force_seq_prim="icap_clk" */;
  output status_heartbeat;
  output status_initialization;
  output status_observation;
  output status_correction;
  output status_classification;
  output status_injection;
  output status_essential;
  output status_uncorrectable;
  output [7:0]fetch_txdata;
  output fetch_txwrite;
  input fetch_txfull;
  input [7:0]fetch_rxdata;
  output fetch_rxread;
  input fetch_rxempty;
  input [31:0]fetch_tbladdr;
  output [7:0]monitor_txdata;
  output monitor_txwrite;
  input monitor_txfull;
  input [7:0]monitor_rxdata;
  output monitor_rxread;
  input monitor_rxempty;
  input inject_strobe;
  input [39:0]inject_address;
  input [31:0]icap_o;
  output icap_csib;
  output icap_rdwrb;
  output [31:0]icap_i;
  input icap_clk /* synthesis syn_isclock = 1 */;
  output icap_request;
  input icap_grant;
  input fecc_crcerr;
  input fecc_eccerr;
  input fecc_eccerrsingle;
  input fecc_syndromevalid;
  input [12:0]fecc_syndrome;
  input [25:0]fecc_far;
  input [4:0]fecc_synbit;
  input [6:0]fecc_synword;
endmodule
