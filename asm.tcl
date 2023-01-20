#!/usr/bin/env tcl
###############################################################################
# LPRS1 assembler script.
# Author: Milos Subotic <milos.subotic@uns.ac.rs>
###############################################################################

set asm_file "src/asm/MojDrMarioV9.asm"

###############################################################################

set assembler_dir "lprs1_assembler/"


set ir_vhd_beg "-- ubaciti sadrzaj *.txt datoteke generisane pomocu lprsasm ------"
set ir_vhd_end "------------------------------------------------------------------"
set dr_vhd_beg "-- ubaciti sadrzaj *.dat datoteke generisane pomocu lprsasm ------"
set dr_vhd_end "------------------------------------------------------------------"


# Inserting "binary" to VHDL.
proc insert_to_vhd {insert_fn vhd_fn beg_str end_str} {
	file copy -force $vhd_fn $vhd_fn.bak
	#puts $vhd_fn
	
	set fp [open $insert_fn r]
	set insert [read $fp]
	close $fp
	
	set fp [open $vhd_fn r]
	set vhd [read $fp]
	close $fp
	
	set beg [string first $beg_str $vhd]
	set beg [expr $beg + [string length $beg_str] + 1]
	#puts $beg
	#puts [string index $vhd $beg]
	
	set end [string first $end_str $vhd]
	set end [expr $end - 1]
	#puts $end
	#puts [string index $vhd $end]
	
	set vhd [string replace $vhd $beg $end $insert]
	
	set fp [open $vhd_fn w]
	puts -nonewline $fp $vhd
	close $fp
}


# Assembling to "binary".
set prj_dir [pwd]
set OS [lindex $tcl_platform(os) 0]
cd $prj_dir/$assembler_dir
set result  [
	catch {
		if { $OS == "Windows" } {
			exec lprsasm.exe $prj_dir/$asm_file
		} elseif { $OS == "Linux" } {
			exec wine ./lprsasm.exe $prj_dir/$asm_file
		} else {
			error "Non supported OS: $OS"
		}
	} result_text
]
# Return back.
cd $prj_dir

puts $result_text

# More checks.
if {$result} {
	puts "exit code: $result"
	if { $OS == "Linux" } {
		# Trying to deduce if wine or assembler.
		set error_in_asm [
			string match "*child process exited abnormally" "$result_text"
		]
	} else {
		set error_in_asm 1
	}
} else {
	set error_in_asm 0
}

if {$error_in_asm} {
	puts "****\nError in LPRS1 assembling!"
} else {
	puts "****\nLPRS1 assembling OK."
	set asm_bare [file rootname $asm_file]
	insert_to_vhd $asm_bare.o.txt src/hdl/instr_rom.vhd \
		$ir_vhd_beg $ir_vhd_end
	insert_to_vhd $asm_bare.o.dat src/hdl/data_ram.vhd \
		$dr_vhd_beg $dr_vhd_end
}

###############################################################################
