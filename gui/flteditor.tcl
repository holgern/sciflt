# ----------------------------------------------------------------------
# fls EDITOR
# ----------------------------------------------------------------------
# This file is part of sciFLT ( Scilab Fuzzy Logic Toolbox )
# Copyright (C) @YEARS@ Jaime Urzua Grez
# mailto:jaime_urzua@yahoo.com
# Toolbox Revision @REV@ -- @DATE@
# ----------------------------------------------------------------------
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# ----------------------------------------------------------------------
# CHANGES
# 2006 New Script -- Start from the scratch !
#                    The new concept use more scilab code than tk/tcl
# ----------------------------------------------------------------------
# PUNTOS A CERRAR
# [X] TNormPar muestra informacion incorrecta!
# [X] Despliegue de las variables de entrada / salida
# [ ] Lincado de las variables mostradas en los arboles para edicion
# [ ] Verificar la ortografia
# [ ] Hacer que se muestre el NOT en las reglas !!!! --> BUG@!
#
# PRUEBAS GENERALES
# [X] Crear nuevo TS
# [X] Crear nuevo M
# [X] Importar desde archivo fls
# [X] Importar desde archivo fis
# [X] Importar desde espacio de trabajo
# [ ] Exportar a archivo
# [ ] Exportar a espacio de trabajo
# [X] Despliegue de ayuda
# [X] Despliegue About
# [ ] Cierre de pantalla TODO: Eliminar la informacion basura
# ----------------------------------------------------------------------



# ----------------------------------------------------------------------
# Declare Global's
# ----------------------------------------------------------------------
global fltEditTable

# ----------------------------------------------------------------------
# Initialize internal vars
# ----------------------------------------------------------------------
proc fltEditInit { dir1 } {
	global fltEditTable
	# Load images
	foreach { x } { ts m save quit iws ews help iff fls des ivar ovar logosmall mfs sep } {
		image create photo fltEditTable(icon,$x) -file [file join $dir1 data "icons_new_$x.gif"]
	}
	# Set member functions names
	set fltEditTable(mfs,inputs) { trimf trapmf gaussmf gauss2mf gbellmf sigmf psigmf dsigmf smf zmf pimf }
	set fltEditTable(mfs,tso)    { constant linear }
	set fltEditTable(mfs,mo)     $fltEditTable(mfs,inputs)
	set fltEditTable(isinit) 1
	# Initialize with cero
	foreach x { name comment type SNorm SNormPar TNorm TNormPar Comp CompPar ImpMethod AggMethod defuzzMethod } {
		set fltEditTable(fls,$x) ""
	}
	# TODO: Completar esta limpieza!
}

# ----------------------------------------------------------------------
# Import from SCILAB
# ----------------------------------------------------------------------
proc fltEditImportFromWS { tp } {
	global fltEditTable
	set w ".sciFLTeditImport"
	# Draw the selection window
	if { $tp==0 } then {
		catch { destroy $w }
		toplevel $w
		wm title $w "sciFLT toolbox - Import from workspace"
		labelframe $w.items -text "Choose a fls structure:"
		listbox $w.items.ls -width 20 -height 20
		scrollbar $w.items.sbx -orient horizontal
		scrollbar $w.items.sby -orient vertical
		fltEditRedraw3x $w.items.ls $w.items.sbx $w.items.sby
		frame $w.buttons	
		pack $w.items $w.buttons -side top -expand 1 -fill both
		catch { ScilabEval "ie_fls_edit(6,0);" }
		bind $w.items.ls <Double-1> { 
			catch { ScilabEval "ie_fls_edit(2,\"[selection get]\");" }
			fltEditImportFromWS 2
		}
	# Add all fls from SCILAB workspace
	} elseif { $tp==1 } then {
		$w.items.ls delete 0 end
		foreach { x } $fltEditTable(fls,listworkspace) {
			$w.items.ls insert end $x
		}
	# Close the interaction window
	} elseif { $tp==2 } then {
		destroy $w
	}
}

# ----------------------------------------------------------------------
# Export from SCILAB
# ----------------------------------------------------------------------
proc fltEditExportToWS { tp } {
	global fltEditTable
	set w ".sciFLTeditExport"
	# Draw the selection window
	if { $tp==0 } then {
		catch { destroy $w }
		toplevel $w
		wm title $w "sciFLT toolbox - Export to workspace"
		labelframe $w.items -text "Indicate the name:" -fg navy 
		entry $w.items.entry -width 20 -textvariable fltEditTable(fls,sciname)
		pack $w.items.entry -side left -expand 1 -fill x
		frame $w.buttons
		button $w.buttons.export -text "Export" -command "fltEditExportToWS 1"
		pack $w.buttons.export -side left -expand 1 -fill x
		pack $w.items $w.buttons -side top -expand 1 -fill both
	# Export
	} elseif { $tp==1 } then {
		catch { ScilabEval "$fltEditTable(fls,sciname)=ie_fls_edit(5,\"$fltEditTable(fls,sciname)\");" }
		destroy $w
	}
}


# ----------------------------------------------------------------------
# Help
# ----------------------------------------------------------------------
proc fltEditHelp { } {
	global fltEditTable
	catch { ScilabEval "help editfls" }
}

# ----------------------------------------------------------------------
# Quit
# ----------------------------------------------------------------------
proc fltEditQuit { } {
	global fltEditTable
	set answer [ tk_messageBox -title "Quit" -message "Discard all changes and quit?" -type yesno -icon warning -parent $fltEditTable(mainwin) ]
	if { $answer=="yes" } then { 
		catch { destroy $fltEditTable(mainwin) }
		# TODO : Eliminar la informacion basura!
	}
}

# ----------------------------------------------------------------------
# About Dialog
# ----------------------------------------------------------------------
proc fltEditAbout { } {
	global fltEditTable
	tk_messageBox -title "About" -message "This is the GUI editor of sciFLT toolbox\nToolbox Revision @REV@ -- @DATE@\nCopyright (C) @YEARS@ Jaime Urzua Grez\nmailto:jaime_urzua@yahoo.com" -type ok -icon info -parent $fltEditTable(mainwin)
}


# ----------------------------------------------------------------------
# Create a new FLS structure
# ----------------------------------------------------------------------
proc fltEditNewFLS { tip } {
	global fltEditTable
	if { $tip=="m" } then {
		set tipi "Mamdani"
	} else {
		set tipi "Takagi-Sugeno"
	}
	set answer [tk_messageBox -title "Create a new $tipi system" -message "This action destroy the current FLS structure.\nCreate a new FLS?" -type yesno -icon warning -parent $fltEditTable(mainwin)]
	if { $answer=="yes" } then {
		catch { ScilabEval "ie_fls_edit(3,'$tip');" }
	}
}

# ----------------------------------------------------------------------
# Load a FLS structure
# ----------------------------------------------------------------------
proc fltEditLoadFLS { } {
	global fltEditTable
	set types {
		{{sciFLT} {.fls}}
		{{Matlab FIS} {.fis}}	    
		{{All Files} *}
	}
	set filename [tk_getOpenFile -filetypes $types -parent $fltEditTable(mainwin)]
	if { $filename!="" } then {
		catch { ScilabEval "ie_fls_edit(1,'$filename');" }
	}
}

# ----------------------------------------------------------------------
# Save a FLS structure
# ----------------------------------------------------------------------
proc fltEditSaveFLS { } {
	global fltEditTable
	set types {
		{{sciFLT} {.fls}}
		{{All Files} *}
	}
	set filename [tk_getSaveFile -filetypes $types -parent $fltEditTable(mainwin)]
	if { $filename!="" } then {
		catch { ScilabEval "ie_fls_edit(4,'$filename');" }
	}
}


# ----------------------------------------------------------------------
# Redraw Screen -- INPUTS, RULES, OUTPUTS
# ----------------------------------------------------------------------
proc fltEditRedrawIOR {} {
	global fltEditTable	
	
	# Draw INPUTS and OUTPUTS trees
	set x01 10
	set x02 30
	set x03 20
	set x04 40
	set sY 15
	foreach io { input output } {
		set w $fltEditTable(curcenter).book.$io.canvas
		$w delete all
		set yLocal 0
		set fill_color navy
		for { set i 1 } { $i<=$fltEditTable(fls,$io,nvar) } { incr i } {
			set y [expr 15+$sY*$yLocal]
			if { $io=="input" } then { set iname ivar } else { set iname ovar }
			set b1 [$w create image $x01 $y -image  fltEditTable(icon,$iname) -anchor w]
			set b2 [$w create text  $x02 $y -text "$fltEditTable(fls,$io,$i,name)" -anchor w -fill $fill_color]
			$w bind $b1 <1> ""
			$w bind $b2 <1> ""
			incr yLocal
			for { set mf 1 } { $mf<=$fltEditTable(fls,$io,$i,nmf) } { incr mf } {
				set y [expr 15+$sY*$yLocal]
				set b3 [$w create image $x03 $y -image  fltEditTable(icon,mfs) -anchor w]
				set b4 [$w create text  $x04 $y -text "$fltEditTable(fls,$io,$i,$mf,name)" -anchor w -fill $fill_color]
				$w bind $b3 <1> ""
				$w bind $b4 <1> ""
				incr yLocal
			}
		}
		$w config -scrollregion [$w bbox all]
	}

	# Draw and parse RULES
	set w $fltEditTable(curcenter).book.rules.ru
	$w delete 0 end
	for { set ru 1 } { $ru<=$fltEditTable(fls,nrul) } { incr ru } {
		set mes "R$ru: IF "
		# Antecedents
		if { [lindex $fltEditTable(fls,rule,$ru) end]==0 } then { 
			set union " OR "
		} else {
			set union " AND "
		}
		set ninputs $fltEditTable(fls,input,nvar)
		for { set i 1 } { $i<=$fltEditTable(fls,input,nvar) } { incr i } {
			set p [lindex $fltEditTable(fls,rule,$ru) [expr $i-1]]
			if { $p!=0 } then {
				append mes "( $fltEditTable(fls,input,$i,name) IS $fltEditTable(fls,input,$i,$p,name) )"
				if { $i!=$ninputs } then { append mes $union }
			}
		}
		# Consequents		
		append mes " THEN "
		set union " | "
		set noutputs $fltEditTable(fls,output,nvar)
		append mes 
		for { set i 1 } { $i<=$fltEditTable(fls,output,nvar) } { incr i } {
			set p [lindex $fltEditTable(fls,rule,$ru) [expr $i+int($ninputs)-1]]
			if { $p!=0 } then {
				append mes "( $fltEditTable(fls,output,$i,name) IS $fltEditTable(fls,output,$i,$p,name) )"
				if { $i!=$noutputs } then { append mes $union }
		
			}
		# Add the weight information
		set weight  [lindex $fltEditTable(fls,rule,$ru) end]
		append mes " \[weight = $weight \]"
		$w insert end "$mes"
		}
	}
	fltEditRedrawOptions
}

# ----------------------------------------------------------------------
# Redraw Screen -- OPTIONS
# ----------------------------------------------------------------------
proc fltEditRedrawOptions { } {
	global fltEditTable
	set w $fltEditTable(curbottom).op
	catch { destroy $w }
	set qq 2
	# VARIABLE
	if { $qq==0 } then {

	}

	# MEMBER FUNCTIONS
	if { $qq==1 } then {

	}

	# Rules
	if { $qq==2 } then {
		
	}
}

# ----------------------------------------------------------------------
# Redraw Screen -- Utility
# ----------------------------------------------------------------------
proc fltEditRedraw3x { it1 it2 it3 } {
	grid $it1 -row 0 -column 0 -rowspan 1 -columnspan 1 -sticky news
	grid $it2 -row 1 -column 0 -rowspan 1 -columnspan 1 -sticky news
	grid $it3 -row 0 -column 1 -rowspan 1 -columnspan 1 -sticky news
}
# ----------------------------------------------------------------------
# Redraw Screen
# ----------------------------------------------------------------------
proc fltEditRedraw { curId } {
	global fltEditTable
	catch { destroy $fltEditTable(curcenter).book }
	if { $curId==0 } then {
		set wt1 $fltEditTable(curcenter).book
		labelframe $wt1 -fg navy
		label $wt1.l1 -text "name:"
		entry $wt1.e1 -width 40 -textvariable fltEditTable(fls,name)

		label $wt1.l2 -text "comment:"
		entry $wt1.e2 -width 40 -textvariable fltEditTable(fls,comment)

		label $wt1.l3 -text "S-Norm class:"
		spinbox $wt1.e3 -width 40 -state readonly -values { "dubois" "yager" "dsum" "esum" "asum" "max" } 
		$wt1.e3 configure -textvariable fltEditTable(fls,SNorm)

		label $wt1.l4 -text "S-Norm parameter:"
		entry $wt1.e4 -width 10 -textvariable fltEditTable(fls,SNormPar)

		label $wt1.l5 -text "T-Norm class:"
		spinbox $wt1.e5 -width 40 -state readonly -values { "dubois" "yager" "dprod" "eprod" "aprod" "min" }
		$wt1.e5 configure -textvariable fltEditTable(fls,TNorm)

		label $wt1.l6 -text "T-Norm parameter:"
		entry $wt1.e6 -width 10 -textvariable fltEditTable(fls,TNormPar)

		label $wt1.l7 -text "Complement class:"
		spinbox $wt1.e7 -width 40 -state readonly -values {"one" "yager" "sugeno"}
		$wt1.e7 configure -textvariable fltEditTable(fls,Comp)

		label $wt1.l8 -text "Complement parameter:"
		entry $wt1.e8 -width 10 -textvariable fltEditTable(fls,CompPar)

		label $wt1.l9 -text "Implication method:"
		spinbox $wt1.e9 -width 40 -state readonly -values { "min" "max" "prod" "eprod"} 
		$wt1.e9 configure -textvariable fltEditTable(fls,ImpMethod)

		label $wt1.l10 -text "Aggregation method:"
		spinbox $wt1.e10 -width 40 -state readonly -values { "max" "sum" "probor" "esum"} 
		$wt1.e10 configure -textvariable fltEditTable(fls,AggMethod)

		label $wt1.l11 -text "Defuzzification method:"
		spinbox $wt1.e11 -width 40 -state readonly 
		foreach { x } { 1 2 3 4 5 6 7 8 9 10 11 } {
			grid $wt1.l$x -row $x -column 0 -rowspan 1 -columnspan 1 -sticky e
			grid $wt1.e$x -row $x -column 1 -rowspan 1 -columnspan 1 -sticky w
		}
		pack $wt1 -expand 1 -fill both	
		if { $fltEditTable(fls,type)=="ts" } then {
			foreach { x } { e9 e10 } {
				$wt1.$x configure -state disabled
			}
			$wt1.e11 configure -values { "wtaver" "wtsum" }
			$wt1 configure  -text "Configuration - Takagi Sugeno"
		} else {
			$wt1.e11 configure -values { "centroide" "bidesctor" "mom" "som" "lom"}
			$wt1 configure  -text "Configuration - Mamdani"
		}
		$wt1.e11 configure -textvariable fltEditTable(fls,defuzzMethod)
	} else {
		set wt1 $fltEditTable(curcenter).book
		labelframe $wt1 -text "FLS Structure:"
		labelframe $wt1.input -text "Inputs:"
		canvas $wt1.input.canvas -width 200 -xscrollcommand "$wt1.input.sbx set" -yscrollcommand "$wt1.input.sby set"
		scrollbar $wt1.input.sbx -orient horizontal -command "$wt1.input.canvas xview"
		scrollbar $wt1.input.sby -orient vertical -command "$wt1.input.canvas yview"
		fltEditRedraw3x $wt1.input.canvas $wt1.input.sbx $wt1.input.sby


		labelframe $wt1.rules -text "Rules:"
		listbox $wt1.rules.ru -width 50 -height 15 -xscrollcommand "$wt1.rules.sbx set" -yscrollcommand "$wt1.rules.sby set"
		scrollbar $wt1.rules.sby -orient vertical -command "$wt1.rules.ru yview"
		scrollbar $wt1.rules.sbx -orient horizontal -command "$wt1.rules.ru xview"
		fltEditRedraw3x $wt1.rules.ru $wt1.rules.sbx $wt1.rules.sby

		labelframe $wt1.output -text "Outputs:"
		canvas $wt1.output.canvas -width 200 -xscrollcommand "$wt1.output.sbx set" -yscrollcommand "$wt1.output.sby set"
		scrollbar $wt1.output.sbx -orient horizontal -command "$wt1.output.canvas xview"
		scrollbar $wt1.output.sby -orient vertical -command "$wt1.output.canvas xview"
		fltEditRedraw3x $wt1.output.canvas $wt1.output.sbx $wt1.output.sby

		pack $wt1.input $wt1.rules $wt1.output -side left -padx 2 -expand 1 -fill both
		fltEditRedrawIOR
	}
	pack $fltEditTable(curcenter).book -fill both
}


# ----------------------------------------------------------------------
# Update Information in the bottom of the window
# ----------------------------------------------------------------------
proc fltEditUpdateInfo { id } {
	global fltEditTable
	set mes ""
	switch $id {
		1  { set mes "Create a new takagi-sugeno structure" }
		2  { set mes "Create a new mamdani structure" }
		3  { set mes "Save current to file" }
		4  { set mes "Load from file" }
		5  { set mes "Import from workspace" }
		6  { set mes "Export to workspace" }
		7  { set mes "Show description" }
		8  { set mes "Show structure" }
		9  { set mes "Help" }
		10 { set mes "Quit" }
	}
	set fltEditTable(info) $mes
}


# ----------------------------------------------------------------------
# Main routine
# ----------------------------------------------------------------------
proc fltEdit { } {
	global fltEditTable
	set w ".sciFLTEdit"
	catch { destroy $w }
	toplevel $w
	wm geometry $w 800x500
	wm title $w "sciFLT toolbox - Editor"
	labelframe $w.top
	set buttons { 
		{ts   "fltEditNewFLS ts"      1}
		{m    "fltEditNewFLS m"       2}
		{save "fltEditSaveFLS"        3}
		{sep ""                       0}
		{iff  "fltEditLoadFLS"        4}
		{iws  "fltEditImportFromWS 0" 5}
		{ews  "fltEditExportToWS 0"   6}
		{sep ""                       0}
		{des  "fltEditRedraw 0"       7}
		{fls  "fltEditRedraw 1"       8}
		{sep ""                       0}
		{help "fltEditHelp"           9}
		{quit "fltEditQuit"           10}
	}
	set p 0
	foreach x $buttons { 
		if { [lindex $x 0]=="sep" } then {
			button $w.top.b$p -image fltEditTable(icon,[lindex $x 0]) -command [lindex $x 1] -relief flat -state disable
		} else {
			button $w.top.b$p -image fltEditTable(icon,[lindex $x 0]) -command [lindex $x 1] -relief groove -state normal
		}
		bind $w.top.b$p <Motion> "fltEditUpdateInfo [lindex $x 2]"
		bind $w.top.b$p <Leave> "fltEditUpdateInfo 0"
		
		pack $w.top.b$p -side left -expand 0
		incr p
	}

	frame $w.center
	set fltEditTable(curcenter) $w.center
	set fltEditTable(curbottom) $w.bottom
	set fltEditTable(mainwin) $w
	labelframe $w.bottom -text "Options:" -height 10
	frame $w.info -bg pink
	label $w.info.msg -bg pink -textvariable fltEditTable(info)
	pack $w.info.msg  -side left -expand 0 -fill x
	pack $w.top       -side top -fill x    -expand 0
	pack $w.center    -side top -fill both -expand 1
	pack $w.bottom    -side top -fill both -expand 1
	pack $w.info      -side top -fill x    -expand 0
}


