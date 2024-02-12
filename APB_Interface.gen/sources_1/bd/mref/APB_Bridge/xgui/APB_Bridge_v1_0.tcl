# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "access" -parent ${Page_0}
  ipgui::add_param $IPINST -name "idle" -parent ${Page_0}
  ipgui::add_param $IPINST -name "setup" -parent ${Page_0}


}

proc update_PARAM_VALUE.access { PARAM_VALUE.access } {
	# Procedure called to update access when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.access { PARAM_VALUE.access } {
	# Procedure called to validate access
	return true
}

proc update_PARAM_VALUE.idle { PARAM_VALUE.idle } {
	# Procedure called to update idle when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.idle { PARAM_VALUE.idle } {
	# Procedure called to validate idle
	return true
}

proc update_PARAM_VALUE.setup { PARAM_VALUE.setup } {
	# Procedure called to update setup when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.setup { PARAM_VALUE.setup } {
	# Procedure called to validate setup
	return true
}


proc update_MODELPARAM_VALUE.idle { MODELPARAM_VALUE.idle PARAM_VALUE.idle } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.idle}] ${MODELPARAM_VALUE.idle}
}

proc update_MODELPARAM_VALUE.setup { MODELPARAM_VALUE.setup PARAM_VALUE.setup } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.setup}] ${MODELPARAM_VALUE.setup}
}

proc update_MODELPARAM_VALUE.access { MODELPARAM_VALUE.access PARAM_VALUE.access } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.access}] ${MODELPARAM_VALUE.access}
}

