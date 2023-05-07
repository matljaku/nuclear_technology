set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_comp_fuel.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "r (mm)"
set title "" font "CMU serif, 13"

set grid
set key right
#set format y "%.1s⋅10^{%T}"
#set xtics 0, 0.125, 2
#set samples 50000

plot "data_fuel_2.txt" using ($1*1e3/2):($2 - 273.15) w lp pt 7 ps 0.2 lc rgb "#0302FC" title "Dittus-Boelter",\
	"data_fuel_2.txt" using ($1*1e3/2):($3 - 273.15) w lp ps 0.2 pt 7 lc rgb "#63009E"  title "Weissman",\
	"data_fuel_2.txt" using ($1*1e3/2):($4 - 273.15) w lp ps 0.2 pt 7 lc rgb "#A1015D" title "Osmachkin",\
	"data_fuel_2.txt" using ($1*1e3/2):($5 - 273.15) w lp ps 0.2 pt 7 lc rgb "#D80027" title "Markoczy"
	
	
