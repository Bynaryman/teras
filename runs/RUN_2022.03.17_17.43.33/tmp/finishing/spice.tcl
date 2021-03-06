
if { [info exist ::env(MAGIC_EXT_USE_GDS)] && $::env(MAGIC_EXT_USE_GDS) } {
	gds read $::env(CURRENT_GDS)
} else {
	lef read /home/zerotoasic/asic_tools/pdk/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
	if {  [info exist ::env(EXTRA_LEFS)] } {
		set lefs_in $::env(EXTRA_LEFS)
		foreach lef_file $lefs_in {
			lef read $lef_file
		}
	}
	def read /openlane/designs/teras/runs/RUN_2022.03.17_17.43.33/results/routing/teras.def
}
load teras -dereference
cd /openlane/designs/teras/runs/RUN_2022.03.17_17.43.33/results/finishing/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
if { ! 0 } {
	extract unique
}
# extract warn all
extract

ext2spice lvs
ext2spice -o /openlane/designs/teras/runs/RUN_2022.03.17_17.43.33/results/finishing/teras.spice teras.ext
feedback save /openlane/designs/teras/runs/RUN_2022.03.17_17.43.33/logs/finishing/28-ext2spice.feedback.txt
# exec cp teras.spice /openlane/designs/teras/runs/RUN_2022.03.17_17.43.33/results/finishing/teras.spice

