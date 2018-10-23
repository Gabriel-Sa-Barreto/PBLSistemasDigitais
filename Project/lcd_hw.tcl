# TCL File Generated by Component Editor 18.1
# Wed Oct 17 14:06:13 BRT 2018
# DO NOT MODIFY


# 
# LCD "LCD" v1.0
#  2018.10.17.14:06:13
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module LCD
# 
set_module_property DESCRIPTION ""
set_module_property NAME LCD
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME LCD
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL lcd
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file LcdCustomInstruction.v VERILOG PATH LcdCustomInstruction.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point nios_custom_instruction_slave_2
# 
add_interface nios_custom_instruction_slave_2 nios_custom_instruction end
set_interface_property nios_custom_instruction_slave_2 clockCycle 0
set_interface_property nios_custom_instruction_slave_2 operands 2
set_interface_property nios_custom_instruction_slave_2 ENABLED true
set_interface_property nios_custom_instruction_slave_2 EXPORT_OF ""
set_interface_property nios_custom_instruction_slave_2 PORT_NAME_MAP ""
set_interface_property nios_custom_instruction_slave_2 CMSIS_SVD_VARIABLES ""
set_interface_property nios_custom_instruction_slave_2 SVD_ADDRESS_GROUP ""

add_interface_port nios_custom_instruction_slave_2 dataa dataa Input 32
add_interface_port nios_custom_instruction_slave_2 datab datab Input 32
add_interface_port nios_custom_instruction_slave_2 clk clk Input 1
add_interface_port nios_custom_instruction_slave_2 clk_en clk_en Input 1


# 
# connection point conduit_end_1
# 
add_interface conduit_end_1 conduit end
set_interface_property conduit_end_1 associatedClock ""
set_interface_property conduit_end_1 associatedReset ""
set_interface_property conduit_end_1 ENABLED true
set_interface_property conduit_end_1 EXPORT_OF ""
set_interface_property conduit_end_1 PORT_NAME_MAP ""
set_interface_property conduit_end_1 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_1 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_1 display readdata Output 8


# 
# connection point conduit_end_2
# 
add_interface conduit_end_2 conduit end
set_interface_property conduit_end_2 associatedClock ""
set_interface_property conduit_end_2 associatedReset ""
set_interface_property conduit_end_2 ENABLED true
set_interface_property conduit_end_2 EXPORT_OF ""
set_interface_property conduit_end_2 PORT_NAME_MAP ""
set_interface_property conduit_end_2 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_2 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_2 rw writeresponsevalid_n Output 1


# 
# connection point conduit_end_3
# 
add_interface conduit_end_3 conduit end
set_interface_property conduit_end_3 associatedClock ""
set_interface_property conduit_end_3 associatedReset ""
set_interface_property conduit_end_3 ENABLED true
set_interface_property conduit_end_3 EXPORT_OF ""
set_interface_property conduit_end_3 PORT_NAME_MAP ""
set_interface_property conduit_end_3 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_3 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_3 rs writeresponsevalid_n Output 1


# 
# connection point conduit_end_4
# 
add_interface conduit_end_4 conduit end
set_interface_property conduit_end_4 associatedClock ""
set_interface_property conduit_end_4 associatedReset ""
set_interface_property conduit_end_4 ENABLED true
set_interface_property conduit_end_4 EXPORT_OF ""
set_interface_property conduit_end_4 PORT_NAME_MAP ""
set_interface_property conduit_end_4 CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end_4 SVD_ADDRESS_GROUP ""

add_interface_port conduit_end_4 en writeresponsevalid_n Output 1
