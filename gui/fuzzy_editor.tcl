# ----------------------------------------------------------------------
# fls EDITOR
# ----------------------------------------------------------------------
# This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
# Copyright (C) 2004 Jaime Urzua Grez
# mailto:jaime_urzua@yahoo.com
# 2011 Holger Nahrstaedt
# ----------------------------------------------------------------------
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ----------------------------------------------------------------------
# CHANGES
# 2004-10-07 Add subroutine sciFLTEditorEditBlank
#            Fix bug in sciFLTEditorDrawTree when no page to display
#            Fix bug in sciFLTEditorDelFls when delete fls
# 2004-10-08 Now can plot vars.
#            The surface was unset! 
# 2004-11-04 Spell Check.
# ----------------------------------------------------------------------

# POR REVISAR
# (  ) CUANDO SE AGREGA UN AVARIABLE ACTUALIZAR LAS REGLAS
# (  ) CUANDO SE BORRA UNA FUNCION DE PERTENENCIA ACTUALIZAR LAS REGLAS
# (  ) CUANDO SE BORRE DE ALGUNA LISTA TABIEN BORRAR LA VARIABLE -> MEMORIA !

global sciFLTEditor

# ------------------------------------------------------------------------------------------------------------------
# DRAW THE FLS INFO TAB
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorDrawInformation { idx } {
	global sciFLTEditorTable
	set w $sciFLTEditorTable(winname).center.right.info
	if { $sciFLTEditorTable(curright)!="" } then {
		destroy $sciFLTEditorTable(curright)
	}
	
	labelframe $w -text "Information :" -padx 2 -pady 2

	# SHOW A SUMMARY
	frame $w.sum
	label $w.sum.l_name     -text "name :"
	label $w.sum.l_comment  -text "comment :"
	label $w.sum.l_type     -text "type :"
	label $w.sum.l_ninputs  -text "number of inputs :"
	label $w.sum.l_noutputs -text "number of outputs :"
	label $w.sum.l_nrules   -text "number of rules :"	
	label $w.sum.name       -textvariable sciFLTEditorTable($idx,name)     -width 30 -relief sunken -anchor w
	label $w.sum.comment    -textvariable sciFLTEditorTable($idx,comment)  -width 30 -relief sunken -anchor w
	label $w.sum.type       -textvariable sciFLTEditorTable($idx,type)     -width 30 -relief sunken -anchor w
	label $w.sum.ninputs    -text [expr [llength $sciFLTEditorTable($idx,input,tidx)]+0]  -width 30 -relief sunken -anchor w
	label $w.sum.noutputs   -text [expr [llength $sciFLTEditorTable($idx,output,tidx)]+0] -width  30 -relief sunken -anchor w
	label $w.sum.nrules     -text [expr [llength $sciFLTEditorTable($idx,rule,tidx)]+0] -width 30 -relief sunken -anchor w
	grid config $w.sum.l_name     -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "e" -pady 2
	grid config $w.sum.name       -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w" -pady 2
	grid config $w.sum.l_comment  -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky "e" -pady 2
	grid config $w.sum.comment    -column 1 -row 1 -columnspan 1 -rowspan 1 -sticky "w" -pady 2
	grid config $w.sum.l_type     -column 0 -row 2 -columnspan 1 -rowspan 1 -sticky "e" -pady 2
	grid config $w.sum.type       -column 1 -row 2 -columnspan 1 -rowspan 1 -sticky "w" -pady 2
	grid config $w.sum.l_ninputs  -column 0 -row 3 -columnspan 1 -rowspan 1 -sticky "e" -pady 2
	grid config $w.sum.ninputs    -column 1 -row 3 -columnspan 1 -rowspan 1 -sticky "w" -pady 2
	grid config $w.sum.l_noutputs -column 0 -row 4 -columnspan 1 -rowspan 1 -sticky "e" -pady 2
	grid config $w.sum.noutputs   -column 1 -row 4 -columnspan 1 -rowspan 1 -sticky "w" -pady 2
	grid config $w.sum.l_nrules   -column 0 -row 5 -columnspan 1 -rowspan 1 -sticky "e" -pady 2
	grid config $w.sum.nrules     -column 1 -row 5 -columnspan 1 -rowspan 1 -sticky "w" -pady 2

	# PACK ALL AND GO OUT
	pack $w.sum -side top -fill x -expand 0
	pack $w -side top -fill both -expand 1
	set sciFLTEditorTable(curright) $w
}


# ------------------------------------------------------------------------------------------------------------------
# DRAW THE FLS OPTIONS TAB
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorDrawOptions { idx } {
	global sciFLTEditorTable
	
	if { $sciFLTEditorTable(curright)!="" } then {
		destroy $sciFLTEditorTable(curright)
	}
	
	switch $sciFLTEditorTable($idx,type) {
		"ts"		{ set state1 "normal"  ; set state2 "disabled" }
		default		{ set state1 "disabled"; set state2 "normal"   }
	}
	
	set w $sciFLTEditorTable(winname).center.right.options
	
	labelframe $w -text "Description :" -padx 2 -pady 2	

	# FLS INFORMATION
	labelframe $w.information -text "Information : "
	label $w.information.l_name -text "name :"
	label $w.information.l_comment -text "comment :"
	entry $w.information.name -textvariable sciFLTEditorTable($idx,name)
	entry $w.information.comment -textvariable sciFLTEditorTable($idx,comment)
	grid config $w.information.l_name    -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "e" -pady 2
	grid config $w.information.l_comment -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky "e" -pady 2
	grid config $w.information.name      -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w" -pady 2 -sticky "nsew"
	grid config $w.information.comment   -column 1 -row 1 -columnspan 1 -rowspan 1 -sticky "w" -pady 2 -sticky "nsew"
	grid columnconfigure $w.information 1 -weight 50

	# FLS TYPE
	labelframe $w.type -text "Type : "
	radiobutton $w.type.takagisugeno -text "Takagi-Sugeno" -variable sciFLTEditorTable($idx,type) -value "ts" -state disabled
	radiobutton $w.type.mamdani -text "Mamdani" -variable sciFLTEditorTable($idx,type) -value "m" -state disable
	grid config $w.type.takagisugeno -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "w" -pady 2
	grid config $w.type.mamdani      -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w" -pady 2

	# FLS S-NORM CLASS
	labelframe $w.snorm -text "S-Norm Class : "
	frame $w.snorm.1
	radiobutton $w.snorm.1.dubois  -text "Dubois-Prade"  -variable sciFLTEditorTable($idx,snorm) -value "dubois"
	radiobutton $w.snorm.1.yager   -text "Yager"         -variable sciFLTEditorTable($idx,snorm) -value "yager" 
	radiobutton $w.snorm.1.dsum    -text "Drastic sum"   -variable sciFLTEditorTable($idx,snorm) -value "dsum"
	radiobutton $w.snorm.1.esum    -text "Einstein sum"  -variable sciFLTEditorTable($idx,snorm) -value "esum"
	radiobutton $w.snorm.1.asum    -text "Algebraic sum" -variable sciFLTEditorTable($idx,snorm) -value "asum"
	radiobutton $w.snorm.1.max     -text "Maximum"       -variable sciFLTEditorTable($idx,snorm) -value "max"
	grid config $w.snorm.1.dubois  -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "w" 
	grid config $w.snorm.1.yager   -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w" 
	grid config $w.snorm.1.dsum    -column 2 -row 0 -columnspan 1 -rowspan 1 -sticky "w" 
	grid config $w.snorm.1.esum    -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky "w" 
	grid config $w.snorm.1.asum    -column 1 -row 1 -columnspan 1 -rowspan 1 -sticky "w" 
	grid config $w.snorm.1.max     -column 2 -row 1 -columnspan 1 -rowspan 1 -sticky "w" 
	frame $w.snorm.2
	label $w.snorm.2.l_parameter -text "Parameter :"
	entry $w.snorm.2.parameter -textvariable sciFLTEditorTable($idx,snormpar)
	grid config $w.snorm.2.l_parameter -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "e"
	grid config $w.snorm.2.parameter   -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w"	
	pack $w.snorm.1 -side top -fill x -expand 0
	pack $w.snorm.2 -side top -fill x -expand 0
	
	
	# FLS T-NORM CLASS
	labelframe $w.tnorm -text "T-Norm Class : "
	frame $w.tnorm.1
	radiobutton $w.tnorm.1.dubois  -text "Dubois-Prade"      -variable sciFLTEditorTable($idx,tnorm) -value "dubois"
	radiobutton $w.tnorm.1.yager   -text "Yager"             -variable sciFLTEditorTable($idx,tnorm) -value "yager"
	radiobutton $w.tnorm.1.dprod   -text "Drastic product"   -variable sciFLTEditorTable($idx,tnorm) -value "dprod"
	radiobutton $w.tnorm.1.eprod   -text "Einstein product"  -variable sciFLTEditorTable($idx,tnorm) -value "eprod"
	radiobutton $w.tnorm.1.aprod   -text "Algebraic product" -variable sciFLTEditorTable($idx,tnorm) -value "aprod"
	radiobutton $w.tnorm.1.min     -text "Minimum"           -variable sciFLTEditorTable($idx,tnorm) -value "min"
	grid config $w.tnorm.1.dubois  -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.tnorm.1.yager   -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.tnorm.1.dprod   -column 2 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.tnorm.1.eprod   -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.tnorm.1.aprod   -column 1 -row 1 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.tnorm.1.min     -column 2 -row 1 -columnspan 1 -rowspan 1 -sticky "w"
	frame $w.tnorm.2
	label $w.tnorm.2.l_parameter -text "Parameter :"
	entry $w.tnorm.2.parameter -textvariable sciFLTEditorTable($idx,tnormpar)
	grid config $w.tnorm.2.l_parameter -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "e"
	grid config $w.tnorm.2.parameter   -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w"	
	pack $w.tnorm.1 -side top -fill x -expand 0
	pack $w.tnorm.2 -side top -fill x -expand 0

	# FLS COMPLEMENT
	labelframe $w.complement -text "Complement : "
	frame $w.complement.1
	radiobutton $w.complement.1.one    -text "One"    -variable sciFLTEditorTable($idx,comp) -value "one"
	radiobutton $w.complement.1.yager  -text "Yager"  -variable sciFLTEditorTable($idx,comp) -value "yager"
	radiobutton $w.complement.1.sugeno -text "Sugeno" -variable sciFLTEditorTable($idx,comp) -value "sugeno"
	grid config $w.complement.1.one    -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.complement.1.yager  -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.complement.1.sugeno -column 2 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	frame $w.complement.2
	label $w.complement.2.l_parameter -text "Parameter :"
	entry $w.complement.2.parameter   -textvariable sciFLTEditorTable($idx,comppar)
	grid config $w.complement.2.l_parameter -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "e"
	grid config $w.complement.2.parameter   -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	pack $w.complement.1 -side top -fill x -expand 0
	pack $w.complement.2 -side top -fill x -expand 0
	
	# FLS IMPLICATION METHOD	
	labelframe $w.implication -text "Implication Method : "
	frame $w.implication.1
	radiobutton $w.implication.1.min   -text "Minimum"  -variable sciFLTEditorTable($idx,impmethod) -value "min" -state $state2
	radiobutton $w.implication.1.prod  -text "Product"  -variable sciFLTEditorTable($idx,impmethod) -value "prod" -state $state2
	radiobutton $w.implication.1.eprod  -text "Einstein Product"  -variable sciFLTEditorTable($idx,impmethod) -value "eprod" -state $state2
        #radiobutton $w.implication.1.min   -text "Minimum"  -variable sciFLTEditorTable($idx,impmethod) -value "min"
	#radiobutton $w.implication.1.prod  -text "Product"  -variable sciFLTEditorTable($idx,impmethod) -value "prod"
	grid config $w.implication.1.min   -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.implication.1.prod  -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w"	
	grid config $w.implication.1.eprod  -column 2 -row 0 -columnspan 1 -rowspan 1 -sticky "w"	

	frame $w.implication.2
	pack $w.implication.1 -side top -fill x -expand 0
	pack $w.implication.2 -side top -fill x -expand 0

	# FLS AGGREGATION METHOD
	labelframe $w.aggregation -text "Aggregation Method : "
	frame $w.aggregation.1
	radiobutton $w.aggregation.1.max   -text "Maximum"  -variable sciFLTEditorTable($idx,aggmethod) -value "max" -state $state2
	radiobutton $w.aggregation.1.sum   -text "Sum"      -variable sciFLTEditorTable($idx,aggmethod) -value "sum" -state $state2
	radiobutton $w.aggregation.1.prob  -text "Prob. OR" -variable sciFLTEditorTable($idx,aggmethod) -value "probor" -state $state2
	radiobutton $w.aggregation.1.esum  -text "Einstein Sum" -variable sciFLTEditorTable($idx,aggmethod) -value "esum" -state $state2
	#radiobutton $w.aggregation.1.max   -text "Maximum"  -variable sciFLTEditorTable($idx,aggmethod) -value "max"
	#radiobutton $w.aggregation.1.sum   -text "Sum"      -variable sciFLTEditorTable($idx,aggmethod) -value "sum"
	#radiobutton $w.aggregation.1.prob  -text "Prob. OR" -variable sciFLTEditorTable($idx,aggmethod) -value "probor" 
	grid config $w.aggregation.1.max   -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.aggregation.1.sum   -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.aggregation.1.prob  -column 2 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.aggregation.1.esum  -column 3 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	
	frame $w.aggregation.2
	pack $w.aggregation.1 -side top -fill x -expand 0
	pack $w.aggregation.2 -side top -fill x -expand 0
	
	# FLS DEFUZZIFICATION METHOD
	labelframe $w.defuzzMethod -text "Defuzzification Method : "
	frame $w.defuzzMethod.1
	radiobutton $w.defuzzMethod.1.centroide -text "Centroide"          -variable sciFLTEditorTable($idx,defuzzmethod) -value "centroide" -state $state2
	radiobutton $w.defuzzMethod.1.bisector  -text "Bisector"           -variable sciFLTEditorTable($idx,defuzzmethod) -value "bisector" -state $state2
	radiobutton $w.defuzzMethod.1.mom       -text "Mean of Maximum"    -variable sciFLTEditorTable($idx,defuzzmethod) -value "mom" -state $state2
	radiobutton $w.defuzzMethod.1.lom       -text "Largest of Maximum" -variable sciFLTEditorTable($idx,defuzzmethod) -value "lom" -state $state2
	radiobutton $w.defuzzMethod.1.som       -text "Shortest of Maximum" -variable sciFLTEditorTable($idx,defuzzmethod) -value "som" -state $state2
	radiobutton $w.defuzzMethod.1.wtaver     -text "Weighted Average"    -variable sciFLTEditorTable($idx,defuzzmethod) -value "wtaver" -state $state1
	radiobutton $w.defuzzMethod.1.wtsum      -text "Weighted Sum"        -variable sciFLTEditorTable($idx,defuzzmethod) -value "wtsum" -state $state1
	grid config $w.defuzzMethod.1.centroide  -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.defuzzMethod.1.bisector   -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.defuzzMethod.1.mom        -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.defuzzMethod.1.som        -column 1 -row 1 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.defuzzMethod.1.lom        -column 2 -row 1 -columnspan 1 -rowspan 1 -sticky "w"	
	grid config $w.defuzzMethod.1.wtaver      -column 0 -row 2 -columnspan 1 -rowspan 1 -sticky "w"
	grid config $w.defuzzMethod.1.wtsum       -column 1 -row 2 -columnspan 1 -rowspan 1 -sticky "w"
	
	frame $w.defuzzMethod.2
	pack $w.defuzzMethod.1 -side top -fill x -expand 0
	pack $w.defuzzMethod.2 -side top -fill x -expand 0
	
	# PACK ALL AND GO OUT
	pack $w.information -side top -fill x -expand 1
	pack $w.type -side top -fill x -expand 1
	pack $w.snorm -side top -fill x -expand 1
	pack $w.tnorm -side top -fill x -expand 1
	pack $w.complement -side top -fill x -expand 1
	pack $w.implication -side top -fill x -expand 1
	pack $w.aggregation -side top -fill x -expand 1
	pack $w.defuzzMethod -side top -fill x -expand 1
	pack $w -side top -fill both -expand 1
	set sciFLTEditorTable(curright) $w
}


# ------------------------------------------------------------------------------------------------------------------
# DRAW VARIABLE INFORMATIOM
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorDrawVarInfo { idx io } {
	global sciFLTEditorTable
	
	if { $sciFLTEditorTable(curright)!="" } then {
		destroy $sciFLTEditorTable(curright)
	}

	set w $sciFLTEditorTable(winname).center.right.varinfo
	labelframe $w -text "[string toupper $io]S VARIABLES :"

	labelframe $w.gen -text "Information :" -fg blue
	label $w.gen.l_nvar -text "Number of $io variables:"
	label $w.gen.nvar -text [llength $sciFLTEditorTable($idx,$io,tidx)] -width 15 -relief sunken -anchor w
	grid config $w.gen.l_nvar -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "e" -pady 2
	grid config $w.gen.nvar   -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "w" -pady 2
	
	labelframe $w.opt -text "Variables:" -fg blue
	frame $w.opt.left
	listbox $w.opt.left.list -width 10 -height 1
	scrollbar $w.opt.left.sb -orient vertical
	pack $w.opt.left.list -side left -fill both -expand 1
	pack $w.opt.left.sb -side left -fill y -expand 0
	for { set j 0 } { $j<[llength $sciFLTEditorTable($idx,$io,tidx)] } { incr j } {
			set lidx [lindex $sciFLTEditorTable($idx,$io,tidx) $j]		
			set toinsert "([expr $j+1]) $sciFLTEditorTable($idx,$io,$lidx,name)"
			$w.opt.left.list insert end $toinsert
	}
	if { [llength $sciFLTEditorTable($idx,$io,tidx)]>0 } then {
		bind $w.opt.left.list <Double-1> {
			global sciFLTEditTable
			set sciFLTEditorTable(curVarToAction) [selection get]
			set w $sciFLTEditorTable(winname).center.right.varinfo
			$w.opt.right.edit configure -state active
			$w.opt.right.del configure -state active		
		}
	}
	
	frame $w.opt.right
	button $w.opt.right.add  -text "Add"    -width 10 -command "sciFLTEditorNewVar $idx $io;sciFLTEditorDrawTree"
	button $w.opt.right.del  -text "Delete" -width 10 -state disabled -command "sciFLTEditorDelVar"
	button $w.opt.right.edit -text "Edit"   -width 10 -state disabled -command "sciFLTEditorEdiVar"
	pack $w.opt.right.add $w.opt.right.del $w.opt.right.edit -side top -fill both -pady 5 -expand 0
	
	pack $w.opt.left  -side left -expand 1 -fill both -padx 2
	pack $w.opt.right -side left -expand 0 -fill y -padx 2
	
	pack $w.gen -side top -fill both -expand 0 -pady 2 -ipady 2
	pack $w.opt -side top -fill both -expand 1 -pady 2
	pack $w -side top -fill both -expand 1
	set sciFLTEditorTable(curright) $w
}

# ------------------------------------------------------------------------------------------------------------------
# DELETE MEMBER FUNCTIONS
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorDrawVarEditDelMf { idx io idxio } {
	global sciFLTEditorTable
	set todel ""
	foreach idxmf $sciFLTEditorTable($idx,$io,$idxio,mf,tidx) {		      
		if { $sciFLTEditorTable($idx,$io,$idxio,mf,$idxmf,todel) } then {
			lappend todel $idxmf
		}
	}
	if { [llength $todel]>0 } then {
		set mes "Delete the checked member functions ?\nThis action also make changes over the rules (if is required)."
		set parent $sciFLTEditorTable(winname)
		set answer [tk_messageBox -title "Delete member functions" -type yesno -message $mes -parent $parent -icon question]
		if { $answer=="yes" } then {			
			set newvalue ""
			foreach idxmf $sciFLTEditorTable($idx,$io,$idxio,mf,tidx) {
				if { ![regexp $idxmf $todel] } then {
					lappend newvalue $idxmf
				}
			}			
			set sciFLTEditorTable($idx,$io,$idxio,mf,tidx) $newvalue
			set pit [lsearch $sciFLTEditorTable($idx,$io,tidx) $idxio]
			if {$io==output} then {
				set pit [expr $pit+[llength $sciFLTEditorTable($idx,input,tidx]]
			}
		}
	}
}


# ------------------------------------------------------------------------------------------------------------------
# SCROLL THE X AXES
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorDrawVarEditScrollX { {c1 ""} {c2 ""} { c3 "" } } {
	global sciFLTEditorTable
	set w $sciFLTEditorTable(winname).center.right.varedit.mf.t
	if { $c3!= "" } {
		catch { $w.mes xview $c1 $c2 $c3 }
		catch {	$w.canv xview $c1 $c2 $c3 }
	} else {
		catch { $w.mes xview $c1 $c2 }
		catch { $w.canv xview $c1 $c2 }
	}	
}

# ------------------------------------------------------------------------------------------------------------------
# DRAW VARIABLE EDITION
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorDrawVarEdit { idx io idxio } {
	global sciFLTEditorTable
	if { $sciFLTEditorTable(curright)!="" } then {
		destroy $sciFLTEditorTable(curright)
	}
	if { $sciFLTEditorTable($idx,type)=="m" | $io=="input" } then {
		set mf_values { trimf trapmf gaussmf gauss2mf sigmf psigmf dsigmf smf zmf pimf }
		set deftyp trimf
		set defpar "0.0 0.0 0.0"
	} else {
		set mf_values { constant linear }
		set deftyp constant
		set defpar 0.0
	}
	set w $sciFLTEditorTable(winname).center.right.varedit
	labelframe $w -text "EDIT VARIABLE : "
	labelframe $w.info -text "Information : " -fg blue
	label $w.info.l_varname -text "name :"
	label $w.info.l_varrange -text "range :"
	label $w.info.l_nmf -text "Nro. Member Function :"
	entry $w.info.varname -textvariable sciFLTEditorTable($idx,$io,$idxio,name)
	entry $w.info.varrange -textvariable sciFLTEditorTable($idx,$io,$idxio,range)
	label $w.info.nmf -text [expr [llength $sciFLTEditorTable($idx,$io,$idxio,mf,tidx)]+0] -relief sunken
	
	grid config $w.info.l_varname  -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "w" -pady 2 -sticky "e"
	grid config $w.info.varname    -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "e" -pady 2 -sticky "nsew"
	grid config $w.info.l_varrange -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky "w" -pady 2 -sticky "e"
	grid config $w.info.varrange   -column 1 -row 1 -columnspan 1 -rowspan 1 -sticky "e" -pady 2 -sticky "nsew"
	grid config $w.info.l_nmf      -column 0 -row 2 -columnspan 1 -rowspan 1 -sticky "w" -pady 2 -sticky "e"
	grid config $w.info.nmf        -column 1 -row 2 -columnspan 1 -rowspan 1 -sticky "e" -pady 2 -sticky "w"
	grid columnconfigure $w.info 1 -weight 50

	labelframe $w.mf -text "Member functions:" -fg blue
	frame $w.mf.t
	canvas $w.mf.t.mes -width 1 -height 20 -bg lightyellow
	canvas $w.mf.t.canv -width 1 -height 1 -yscrollcommand "$w.mf.t.sby set" -xscrollcommand "$w.mf.t.sbx set"
	scrollbar $w.mf.t.sby -orient vertical -command "$w.mf.t.canv yview"
	scrollbar $w.mf.t.sbx -orient horizontal -command "sciFLTEditorDrawVarEditScrollX"
	grid config $w.mf.t.mes  -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "nsew"
	grid config $w.mf.t.canv -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky "nsew"
	grid config $w.mf.t.sby  -column 1 -row 1 -columnspan 1 -rowspan 1 -sticky "ns"
	grid config $w.mf.t.sbx  -column 0 -row 2 -columnspan 1 -rowspan 1 -sticky "ew"
	grid rowconfigure $w.mf.t 0 -weight 0
	grid rowconfigure $w.mf.t 1 -weight 50
	grid columnconfigure $w.mf.t 0 -weight 50

	frame $w.mf.b
	button $w.mf.b.add -text "Add" -width 20 -command "sciFLTEditorNewMF $idx $io $idxio newmf \"$deftyp\" \"$defpar\";sciFLTEditorDrawVarEdit $idx $io $idxio"
	button $w.mf.b.del -text "Delete (checked)" -width 20  -command "sciFLTEditorDrawVarEditDelMf $idx $io $idxio;sciFLTEditorDrawVarEdit $idx $io $idxio"
	pack $w.mf.b.add $w.mf.b.del -side left -padx 5 -pady 3
	
	pack $w.mf.t -side top -fill both -expand 1
	pack $w.mf.b -side bottom -fill both -expand 0

	pack $w.info -side top -fill x -expand 0 -padx 2 -pady 2
	pack $w.mf -side top -fill both -expand 1 -padx 2 -pady 2
	pack $w -side top -fill both -expand 1 -padx 2 -pady 2
	# HERE IS THE ALGORITHM	
	set sciFLTEditorTable(mfw,is_set) 0
	set sciFLTEditorTable(mfw,todel)  0
	set sciFLTEditorTable(mfw,name)   50
	set sciFLTEditorTable(mfw,type)   200
	set sciFLTEditorTable(mfw,par)    300
	set Yof 0
	if { $sciFLTEditorTable(mfw,is_set)==0 } then {	
		# LET'S CREATE A DEFAUL VALUES
		$w.mf.t.canv delete all
		checkbutton $w.mf.t.canv.todeld -relief flat
		entry $w.mf.t.canv.named -width 15
		spinbox $w.mf.t.canv.typed -width 10 -state readonly
		$w.mf.t.canv create window 0 0 -window $w.mf.t.canv.todeld -anchor w
		set bb [$w.mf.t.canv bbox all]
		set sciFLTEditorTable(mfw,name) [expr [lindex $bb 2]+0]

		$w.mf.t.canv create window $sciFLTEditorTable(mfw,name) 0 -window $w.mf.t.canv.named -anchor w
		set bb [$w.mf.t.canv bbox all]
		set sciFLTEditorTable(mfw,type) [expr [lindex $bb 2]+2]

		$w.mf.t.canv create window $sciFLTEditorTable(mfw,type) 0 -window $w.mf.t.canv.typed -anchor w
		set bb [$w.mf.t.canv bbox all]
		set sciFLTEditorTable(mfw,par) [expr [lindex $bb 2]+2]

		$w.mf.t.canv delete all
	}
	$w.mf.t.mes create text $sciFLTEditorTable(mfw,name)  10 -text " name :" -anchor w -fill blue
	$w.mf.t.mes create text $sciFLTEditorTable(mfw,type)  10 -text " type :" -anchor w -fill blue
	$w.mf.t.mes create text $sciFLTEditorTable(mfw,par)   10 -text " par :"  -anchor w -fill blue
	foreach idxmf $sciFLTEditorTable($idx,$io,$idxio,mf,tidx) {
		set y [expr $Yof*20+2]
		incr Yof	
		set x $sciFLTEditorTable(mfw,todel)
		checkbutton $w.mf.t.canv.todel$Yof -relief flat -variable sciFLTEditorTable($idx,$io,$idxio,mf,$idxmf,todel)
		$w.mf.t.canv create window $x $y -window $w.mf.t.canv.todel$Yof -anchor w
		set x $sciFLTEditorTable(mfw,name)
		entry $w.mf.t.canv.name$Yof -width 15 -textvariable sciFLTEditorTable($idx,$io,$idxio,mf,$idxmf,name)
		$w.mf.t.canv create window $x $y -window $w.mf.t.canv.name$Yof -anchor w
		set x $sciFLTEditorTable(mfw,type)		
		#------------------------------------------------------------------
		# HEY! MAYBE THIS CAN BE MADE IN ANOTHER WAY OR IS A BUG ?
		# I NEED TO SETUP THE VARIABLE TO SEE THE VALUE ?
		set oldvalue $sciFLTEditorTable($idx,$io,$idxio,mf,$idxmf,type)
		spinbox $w.mf.t.canv.type$Yof -values $mf_values -width 10 -textvariable sciFLTEditorTable($idx,$io,$idxio,mf,$idxmf,type) -state readonly
		set  sciFLTEditorTable($idx,$io,$idxio,mf,$idxmf,type) $oldvalue
		#------------------------------------------------------------------
		$w.mf.t.canv create window $x $y -window $w.mf.t.canv.type$Yof -anchor w
		set x $sciFLTEditorTable(mfw,par)
		entry $w.mf.t.canv.par$Yof -width 40 -textvariable sciFLTEditorTable($idx,$io,$idxio,mf,$idxmf,par)
		$w.mf.t.canv create window $x $y -window $w.mf.t.canv.par$Yof -anchor w
		
	}
	set cnv [$w.mf.t.canv bbox all]
	catch { $w.mf.t.canv config -scrollregion $cnv }
	set cnv2 [lreplace $cnv 3 3 20]
	catch { $w.mf.t.mes  config -scrollregion $cnv2 }
	
	set sciFLTEditorTable(curright) $w

}


# ------------------------------------------------------------------------------------------------------------------
# DISPLAY RULES
# ------------------------------------------------------------------------------------------------------------------

proc sciFLTEditorEditRuleParse { idx } {
	global sciFLTEditorTable
	set w $sciFLTEditorTable(winname).center.right.ruledit.top.text
	$w configure -state normal
	$w delete 1.0 end
	set nrule 0
	set ninputs [llength $sciFLTEditorTable($idx,input,tidx)]
	set noutputs [llength $sciFLTEditorTable($idx,output,tidx)]
	foreach idxrule $sciFLTEditorTable($idx,rule,tidx) {
		incr nrule		
		set toput $sciFLTEditorTable($idx,rule,$idxrule)
		# IN TK/TCK THE FIRST ELEMENT IS 0 !!!
		set weigth [expr [lindex $toput [expr $ninputs+$noutputs+1]]+0]
		if { [expr [lindex $toput [expr $ninputs+$noutputs]]+0] } then {
			set conector "AND"
			set andor 1		
		} else {
			set conector "OR"			
			set andor 0
		}
		set corr 0

		# IF PART
		set txtrule "R$nrule: IF"
		set putcon 0
		set tidxio -1
		foreach idxio $sciFLTEditorTable($idx,input,tidx) {
			incr tidxio
			incr corr
			
			set n1 "$sciFLTEditorTable($idx,input,$idxio,name)"
			set mfidx [lindex $sciFLTEditorTable($idx,rule,$idxrule) $tidxio]
			if { $mfidx>0 } then {
				set iscomp 0
				set p1 [expr $mfidx-1]
				set tq [lindex $sciFLTEditorTable($idx,input,$idxio,mf,tidx) $p1]
				set n3 $sciFLTEditorTable($idx,input,$idxio,mf,$tq,name)				
				set n2 "IS"
				set putit 1
			} elseif { $mfidx<0 } then {
				set iscomp 1
				set p1 [expr -$mfidx-1]
				set tq [lindex $sciFLTEditorTable($idx,input,$idxio,mf,tidx) $p1]
				set n3 $sciFLTEditorTable($idx,input,$idxio,mf,$tq,name)
				set n2 "ISN'T"
				set putit 1
			} else {
				set p1 -1
				set n3 "----"			
				set putit 0
				set iscomp 0
			}
			if { $nrule==$sciFLTEditorTable(mfw,currule) } then {
					set sciFLTEditorTable(mfw,$corr,value) "([expr $p1+1]) $n3"
					set sciFLTEditorTable(mfw,$corr,comp) $iscomp
					
			}

			if { $putit } then {
				if { $putcon } then {
					lappend txtrule $conector
				}
				lappend txtrule "$n1 $n2 $n3"
				set putcon 1
			}
		}

		# THEN PART
		lappend txtrule "THEN"
		#set tidxio -1
		foreach idxio $sciFLTEditorTable($idx,output,tidx) {
			incr tidxio
			incr corr			
			set n1 "$sciFLTEditorTable($idx,output,$idxio,name)"
			set mfidx [expr [lindex $sciFLTEditorTable($idx,rule,$idxrule) $tidxio]+0]
			if { $mfidx>0 } then {				
				set iscomp 0
				set p1 [expr $mfidx-1]
				set tq [lindex $sciFLTEditorTable($idx,output,$idxio,mf,tidx) $p1]
				set n3 $sciFLTEditorTable($idx,output,$idxio,mf,$tq,name)
				set n2 "IS"
				set putit 1
			} elseif { $mfidx<0 } then {				
				set iscomp 1
				set p1 [expr -$mfidx-1]
				set tq [lindex $sciFLTEditorTable($idx,output,$idxio,mf,tidx) $p1]
				set n3 $sciFLTEditorTable($idx,output,$idxio,mf,$tq,name)
				set n2 "ISN'T"
				set putit 1
			} else {
				set p1 -1
				set n3 "----"
				set putit 0
			}

			if { $nrule==$sciFLTEditorTable(mfw,currule) } then {
					set sciFLTEditorTable(mfw,$corr,value) "([expr $p1+1]) $n3"
					set sciFLTEditorTable(mfw,$corr,comp) $iscomp
					
			}

			if { $putit } then {
				lappend txtrule "$n1 $n2 $n3"
			}
		}
		
		lappend txtrule "weigth=$weigth"
		
		
		$w insert end "$txtrule\n" trul$nrule
		if { $nrule==$sciFLTEditorTable(mfw,currule) } then {
			$w tag configure trul$nrule -background yellow
			set sciFLTEditorTable(mfw,weigth) $weigth
			set sciFLTEditorTable(mfw,andor) $andor
		} else {
			$w tag configure trul$nrule -background {}
		}
		
		$w tag bind trul$nrule <1> "set sciFLTEditorTable(mfw,currule) $nrule;sciFLTEditorEditRuleParse $idx"	
	}
	
	
	$w configure -state disabled
}


# ------------------------------------------------------------------------------------------------------------------
# DRAW THE RULE CHOOSER
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorEditRuleDrawChoose { idx } {
	global sciFLTEditorTable
	set w $sciFLTEditorTable(winname).center.right.ruledit.center.canvas	
	set ninputs [llength $sciFLTEditorTable($idx,input,tidx)]
	set noutputs [llength $sciFLTEditorTable($idx,output,tidx)]
	set corr 1
	foreach io { input output } {
		if { $io=="input" } then {
			set fillcol blue
			$w create text   0 0 -text "IF" -fill $fillcol -anchor sw		
		} else {
			set bb [$w bbox all]
			set x [expr [lindex $bb 2]+20]
			set fillcol purple 
			$w create text   $x 0 -text "THEN" -fill $fillcol -anchor sw
			
		}
		foreach idxio $sciFLTEditorTable($idx,$io,tidx) {
			set values { "(0) ----" }
			set ij 1
			foreach idxmf $sciFLTEditorTable($idx,$io,$idxio,mf,tidx) {
				set mm "($ij) $sciFLTEditorTable($idx,$io,$idxio,mf,$idxmf,name)"
				lappend values $mm
				incr ij
			}
			set sciFLTEditorTable(mfw,$corr,value) ""
			set sciFLTEditorTable(mfw,$corr,value) 0
			spinbox $w.io$corr -values $values -width 15 -fg $fillcol -textvariable sciFLTEditorTable(mfw,$corr,value) -state readonly
			checkbutton $w.ioc$corr -text "not" -relief flat -fg $fillcol -variable sciFLTEditorTable(mfw,$corr,comp)
			set bb [$w bbox all]
			set x [expr [lindex $bb 2]+10]
			set y 0
			$w create text   $x $y -text "$sciFLTEditorTable($idx,$io,$idxio,name) is:" -anchor nw -fill $fillcol
			set y 15
			$w create window $x $y -window $w.io$corr -anchor nw

			set y 35
			$w create window $x $y -window $w.ioc$corr -anchor nw		
			incr corr
		}
	}
	set bb [$w bbox all]
	set y [expr [lindex $bb 3]+5]
	radiobutton $w.isAnd -text "AND" -variable sciFLTEditorTable(mfw,andor) -value 1
	radiobutton $w.isOr  -text "OR"  -variable sciFLTEditorTable(mfw,andor) -value 0
	set sciFLTEditorTable(mfw,andor) 1
	entry $w.wei -width 10 -textvariable sciFLTEditorTable(mfw,weigth)
	set sciFLTEditorTable(mfw,weigth) 1.0
	$w create window 0 $y -window $w.isAnd -anchor nw
	$w create window 0 [expr $y+15] -window $w.isOr -anchor nw
	$w create text   80 $y -text "Weight" -anchor nw
	$w create window 80 [expr $y+15] -window $w.wei -anchor nw

	set bb [$w bbox all]
	set hei [expr [lindex $bb 3]-[lindex $bb 1]]
	$w configure -height $hei
	$w configure -scrollregion [$w bbox all]
       
}


# ------------------------------------------------------------------------------------------------------------------
# DELETE A RULE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorEditRuleDel { idx } {
	global sciFLTEditorTable
	if { $sciFLTEditorTable(mfw,currule)>0 } then {
		set tr [expr $sciFLTEditorTable(mfw,currule)]
		set nv ""
		set cr 1
		foreach iq $sciFLTEditorTable($idx,rule,tidx) {
			if { $cr!=$tr } then {
				lappend nv $iq
			}
			incr cr
		}
		set sciFLTEditorTable($idx,rule,tidx) $nv
		set mr [ llength sciFLTEditorTable($idx,rule,tidx) ]
		if { $mr<$sciFLTEditorTable(mfw,currule) } then {
			set sciFLTEditorTable(mfw,currule) $mr
		}
		sciFLTEditorEditRuleParse $idx	
	}
}

# ------------------------------------------------------------------------------------------------------------------
# CHANGE RULE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorEditRuleChg { idx } {
	global sciFLTEditorTable
	set nrule1 [expr [llength $sciFLTEditorTable($idx,rule,tidx)] +1 ]
	set nrule2 [expr [lindex $sciFLTEditorTable($idx,rule,tidx) end] +1 ]
	set nin [llength $sciFLTEditorTable($idx,input,tidx)]
	set nou [llength $sciFLTEditorTable($idx,output,tidx)]
	set tt [expr $nin+$nou]
	
	set sciFLTEditorTable($idx,rule,$nrule2) ""
	for { set corr 1 } { $corr<=$tt } { incr corr } {	
		set li [string first ")" "$sciFLTEditorTable(mfw,$corr,value)"]
		set value [string range "$sciFLTEditorTable(mfw,$corr,value)" 1 [expr $li-1]]
		if { $sciFLTEditorTable(mfw,$corr,comp) } then {
			set value -$value
		}
		lappend sciFLTEditorTable($idx,rule,$nrule2) $value
	}
	lappend sciFLTEditorTable($idx,rule,$nrule2) [expr $sciFLTEditorTable(mfw,andor)+0]
	lappend sciFLTEditorTable($idx,rule,$nrule2) [expr $sciFLTEditorTable(mfw,weigth)+0]
	set sciFLTEditorTable(mfw,currule) $nrule1
	
	lappend sciFLTEditorTable($idx,rule,tidx) $nrule2

	sciFLTEditorEditRuleParse $idx
	
}

# ------------------------------------------------------------------------------------------------------------------
# ADD RULE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorEditRuleAdd { idx } {
	global sciFLTEditorTable
	set nrule1 [expr [llength $sciFLTEditorTable($idx,rule,tidx)] +1 ]
	set nrule2 [expr [lindex $sciFLTEditorTable($idx,rule,tidx) end] +1 ]
	set nin [llength $sciFLTEditorTable($idx,input,tidx)]
	set nou [llength $sciFLTEditorTable($idx,output,tidx)]
	set tt [expr $nin+$nou]
	
	set sciFLTEditorTable($idx,rule,$nrule2) ""
	for { set corr 1 } { $corr<=$tt } { incr corr } {	
		set li [string first ")" "$sciFLTEditorTable(mfw,$corr,value)"]
		set value [string range "$sciFLTEditorTable(mfw,$corr,value)" 1 [expr $li-1]]
		if { $sciFLTEditorTable(mfw,$corr,comp) } then {
			set value -$value
		}
		lappend sciFLTEditorTable($idx,rule,$nrule2) $value
	}
	lappend sciFLTEditorTable($idx,rule,$nrule2) [expr $sciFLTEditorTable(mfw,andor)+0]
	lappend sciFLTEditorTable($idx,rule,$nrule2) [expr $sciFLTEditorTable(mfw,weigth)+0]
	set sciFLTEditorTable(mfw,currule) $nrule1
	
	lappend sciFLTEditorTable($idx,rule,tidx) $nrule2

	sciFLTEditorEditRuleParse $idx
	
}
# ------------------------------------------------------------------------------------------------------------------
# EDIT RULES
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorEditRule { idx } {
	global sciFLTEditorTable
	if { $sciFLTEditorTable(curright)!="" } then {
		destroy $sciFLTEditorTable(curright)
	}

	set w $sciFLTEditorTable(winname).center.right.ruledit
	labelframe $w -text "RULE EDITION"
	frame $w.top
	text $w.top.text -xscrollcommand "$w.top.sbx set" -yscrollcommand "$w.top.sby set" -width 1 -height 1 -wrap none -cursor arrow
	scrollbar $w.top.sbx -command "$w.top.text xview" -orient horizontal
	scrollbar $w.top.sby -command "$w.top.text yview" -orient vertical
	grid config $w.top.text -column 0 -row 0 -columnspan 1 -rowspan 1 -sticky "nsew"
	grid config $w.top.sby  -column 1 -row 0 -columnspan 1 -rowspan 1 -sticky "ns"
	grid config $w.top.sbx  -column 0 -row 1 -columnspan 1 -rowspan 1 -sticky "ew"
	grid columnconfigure $w.top 0 -weight 50
	grid columnconfigure $w.top 1 -weight 0
	grid rowconfigure    $w.top 0 -weight 50
	grid rowconfigure    $w.top 1 -weight 0
	
	frame     $w.center
	canvas    $w.center.canvas -width 1 -height 100 -xscrollcommand "$w.center.sbx set"
	scrollbar $w.center.sbx -command "$w.center.canvas xview" -orient horizontal
	pack $w.center.canvas -side top -fill both -expand 1
	pack $w.center.sbx    -side top -fill x    -expand 1

	set nin [llength $sciFLTEditorTable($idx,input,tidx)]
	set nou [llength $sciFLTEditorTable($idx,output,tidx)]

	if { [expr $nin*$nou]>0 } then {
		set cst normal
	} else {
		set cst disabled
	}

	frame $w.bottom
	button $w.bottom.delete -text "Delete rule" -width 15 -state $cst -command "sciFLTEditorEditRuleDel $idx"
	button $w.bottom.add    -text "Add rule"    -width 15 -state $cst -command "sciFLTEditorEditRuleAdd $idx"
	button $w.bottom.change -text "Change rule" -width 15 -state $cst -command "sciFLTEditorEditRuleChg $idx"	
	pack $w.bottom.delete $w.bottom.add $w.bottom.change -side left -padx 3 -fill x -pady 2 -expand 0

	sciFLTEditorEditRuleDrawChoose $idx
	set sciFLTEditorTable(mfw,currule) 0

	sciFLTEditorEditRuleParse $idx

	pack $w.top    -side top -expand 1 -fill both
	pack $w.center -side top -expand 0 -fill both -pady 5
	pack $w.bottom -side top -expand 0 -fill both
	pack $w -side top -expand 1 -fill both

	set sciFLTEditorTable(curright) $w	
}



# ------------------------------------------------------------------------------------------------------------------
# CHANGE THE STATE IN THE TREE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorTreeChange { whois idx } {
	global sciFLTEditorTable
	if { $whois=="1" } {
		set newstatus 1
		if { $sciFLTEditorTable($idx,fls_is_open) } {
			set newstatus 0
		}
		set sciFLTEditorTable($idx,fls_is_open) $newstatus
		sciFLTEditorDrawTree
	}

	if { $whois=="2" } {
		set newstatus 1
		if { $sciFLTEditorTable($idx,input,is_open) } {
			set newstatus 0
		}
		set sciFLTEditorTable($idx,input,is_open) $newstatus
		sciFLTEditorDrawTree
	}

	if { $whois=="3" } {
		set newstatus 1
		if { $sciFLTEditorTable($idx,output,is_open) } {
			set newstatus 0
		}
		set sciFLTEditorTable($idx,output,is_open) $newstatus
		sciFLTEditorDrawTree
	}
}

# ------------------------------------------------------------------------------------------------------------------
# DRAW THE TREE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorDrawTree { } {
	global sciFLTEditorTable
	set menustate disabled
	set w $sciFLTEditorTable(winname).center.left.canvas
	$w delete all
	set yLocal 0
	set x00 0
	set x01 10
	set x02 30
	
	set x10 10
	set x11 20
	set x12 40

	set x20 20
	set x21 40

	foreach idx $sciFLTEditorTable(fls_tidx) {
		set menustate active
		set y [expr 15+18*$yLocal];incr yLocal
		if { $sciFLTEditorTable($idx,fls_is_open)==1 } then {
			set isopen 1
			set k0 [$w create image $x00 $y -image sciFLTEditorTable(icon_minus) -anchor w]
		} else {
			set isopen 0
			set k0 [$w create image $x00 $y -image sciFLTEditorTable(icon_plus) -anchor w]
		}
		set k1 [$w create image $x01 $y -image sciFLTEditorTable(icon_fls) -anchor w]
		set fill_color blue
		if { $sciFLTEditorTable(curIdx)=="$idx 0 0" } then {
			set fill_color red
			sciFLTEditorDrawInformation $idx
		}
		set k2 [$w create text  $x02 $y -text "$sciFLTEditorTable($idx,name)" -anchor w -fill $fill_color]
		set bcom "set sciFLTEditorTable(curIdx) {$idx 0 0};sciFLTEditorTreeChange 1 $idx"
		set bcom2 "set sciFLTEditorTable(curIdx) {$idx 0 0};sciFLTEditorDrawTree"
		$w bind $k0 <1> $bcom
		$w bind $k1 <1> $bcom2
		$w bind $k2 <1> $bcom2
		if { $isopen==1 } then {
			# DESCRIPTION
			set y [expr 15+18*$yLocal];incr yLocal
			set k1 [$w create image $x11 $y -image sciFLTEditorTable(icon_description) -anchor w]
			set fill_color blue
			if { $sciFLTEditorTable(curIdx)=="$idx 1 0" } then {
				set fill_color red
				sciFLTEditorDrawOptions $idx				
			}
			set k2 [$w create text $x12 $y -text "Description" -anchor w -fill $fill_color]
			set bcom "set sciFLTEditorTable(curIdx) {$idx 1 0};sciFLTEditorDrawTree"
			$w bind $k1 <1> $bcom
			$w bind $k2 <1> $bcom

			# INPUTS
			set y [expr 15+18*$yLocal];incr yLocal
			if { $sciFLTEditorTable($idx,input,is_open)==1 } then {
				set isopen_1 1
				set k0 [$w create image $x10 $y -image sciFLTEditorTable(icon_minus) -anchor w]
				
			} else {
				set isopen_1 0
				set k0 [$w create image $x10 $y -image sciFLTEditorTable(icon_plus) -anchor w]
			}
			set fill_color blue
			if { $sciFLTEditorTable(curIdx)=="$idx 2 0" } then {
				set fill_color red
				sciFLTEditorDrawVarInfo $idx input
			}
			set k1 [$w create image $x11 $y -image sciFLTEditorTable(icon_input) -anchor w]
			set k2 [$w create text  $x12 $y -text "Inputs" -anchor w -fill $fill_color]
			set bcom "set sciFLTEditorTable(curIdx) {$idx 2 0};sciFLTEditorTreeChange 2 $idx"
			set bcom2 "set sciFLTEditorTable(curIdx) {$idx 2 0};sciFLTEditorDrawTree"
			$w bind $k0 <1> $bcom
			$w bind $k1 <1> $bcom2
			$w bind $k2 <1> $bcom2

			if { $isopen_1==1 } then {
				foreach h $sciFLTEditorTable($idx,input,tidx) {
					set y [expr 15+18*$yLocal];incr yLocal
					set k0 [$w create image $x20 $y -image sciFLTEditorTable(icon_input_var) -anchor w]
					set fill_color blue
					if { $sciFLTEditorTable(curIdx)=="$idx 2 $h" } then {
						set fill_color red
						sciFLTEditorDrawVarEdit $idx input $h					
					}	
					set k1 [$w create text  $x21 $y -text $sciFLTEditorTable($idx,input,$h,name) -anchor w -fill $fill_color]
					set bcom "set sciFLTEditorTable(curIdx) {$idx 2 $h};sciFLTEditorDrawTree"
					$w bind $k0 <1> $bcom
					$w bind $k1 <1> $bcom
				}
			}

			# OUTPUTS
			set y [expr 15+18*$yLocal];incr yLocal
			if { $sciFLTEditorTable($idx,output,is_open)==1 } then {
				set isopen_1 1
				set k0 [$w create image $x10 $y -image sciFLTEditorTable(icon_minus) -anchor w]
				
			} else {
				set isopen_1 0
				set k0 [$w create image $x10 $y -image sciFLTEditorTable(icon_plus) -anchor w]
			}
			set fill_color blue
			if { $sciFLTEditorTable(curIdx)=="$idx 3 0" } then {
				set fill_color red
				sciFLTEditorDrawVarInfo $idx output
			}
			set k1 [$w create image $x11 $y -image sciFLTEditorTable(icon_output) -anchor w]
			set k2 [$w create text  $x12 $y -text "Outputs" -anchor w -fill $fill_color]
			set bcom "set sciFLTEditorTable(curIdx) {$idx 3 0};sciFLTEditorTreeChange 3 $idx"
			set bcom2 "set sciFLTEditorTable(curIdx) {$idx 3 0};sciFLTEditorDrawTree"
			$w bind $k0 <1> $bcom
			$w bind $k1 <1> $bcom2
			$w bind $k2 <1> $bcom2

			if { $isopen_1==1 } then {
				foreach h $sciFLTEditorTable($idx,output,tidx) {
					set y [expr 15+18*$yLocal];incr yLocal
					set k0 [$w create image $x20 $y -image sciFLTEditorTable(icon_output_var) -anchor w]
					set fill_color blue
					if { $sciFLTEditorTable(curIdx)=="$idx 3 $h" } then {
						set fill_color red
						sciFLTEditorDrawVarEdit $idx output $h
					}	
					set k1 [$w create text  $x21 $y -text $sciFLTEditorTable($idx,output,$h,name) -anchor w -fill $fill_color]
					set bcom "set sciFLTEditorTable(curIdx) {$idx 3 $h};sciFLTEditorDrawTree"
					$w bind $k0 <1> $bcom
					$w bind $k1 <1> $bcom
				}
			}
			
			#RULES
			set y [expr 15+18*$yLocal];incr yLocal
			set k1 [$w create image $x11 $y -image sciFLTEditorTable(icon_rules) -anchor w]
			set fill_color blue
			if { $sciFLTEditorTable(curIdx)=="$idx 4 0" } then {
				set fill_color red
				sciFLTEditorEditRule $idx
			}
			set k2 [$w create text $x12 $y -text "Rules" -anchor w -fill $fill_color]
			set bcom "set sciFLTEditorTable(curIdx) {$idx 4 0};sciFLTEditorDrawTree"
			$w bind $k1 <1> $bcom
			$w bind $k2 <1> $bcom			
		}
	}

	# UPDATE TE BOUDING BOX
	$w config -scrollregion [$w bbox all]

	# 2004-10-07 Fix bug
	if { [llength $sciFLTEditorTable(fls_tidx)]==0 } then { sciFLTEditorEditBlank }

}


# ------------------------------------------------------------------------------------------------------------------
# CREATE A NEW STRUCTURE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorNewFls { type } {
	global sciFLTEditorTable
	set idx [expr [lindex $sciFLTEditorTable(fls_tidx) end]+1]
	lappend sciFLTEditorTable(fls_tidx) $idx
	set sciFLTEditorTable($idx,fls_is_open) 0
	set sciFLTEditorTable($idx,mesbar) "New"
	set sciFLTEditorTable($idx,name) "NewName"
	set sciFLTEditorTable($idx,comment) "NewComment"
	set sciFLTEditorTable($idx,type) $type
	set sciFLTEditorTable($idx,snormpar) 0
	set sciFLTEditorTable($idx,tnormpar) 0
	set sciFLTEditorTable($idx,comp) "one"
	set sciFLTEditorTable($idx,comppar) 0
	if { $type=="ts" } then {
		set sciFLTEditorTable($idx,defuzzmethod) "wtsum"
		set sciFLTEditorTable($idx,snorm) "asum"		
		set sciFLTEditorTable($idx,tnorm) "aprod"
		set sciFLTEditorTable($idx,impmethod) "prod"
		set sciFLTEditorTable($idx,aggmethod) "max"
		
	} else {
		set sciFLTEditorTable($idx,defuzzmethod) "centroide"
		set sciFLTEditorTable($idx,snorm) "max"
		set sciFLTEditorTable($idx,tnorm) "min"
		set sciFLTEditorTable($idx,impmethod) "min"
		set sciFLTEditorTable($idx,aggmethod) "max"
	}	
	set sciFLTEditorTable($idx,input,is_open) 0
	set sciFLTEditorTable($idx,input,tidx) ""	
	set sciFLTEditorTable($idx,output,is_open) 0
	set sciFLTEditorTable($idx,output,tidx) ""	
	set sciFLTEditorTable($idx,rule,tidx) ""
}

# ------------------------------------------------------------------------------------------------------------------
# DELETE FLS IN MEMORY
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorDelFls { } {
	global sciFLTEditorTable
	set parent $sciFLTEditorTable(winname)
	if { $sciFLTEditorTable(curIdx)!="" } then {
		set idx [lindex $sciFLTEditorTable(curIdx) 0]
		set flsname $sciFLTEditorTable($idx,name)
		set mes "DELETE THE STRUCTURE:\n$flsname"
		set answer [tk_messageBox -title "Delete structure" -type yesno -message $mes -parent $parent -icon question]
		if { $answer=="yes" } then {
			set li [lsearch -exact "$sciFLTEditorTable(fls_tidx)" $idx]
			if { $li>-1 } then {
				set sciFLTEditorTable(fls_tidx) [lreplace $sciFLTEditorTable(fls_tidx) $li $li]
				set sciFLTEditorTable(curIdx) ""
				sciFLTEditorDrawTree
				# 2004-10-07 Bug Fix
				sciFLTEditorEditBlank
			}
		}
	}
}

# ------------------------------------------------------------------------------------------------------------------
# ADD A NEW VARIABLE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorNewVar { idx io {name "var_name"} {range "0 0"}} {
	global sciFLTEditorTable
	set h [expr [lindex $sciFLTEditorTable($idx,$io,tidx) end]+1]
	lappend sciFLTEditorTable($idx,$io,tidx) $h
	set sciFLTEditorTable($idx,$io,$h,name) $name
	set sciFLTEditorTable($idx,$io,$h,range) $range
	set sciFLTEditorTable($idx,$io,$h,mf,tidx) ""
}

# ------------------------------------------------------------------------------------------------------------------
# DELETE VARIABLE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorDelVar { } {
	global sciFLTEditorTable
	set mes "DELETE THE VARIABLE:\n$sciFLTEditorTable(curVarToAction)\nThis action also make changes over the rules (if is required). "
	set parent $sciFLTEditorTable(winname)
	set answer [tk_messageBox -title "Delete Variable" -type yesno -message $mes -parent $parent -icon question]
	if { $answer=="yes" } then {
		set idx [lindex $sciFLTEditorTable(curIdx) 0]
		if { [lindex $sciFLTEditorTable(curIdx) 1]=="2" } then {
			set io input
		} else {
			set io output
		}
		set li [string first ")" "$sciFLTEditorTable(curVarToAction)"]
		set pt [expr [string range "$sciFLTEditorTable(curVarToAction)" 1 [expr $li-1]]-1]
		set sciFLTEditorTable($idx,$io,tidx) [lreplace $sciFLTEditorTable($idx,$io,tidx) $pt $pt]
		if { $io=="output" } then {
			set pt [expr $pi+[llength $sciFLTEditorTable($idx,input,tidx)]]
		}
	
		foreach iq $sciFLTEditorTable($idx,rule,tidx) {
			set sciFLTEditorTable($idx,rule,$iq) [lreplace $sciFLTEditorTable($idx,rule,$iq) $pt $pt]
		}
		sciFLTEditorDrawTree
	}
}

# ------------------------------------------------------------------------------------------------------------------
# EDIT VARIABLE AND MEMBER FUNCTIONS
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorEdiVar { } {
	global sciFLTEditorTable
	set li [string first ")" "$sciFLTEditorTable(curVarToAction)"]
	set pt [expr [string range "$sciFLTEditorTable(curVarToAction)" 1 [expr $li-1]]-1]
	set idx [lindex $sciFLTEditorTable(curIdx) 0]
	if { [lindex $sciFLTEditorTable(curIdx) 1]=="2" } then {
		set io input
		set m1 2
	} else {
		set io output
		set m1 3
	}
	set li [string first ")" "$sciFLTEditorTable(curVarToAction)"]
	set pt [expr [string range "$sciFLTEditorTable(curVarToAction)" 1 [expr $li-1]]-1]
	set idxio [lindex $sciFLTEditorTable($idx,$io,tidx) $pt]
	set sciFLTEditorTable(curIdx) "$idx $m1 $idxio"
	set sciFLTEditorTable($idx,$io,is_open) 1
	sciFLTEditorDrawTree
}

# ------------------------------------------------------------------------------------------------------------------
# ADD A NEW MEMBER FUNCTION
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorNewMF { idx io idxio {name "" } {type ""} {par ""} } {
	global sciFLTEditorTable
	set h [expr [lindex $sciFLTEditorTable($idx,$io,$idxio,mf,tidx) end]+1]
	lappend sciFLTEditorTable($idx,$io,$idxio,mf,tidx) $h
	set sciFLTEditorTable($idx,$io,$idxio,mf,$h,name) $name
	set sciFLTEditorTable($idx,$io,$idxio,mf,$h,type) $type
	set sciFLTEditorTable($idx,$io,$idxio,mf,$h,par) $par
	set sciFLTEditorTable($idx,$io,$idxio,mf,$h,todel) 0
}


# ------------------------------------------------------------------------------------------------------------------
# SAVE DIALOG
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorSaveCurrent { } {
	global sciFLTEditorTable
	set types {{"Scilab fls structure" .fls}}
	if { $sciFLTEditorTable(curIdx)!="" } then {
		set file_to_save [tk_getSaveFile -filetypes $types -parent $sciFLTEditorTable(winname)]
		if { $file_to_save!="" } then {
			set idx [lindex $sciFLTEditorTable(curIdx) 0]
			sciFLTEditorSaveFLS "$file_to_save" $idx
		}
	}
}

# ------------------------------------------------------------------------------------------------------------------
# SAVE FLS STRUCTURE TO FILE .FLS
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorSaveFLS { filename idx } {
	global sciFLTEditorTable
	set fid [open $filename w]
	puts $fid "# sciFLT scilab Fuzzy Logic Toolbox"
	puts $fid "<REVISION>"
	puts $fid " <revision>@REV@"
	puts $fid ""
	puts $fid "<DESCRIPTION>"
	foreach tp { "name" "comment" "type" "SNorm" "SNormPar" "TNorm" "TNormPar" "Comp" "CompPar" "ImpMethod" "AggMethod" "defuzzMethod"} {
		set value $sciFLTEditorTable($idx,[string tolower $tp])
		puts $fid " <$tp>$value"
	}
	puts $fid ""
	foreach io { "INPUT" "OUTPUT" } {
		puts $fid "<$io>"
		set io [string tolower $io]
		foreach idxio $sciFLTEditorTable($idx,$io,tidx) {
			puts $fid " <name>$sciFLTEditorTable($idx,$io,$idxio,name)"
			puts $fid " <range>$sciFLTEditorTable($idx,$io,$idxio,range)"
			foreach idxmf $sciFLTEditorTable($idx,$io,$idxio,mf,tidx) {
				puts $fid "  <mf_name>$sciFLTEditorTable($idx,$io,$idxio,mf,$idxmf,name)"
				puts $fid "   <mf_type>$sciFLTEditorTable($idx,$io,$idxio,mf,$idxmf,type)"
				puts $fid "   <mf_par>$sciFLTEditorTable($idx,$io,$idxio,mf,$idxmf,par)"
			}
			puts $fid ""
		}
	}

	puts $fid "<RULE>"
	foreach nrul $sciFLTEditorTable($idx,rule,tidx) {
		puts $fid "$sciFLTEditorTable($idx,rule,$nrul)"
	}
	puts $fid ""
	# FLUSH AND CLOSE
	flush $fid
	close $fid
}

# ------------------------------------------------------------------------------------------------------------------
# UTILITY -> USEFULL FIND
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorTableFindInList { lineRead tofind } {
	set v1 0
	set v2 ""
	foreach tof $tofind {
		set isnin [regexp "$tof*" "$lineRead"]
		set v1 [expr $v1+$isnin]
		if { $isnin } then {
			set v2 $tof
		}
	}
	return "$v1 $v2"	
}

# ------------------------------------------------------------------------------------------------------------------
# GET FLS STRUCTURE FROM FILE .FLS
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorGetFromFileFLS { filename } {
	global sciFLTEditorTable
	# THIS IS ALMOST THE SAME ALGORITH USED IN loadfls()
	set tofind1 {"<REVISION>" "<DESCRIPTION>" "<INPUT>" "<OUTPUT>" "<RULE>" }
	set tofind2 { "<name>" "<comment>" "<type>" "<SNorm>" "<SNormPar>" "<TNorm>" "<TNormPar>" "<Comp>" "<CompPar>" "<ImpMethod>" "<AggMethod>" "<defuzzMethod>"}
	set tofind3 { "<name>" "<range>" }
	set tofind4 { "<mf_name>" "<mf_type>" "<mf_par>" }
	set curpart ""
	set isname   0
       	set isrange  0
	set isputvar 0
	set ismfname 0
	set ismftype 0 
	set ismfpar  0
	# create a new structure and get the index
	sciFLTEditorNewFls ts
	set idx [lindex $sciFLTEditorTable(fls_tidx) end]

	set fid [open $filename r]
	while { [eof $fid]==0 } {
		gets $fid lineRead
		set lineRead [string trimleft "$lineRead"]
		if { $lineRead!="" } then {
			set isfind [regexp -- "$lineRead" $tofind1]
			if { $isfind } then { 
				set curpart "$lineRead"
				set isname   0
				set isrange  0
				set ismfname 0
				set ismftype 0
				set ismfpar  0
			}
	
			if { [regexp $curpart "<DESCRIPTION>" ] } then {
				set isname   0
				set isrange  0
				set ismfname 0
				set ismftype 0
				set ismfpar  0
				set isfind2 [sciFLTEditorTableFindInList "$lineRead" $tofind2]
				if { [lindex $isfind2 0] } then {
					set curit [lindex $isfind2 1]
					set value [regsub $curit $lineRead ""]
					if { [regexp $curit { "<SNormPar>" "<TNormPar>" "<CompPar>" } ] } then {
						# ELIMINATE THE EXPONENTIAL -> USE NORMAL NOTATION !
						set value [expr $value+0]
					}
					set curit [string tolower [regsub "<" [regsub ">" $curit ""] ""]]
					set sciFLTEditorTable($idx,$curit) $value
				}			
			}
	
			if { [regexp $curpart { "<INPUT>" "<OUTPUT>" } ] } then {
				set isfind2 [sciFLTEditorTableFindInList "$lineRead" $tofind3]
				if { [lindex $isfind2 0] } then {
					set curit [lindex $isfind2 1]
					set value [regsub $curit $lineRead ""]
					if { $curit=="<name>" } then {
						set isname   1
						set isrange  0 
						set isputvar 0
						set varname $value
					}
					if { $curit=="<range>" } then {
						set isrange  1
						set isputvar 0
						set varrange ""
						foreach x { 0 1 } {
							lappend varrange [expr [lindex $value $x]+0]
				       		}	
					}
				}
	
				if { $isname & $isrange & !$isputvar } then {
					if { $curpart=="<INPUT>" } then {
						set io input
					} else {
						set io output
					}
					sciFLTEditorNewVar $idx $io $varname "$varrange"
					set isputvar 1
				}
	
				if { $isname & $isrange } then {
					set isfind2 [sciFLTEditorTableFindInList "$lineRead" $tofind4]
					if { [lindex $isfind2 0] } then {
						set curit [lindex $isfind2 1]
						set value [regsub $curit $lineRead ""]
						if { $curit=="<mf_name>" } then {
							set ismfname 1
							set ismftype 0
							set ismfpar  0
							set t_mfname $value
						}
						if { $curit=="<mf_type>" } then {
							set ismftype 1
							set ismfpar  0
							set t_mftype $value
						}
						if { $curit=="<mf_par>" } then {
							set ismfpar 1
							set t_mfpar ""
							foreach el $value {
								lappend t_mfpar [expr $el+0]
							}
						}
						
					}				
				}
	
				if { $ismfname & $ismftype & $ismfpar & $isputvar } then {
					if { $curpart=="<INPUT>" } then {
						set io input
					} else {
						set io output
					}
					set idxio [lindex $sciFLTEditorTable($idx,$io,tidx) end]
					sciFLTEditorNewMF $idx $io $idxio "$t_mfname" "$t_mftype" "$t_mfpar"
					set ismfname 0
					set ismftype 0
					set ismfpar  0
				}
			}
		
			if { "<RULE>"==$curpart } then {
				if { $lineRead!="<RULE>" } then {
					set rulevalue ""
					foreach el $lineRead {
						lappend rulevalue [expr $el+0]
					}
					set ninputs  [llength $sciFLTEditorTable($idx,input,tidx)]
					set noutputs [llength $sciFLTEditorTable($idx,output,tidx)]
					set ncolumns [expr $ninputs+$noutputs+2]
					if { [expr [llength $rulevalue]==$ncolumns] } then {
						set nrul [expr [lindex $sciFLTEditorTable($idx,rule,tidx) end]+1]
						lappend sciFLTEditorTable($idx,rule,tidx) $nrul
						set sciFLTEditorTable($idx,rule,$nrul) $rulevalue		
					}				
				}
			}
		}
	}		
	close $fid	
	sciFLTEditorDrawTree
}
	

# ------------------------------------------------------------------------------------------------------------------
# GET STRUCTURE FROM FILE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorGetFromFile { } {
	global sciFLTEditorTable
	set types { {"Scilab fls structure" .fls} {"Matlab fis structure" .fis} }
	set file_to_get [tk_getOpenFile -filetypes $types -parent $sciFLTEditorTable(winname)]
	if { $file_to_get!="" } then {
		set file_type [regsub [file rootname $file_to_get] $file_to_get ""]
		if { $file_type==".fls" } then {
			sciFLTEditorGetFromFileFLS $file_to_get			
		}

		if { $file_type==".fis" } then {
			catch { ScilabEval "editfls_export_fis(\"$file_to_get\")" }
		}
	}
}


# ------------------------------------------------------------------------------------------------------------------
# ABOUT DIALOG BOX
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorAbout { } {
	global sciFLTEditorTable
	set w ".sciFLTEditorAbout"
	catch { destroy $w }
	toplevel $w
	wm title $w "About"
	wm resizable $w 0 0
	frame $w.f1 -bg white
	label $w.f1.l1 -image sciFLTEditorTable(icon_logo) -bg white
	text $w.f1.l2 -wrap word -width 30 -height 6
	$w.f1.l2 insert end "Scilab sciFLT toolbox\n\nBy Jaime Urzua Grez\nmailto:jaime_urzua@yahoo.com\n\nrevision:@REV@"
	pack $w.f1.l1 $w.f1.l2 -side top -fill x -expand 0
	button $w.b -text "ok" -command "destroy $w"
	pack $w.f1 $w.b -side top -fill both -expand 0	
}


# ------------------------------------------------------------------------------------------------------------------
# LAUNCH HELP PAGE UNDER SCILAB
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorHelp { } {
	catch { ScilabEval "help editfls" }
}

# ------------------------------------------------------------------------------------------------------------------
# EXPORT TO SCILAB WORKSPACE - MENU
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorExportToScilab { } {
	global sciFLTEditorTable
	if { $sciFLTEditorTable(curIdx)!="" } then {
		set idx [lindex $sciFLTEditorTable(curIdx) 0]
		set fls_name $sciFLTEditorTable($idx,name)
		# MAKE A POPUP MENU
		set w ".sciFLTEditorExportToScilab"
		catch { destroy $w }
		toplevel $w
		wm title $w "Export to Scilab workspace"
		wm resizable $w 0 0
		label $w.l1 -text "Export the structure : $fls_name to Scilab in the variable:"
		set sciFLTEditorTable(scilabname) "fls"
		entry $w.e1 -textvariable sciFLTEditorTable(scilabname)
		button $w.b1 -text "yes" -command "sciFLTEditorExportToScilabDo"
		pack $w.l1 $w.e1 $w.b1 -side top -expand 0 -fill both
	}
}

# ------------------------------------------------------------------------------------------------------------------
# EXPORT TO SCILAB WORKSPACE - THE ACTION
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorExportToScilabDo { } {
	global sciFLTEditorTable
	if { $sciFLTEditorTable(scilabname)=="" } then {
		set sciFLTEditorTable(scilabname) "fls"
	}
	set idx [lindex $sciFLTEditorTable(curIdx) 0]
	set filename "fls_$sciFLTEditorTable(curfileidx).fls"
	set filename [file join $sciFLTEditorTable(tmpdir) $filename]
	sciFLTEditorSaveFLS $filename $idx	
	catch { ScilabEval "$sciFLTEditorTable(scilabname)=loadfls(\"$filename\");" }
	catch { destroy ".sciFLTEditorExportToScilab" }
}

# ------------------------------------------------------------------------------------------------------------------
# IMPORT FROM SCILAB WORKSPACE FIRST PART
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorImportFromScilabC1 { } {
	global sciFLTEditorTable
	# CALL A SCILAB ROUTINE -> EXPORT ALL AVAILABLE FLS STRUCTURE IN THE STACK
	# THEN THIS ROUTINE CALL sciFLTEditorImportFromScilab TO DISPLAY AND SELECT
	set sciFLTEditorTable(do_import_from_scilab) 1
	catch { ScilabEval "editfls_export();" }
}
	
# ------------------------------------------------------------------------------------------------------------------
# IMPORT FROM SCILAB WORKSPACE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorImportFromScilab { } {
	global sciFLTEditorTable
	set sciFLTEditorTable(do_import_from_scilab) 0
	set w ".sciFLTEditorImportFromScilab"
	catch { destroy $w }
	toplevel $w
	wm title $w "Import from workspace"
	wm resizable $w 0 0
	frame $w.f1 -bg white
	label $w.f1.l1 -image sciFLTEditorTable(icon_logo) -bg white
	label $w.f1.l2 -text "Do bouble click over the variable to import"
	pack $w.f1.l1 $w.f1.l2 -side top -fill x -expand 0
	
	frame $w.f2
	listbox $w.f2.lb -yscrollcommand "$w.f2.sb set" -listvariable sciFLTEditorTable(from_scilab)
	scrollbar $w.f2.sb -command "$w.f2.lb yview"
	pack $w.f2.lb -side left -fill both -expand 1
	pack $w.f2.sb -side left -fill y -expand 0
	
	pack $w.f1 -side top -fill x -expand 0
	pack $w.f2 -side top -fill both -expand 0
	set sciFLTEditorTable(do_import_from_scilab) 0

	bind $w.f2.lb <Double-1> {
		global sciFLTEditorTable
		set curvar [selection get]
		catch { destroy ".sciFLTEditorImportFromScilab" }
		catch {	ScilabEval "editfls $curvar" }
	}	
}

# ------------------------------------------------------------------------------------------------------------------
# CHANGE THE POINT OF VIEW (MENU)
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorChangeView { to } {
	global sciFLTEditorTable
	if { $sciFLTEditorTable(curIdx)!="" } then {
		set idx [lindex $sciFLTEditorTable(curIdx) 0]
		set sciFLTEditorTable(curIdx) "$idx $to 0"
		set sciFLTEditorTable($idx,fls_is_open) 1		
		sciFLTEditorDrawTree
	}
}


# ------------------------------------------------------------------------------------------------------------------
# PLOT SURFACE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorSurf { } {
	global sciFLTPlotSurfTable
	global sciFLTEditorTable
	global sciFLTpath

	set sciFLTEditorTable(scilabname) "flt_tmp"
	set idx [lindex $sciFLTEditorTable(curIdx) 0]
	set filename "fls_$sciFLTEditorTable(curfileidx).fls"
	set filename [file join $sciFLTEditorTable(tmpdir) $filename]
	sciFLTEditorSaveFLS $filename $idx	
	catch { ScilabEval "$sciFLTEditorTable(scilabname)=loadfls(\"$filename\");" }
	catch { destroy ".sciFLTEditorExportToScilab" }



	if { $sciFLTEditorTable(curright)!="" } then {

		destroy $sciFLTEditorTable(curright)	
		set w $sciFLTEditorTable(winname).center.right.surfplot
		frame $w
		#FILL INFORMATION
		set sciFLTPlotSurfTable(yes,s) "flt_tmp"
		set sciFLTPlotSurfTable(yes,f) "flt_tmp"
		set idx [lindex $sciFLTEditorTable(curIdx) 0]
		set sciFLTPlotSurfTable(yes,input,ninput) 0
		set sciFLTPlotSurfTable(yes,output,noutput) 0
		set sciFLTPlotSurfTable(yes,input,tch) {"(0) ----"}
		set sciFLTPlotSurfTable(yes,output,tch) {"(0) ----"}
		foreach io { input output } {
			foreach idxio $sciFLTEditorTable($idx,$io,tidx) {
				incr sciFLTPlotSurfTable(yes,$io,n$io)
				set nio $sciFLTPlotSurfTable(yes,$io,n$io)
				set sciFLTPlotSurfTable(yes,$io,$nio) $sciFLTEditorTable($idx,$io,$idxio,name)
				lappend sciFLTPlotSurfTable(yes,$io,tch) "($nio) $sciFLTEditorTable($idx,$io,$idxio,name)"
						
			}
		}
	
		sciFLTPlotSurf "" yes $w
		pack $w -side top -fill both -expand 1
		set sciFLTEditorTable(curright) $w
	}
	
}

# ------------------------------------------------------------------------------------------------------------------
# Plot the current variable
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorPlotVar { } {
	global sciFLTEditorTable
	#sciFLTEditorTable(tmpdir)
	if { $sciFLTEditorTable(curIdx)!="" } then {
		# EXPRT THE CURRENT STRUCTURE TO A FILE
		set idx [lindex $sciFLTEditorTable(curIdx) 0]
		set idx2 [lindex $sciFLTEditorTable(curIdx) 1]
		if { $idx2==2 | $idx2==3 } then {
			set filename "fls_$sciFLTEditorTable(curfileidx).fls"
			set filename [file join $sciFLTEditorTable(tmpdir) $filename]
			incr sciFLTEditorTable(curfileidx)
			sciFLTEditorSaveFLS $filename $idx
			catch { ScilabEval "editfls_plot(\"$filename\",[expr $idx2-2]);" }
		}
	}
}


# ------------------------------------------------------------------------------------------------------------------
# View Rules (added by Tan CL 28-Jan-2014)
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorViewRule { } {
	global sciFLTEditorTable
	#sciFLTEditorTable(tmpdir)
	if { $sciFLTEditorTable(curIdx)!="" } then {
		# EXPRT THE CURRENT STRUCTURE TO A FILE
		set idx [lindex $sciFLTEditorTable(curIdx) 0]
		set idx2 [lindex $sciFLTEditorTable(curIdx) 1]
		if { $idx2==2 | $idx2==3 } then {
			set filename "fls_$sciFLTEditorTable(curfileidx).fls"
			set filename [file join $sciFLTEditorTable(tmpdir) $filename]
			incr sciFLTEditorTable(curfileidx)
			sciFLTEditorSaveFLS $filename $idx
			catch { ScilabEval "editfls_viewrule(\"$filename\");" }
		}
	}
}


# ------------------------------------------------------------------------------------------------------------------
# DO A BLANK PAGE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorEditBlank { } {
	global sciFLTEditorTable
	if { $sciFLTEditorTable(curright)!="" } then {
		destroy $sciFLTEditorTable(curright)
	}
	set w $sciFLTEditorTable(winname).center.right.blank
	frame $w
	set sciFLTEditorTable(curright) $w
}

# ------------------------------------------------------------------------------------------------------------------
# INITIALIZATION
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditorInit { } {
	# TO *****
	global sciFLTPlotSurfTable
	# --------
	global sciFLTEditorTable
	global sciFLTpath_temp
	global sciFLTpath
	if {![info exists sciFLTEditorTable(is_init)]} {
		set sciFLTEditorTable(is_init) 0
	}

	if { $sciFLTEditorTable(is_init)==0 } then {
		image create photo sciFLTEditorTable(icon_logo)        -file [file join $sciFLTpath "gui" "data" "logo.gif"]
		image create photo sciFLTEditorTable(icon_warning)     -file [file join $sciFLTpath "gui" "data" "warning.gif"]
		image create photo sciFLTEditorTable(icon_fls)         -file [file join $sciFLTpath "gui" "data" "icons_fls.gif"]
		image create photo sciFLTEditorTable(icon_description) -file [file join $sciFLTpath "gui" "data" "icons_description.gif"]
		image create photo sciFLTEditorTable(icon_input)       -file [file join $sciFLTpath "gui" "data" "icons_input.gif"]
		image create photo sciFLTEditorTable(icon_input_var)   -file [file join $sciFLTpath "gui" "data" "icons_input_var.gif"]
		image create photo sciFLTEditorTable(icon_output)      -file [file join $sciFLTpath "gui" "data" "icons_output.gif"]
		image create photo sciFLTEditorTable(icon_output_var)  -file [file join $sciFLTpath "gui" "data" "icons_output_var.gif"]
		image create photo sciFLTEditorTable(icon_variable)    -file [file join $sciFLTpath "gui" "data" "warning.gif"]
		image create photo sciFLTEditorTable(icon_rules)       -file [file join $sciFLTpath "gui" "data" "icons_rules.gif"]
		image create photo sciFLTEditorTable(icon_minus)       -file [file join $sciFLTpath "gui" "data" "icons_minus.gif"]
		image create photo sciFLTEditorTable(icon_plus)        -file [file join $sciFLTpath "gui" "data" "icons_plus.gif"]
		image create photo sciFLTEditorTable(icon_mf)          -file [file join $sciFLTpath "gui" "data" "icons_mf.gif"]
		set sciFLTEditorTable(curfileidx) 0
		set sciFLTEditorTable(do_import_from_scilab) 0
		set sciFLTEditorTable(from_scilab) ""
		set sciFLTEditorTable(tmpdir) $sciFLTpath_temp
		set sciFLTEditorTable(is_init) 1		
	}		
}

# ------------------------------------------------------------------------------------------------------------------
# MAIN ROUTINE
# ------------------------------------------------------------------------------------------------------------------
proc sciFLTEditor { {filename ""} {deleteit no} } {
	global sciFLTPlotSurfTable
	global sciFLTEditorTable
	global sciFLTpath_temp
	global sciFLTpath
	sciFLTEditorInit
	set w ".sciFLTEditor"
	set e [ winfo exists $w]
	if { $e==0 } then {
		set sciFLTEditorTable(winname) $w
		set sciFLTEditorTable(fls_tidx) ""
		set sciFLTEditorTable(mesbar) "Welcome"
		set sciFLTEditorTable(curright) ""
		set sciFLTEditorTable(curVarToAction) ""	
		catch { destroy $w }
		toplevel $w
		wm title $w "sciFLT fls Editor"
		wm geometry $w 590x590
		#wm protocol $w WM_DELETE_WINDOW "set sciFLTScicosTable(goout) 1; destroy $w"

		frame $w.top -bd 3 -background white -relief groove
		label $w.top.mes01 -text "fls Editor" -bg white -font {-*-helvetica-bold-r-*-*-24}
		label $w.top.logo -image sciFLTEditorTable(icon_logo) -bg white
		pack $w.top.logo -expand 1 -fill x -side left
		pack $w.top.mes01 -expand 1 -fill x -side right

		panedwindow $w.center
	
		frame $w.center.left
		canvas $w.center.left.canvas -width 1 -height 1 -bd 1 -background LightGray -relief sunken -yscrollcommand "$w.center.left.bar set"
		scrollbar $w.center.left.bar -command "$w.center.left.canvas yview"
		pack $w.center.left.canvas -side left -fill both -expand 1
		pack $w.center.left.bar -side left -fill both -expand 0
	
		frame     $w.center.right

		pack $w.center.left  -side top -fill both -expand 1
		pack $w.center.right -side top -fill both -expand 1
	
		$w.center add $w.center.left $w.center.right

		frame $w.bottom -bd 3 -background white -relief groove -bg pink
		label $w.bottom.label -textvariable sciFLTEditorTable(mesbar) -anchor w -bg pink
		pack $w.bottom.label -side left -padx 0 -expand yes -fill both
	

		menu $w.menu -tearoff 0
		set m $w.menu.file
		menu $m -tearoff 0
		$w.menu add cascade -label "File" -menu $m -underline 0
		$m add cascade -label "New fls" -menu $w.menu.file.newfls
		$m add separator
		$m add cascade -label "Import"  -menu $w.menu.file.import
		$m add cascade -label "Export"  -menu $w.menu.file.export
		$m add separator
		$m add command -label "Delete"  -command "sciFLTEditorDelFls" 
		$m add separator
		$m add command -label "Quit"    -command "destroy $w"
	
		set m $w.menu.file.newfls
		menu $m -tearoff 0
		$m add command -label "Takagi-Sugeno" -command "sciFLTEditorNewFls ts;sciFLTEditorDrawTree"
		$m add command -label "Mamdani"       -command "sciFLTEditorNewFls m;sciFLTEditorDrawTree"
	
		set m $w.menu.file.import
		menu $m -tearoff 0
		$m add command -label "from workspace" -command "sciFLTEditorImportFromScilabC1"
		$m add command -label "from file"      -command "sciFLTEditorGetFromFile"

		set m $w.menu.file.export
		menu $m -tearoff 0 
		$m add command -label "to workspace"         -command "sciFLTEditorExportToScilab"
		$m add command -label "to fls file (scilab)" -command "sciFLTEditorSaveCurrent"
		

		set m $w.menu.view
		menu $m -tearoff 0
		$w.menu add cascade -label "View" -menu $m -underline 0 
		$m add command -label "Description" -command "sciFLTEditorChangeView 1"
		$m add command -label "Inputs"      -command "sciFLTEditorChangeView 2"
		$m add command -label "Outputs"     -command "sciFLTEditorChangeView 3"
		$m add command -label "Plot Current Var"    -command "sciFLTEditorPlotVar"
		$m add command -label "Rules"       -command "sciFLTEditorChangeView 4"
		$m add command -label "Surface"     -command "sciFLTEditorSurf"
		$m add command -label "View Rules"     -command "sciFLTEditorViewRule"

		set m $w.menu.help
		menu $m -tearoff 0
		$w.menu add cascade -label "Help" -menu $m -underline 0
		$m add command -label "Help"  -command "sciFLTEditorHelp"
		$m add command -label "About" -command "sciFLTEditorAbout"

		$w configure -menu $w.menu
	
		pack $w.top    -side top    -fill both -expand 0
		pack $w.center -side top    -fill both -expand 1
		pack $w.bottom -side bottom -fill both -expand 0

		set sciFLTEditorTable(curIdx) ""
		sciFLTEditorDrawTree

		after 100 "$w.center sash place 0 200 1"
	}
	if { $filename!="" } then {
		sciFLTEditorGetFromFileFLS $filename
		if { $deleteit=="yes" } then {
			catch { file delete $filename }
		}
		if { $e==0 } then {
			after 100 "$w.center sash place 0 200 1"
		}
	}       	
}


# ------------------------------------------------------------------------------------------------------------------
# FOR TEST ONLY
# ------------------------------------------------------------------------------------------------------------------

if { 0 } then {
	set sciFLTpath "d:/sciFLT/source"
	set sciFLTpath_temp "d:/sciFLT/source/gui"
	#sciFLTEditor "d:/sciFLT/source/gui"
	source plotsurf.tcl
	sciFLTEditor 
}


