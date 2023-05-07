set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_comp_cout.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "z (m)"

set title "Cladding outter temperature" font "CMU serif, 13"

set grid
set key left
set xtics 0, 0.125, 2

plot "data_cout_2.txt" using 1:($2 - 273.15) w lp ps 0.2 pt 8 lc 11 title "Dittus-Boelter",\
	"data_cout_2.txt" using 1:($3 - 273.15) w lp ps 0.2 pt 8 lc 14 title "Weisman",\
	"data_cout_2.txt" using 1:($4 - 273.15) w lp ps 0.2 pt 8 lc 15 title "Osmachkin",\
	"data_cout_2.txt" using 1:($5 - 273.15) w lp ps 0.2 pt 8 lc 12 title "Markoczy"
reset 

set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_comp_cin.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "z (m)"

set title "Cladding inner temperature" font "CMU serif, 13"

set grid
set key left
set xtics 0, 0.125, 2

plot "data_cin_2.txt" using 1:($2 - 273.15) w lp ps 0.2 pt 8 lc 11 title "Dittus-Boelter",\
	"data_cin_2.txt" using 1:($3 - 273.15) w lp ps 0.2 pt 8 lc 14 title "Weisman",\
	"data_cin_2.txt" using 1:($4 - 273.15) w lp ps 0.2 pt 8 lc 15 title "Osmachkin",\
	"data_cin_2.txt" using 1:($5 - 273.15) w lp ps 0.2 pt 8 lc 12 title "Markoczy"
reset 


set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_comp_fout.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "z (m)"

set title "Fuel outter temperature" font "CMU serif, 13"

set grid
set key left
set xtics 0, 0.125, 2

plot "data_fout_2.txt" using 1:($2 - 273.15) w lp ps 0.2 pt 8 lc 11 title "Dittus-Boelter",\
	"data_fout_2.txt" using 1:($3 - 273.15) w lp ps 0.2 pt 8 lc 14 title "Weisman",\
	"data_fout_2.txt" using 1:($4 - 273.15) w lp ps 0.2 pt 8 lc 15 title "Osmachkin",\
	"data_fout_2.txt" using 1:($5 - 273.15) w lp ps 0.2 pt 8 lc 12 title "Markoczy"
reset 



set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_comp_fcen.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "z (m)"

set title "Fuel temperature in the center" font "CMU serif, 13"

set grid
set key left
set xtics 0, 0.125, 2

plot "data_fcen_2.txt" using 1:($2 - 273.15) w lp ps 0.2 pt 8 lc 11 title "Dittus-Boelter",\
	"data_fcen_2.txt" using 1:($3 - 273.15) w lp ps 0.2 pt 8 lc 14 title "Weisman",\
	"data_fcen_2.txt" using 1:($4 - 273.15) w lp ps 0.2 pt 8 lc 15 title "Osmachkin",\
	"data_fcen_2.txt" using 1:($5 - 273.15) w lp ps 0.2 pt 8 lc 12 title "Markoczy"
reset 



set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_comp_bulk.pdf"
#set decimalsign ','
set ylabel "{/Symbol D}t (˚C)"
set xlabel "z (m)"

set title "Temperature bulk" font "CMU serif, 13"

set grid
set key right
set xtics 0, 0.125, 2

plot "data_bulk_2.txt" using 1:($2 - $6) w lp ps 0.2 pt 8 lc 11 title "Dittus-Boelter",\
	"data_bulk_2.txt" using 1:($3 - $6) w lp ps 0.2 pt 8 lc 14 title "Weisman",\
	"data_bulk_2.txt" using 1:($4 - $6) w lp ps 0.2 pt 8 lc 15 title "Osmachkin",\
	"data_bulk_2.txt" using 1:($5 - $6) w lp ps 0.2 pt 8 lc 12 title "Markoczy"
reset 


