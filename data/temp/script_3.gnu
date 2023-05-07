set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_cool.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "z (m)"
set title "" font "CMU serif, 13"

set grid
set key right
#set format y "%.1s⋅10^{%T}"
set xtics 0, 0.125, 2
set samples 50000

plot "data_2.txt" using 1:($2 - 273.15) w lp pt 7 ps 0.2 lc rgb "#0302FC" title "Axial coolant distribution"

reset
set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_cout.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "z (m)"

set title "" font "CMU serif, 13"

set grid
set key left 
##set format y "%.1s⋅10^{%T}"
set xtics 0, 0.125, 2
#set samples 50000


plot "data_2.txt" using 1:($3 - 273.15) w lp ps 0.2 pt 8 lc rgb "#63009E" title "Cladding outter temperature"

reset 


set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_cin.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "z (m)"
set xtics 0,0.125,2
#set xrange [0.35:0.7]
set title "" font "CMU serif, 13"
set grid
set key left

plot "data_2.txt" using 1:($4 - 273.15) w lp ps 0.2 pt 7 lc rgb "#A1015D" title "Cladding inner temperature"

reset 


set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_fout.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "z (m)"
set xtics 0,0.125,2
#set xrange [0.35:0.7]
#set format y "%.3s⋅10^{%T}"
set title "" font "CMU serif, 13"
set grid
set key left

plot "data_2.txt" using 1:($5 - 273.15) w lp ps 0.2 pt 7 lc rgb "#D80027" title "Fuel outter temperature"


reset 


set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_fcen.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "z (m)"
set xtics 0,0.125,2
#set xrange [0.35:0.7]
#set format y "%.1s⋅10^{%T}"
set title "" font "CMU serif, 13"
set grid
set key left

plot "data_2.txt" using 1:($6 - 273.15) w lp ps 0.2 pt 7 lc rgb "#FE0002" title "Fuel central temperature"

reset 


set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_all.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "z (m)"
set xtics 0,0.125,2
#set xrange [0.35:0.7]
#set format y "%.1s⋅10^{%T}"
set title "" font "CMU serif, 13"
set grid
set key at 1.4, 650 top font ",12" 
plot "data_2.txt" using 1:($2 - 273.15) w lp pt 7 ps 0.2 lc rgb "#0302FC" title "Coolant temperature",\
	"data_2.txt" using 1:($3 - 273.15) w lp ps 0.2 pt 8 lc rgb "#63009E"  title "Cladding outter temperature",\
	"data_2.txt" using 1:($4 - 273.15) w lp ps 0.2 pt 7 lc rgb "#A1015D" title "Cladding inner temperature",\
	"data_2.txt" using 1:($5 - 273.15) w lp ps 0.2 pt 7 lc rgb "#D80027" title "Fuel outter temperature",\
	"data_2.txt" using 1:($6 - 273.15) w lp ps 0.2 pt 7 lc rgb "#FE0002" title "Fuel central temperature"
	
reset 
	
set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_bulk.pdf"
#set decimalsign ','
set ylabel "{/Symbol D}t {˚C} "
set xlabel "z (m)"
set xtics 0,0.125,2
#set xrange [0.35:0.7]
#set format y "%.1s⋅10^{%T}"
set title "" font "CMU serif, 13"
set grid
set key right








plot "data_2.txt" using 1:($2 - $3) w lp pt 7 ps 0.2 lc 7 title "Temperature bulk distribution",\
	
reset 
	
set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "vf.pdf"
#set decimalsign ','
set ylabel "{/Symbol a}t {-} "
set xlabel "z (m)"
set xtics 0,0.125,2
#set xrange [0.35:0.7]
#set format y "%.1s⋅10^{%T}"
set title "" font "CMU serif, 13"
set grid
set key right








plot "data_2.txt" using 1:7 w lp pt 7 ps 0.2 lc 12 title "Void fraction",\
	
