set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "p_axial.pdf"
#set decimalsign ','
set ylabel "p (Pa)"
set xlabel "z (m)"
#set xtics 0,0.125,2.5
#set xrange [1.10:1.55]
set title "" font "CMU serif, 13"
#set samples 10000
set grid
set key right
#set logscale y
set format y "%.0s⋅10^{%T}"
set xtics 0, 0.125, 2
set samples 50000


#fit f(x) "data_2" u 1:2 via a, b
plot "data_2.txt" using 1:3 w lp pt 7 ps 0.2 lc 7 title "Axial pressure drop"

set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "i_axial.pdf"
#set decimalsign ','
set ylabel "i (J)"
set xlabel "z (m)"
#set xtics 0,0.125,2.5
#set xrange [1.10:1.55]
set title "" font "CMU serif, 13"
#set samples 10000
set grid
set key right
#set logscale y
set format y "%.1s⋅10^{%T}"
set xtics 0, 0.125, 2
#set samples 50000


#fit f(x) "data_2" u 1:2 via a, b
plot "data_2.txt" using 1:2 w lp ps 0.2 pt 7 lc 10  title "Axial enthalpy distribution"

reset 
set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "t_axial.pdf"
#set decimalsign ','
set ylabel "t (˚C)"
set xlabel "z (m)"
set xtics 0,0.125,2
set xrange [0:2]
set title "" font "CMU serif, 13"
#set samples 10000
set grid
set key right
#set logscale y
#set format y "%.0s⋅10^{%T}"
#set samples 50000

f(x) = a*x + b
fit [0:0.75] f(x) "data_2.txt" u 1:($4 - 273.15) via a, b
plot "data_2.txt" using 1:($4 - 273.15) w lp ps 0.2 pt 7 lc 9 title "Axial temperature distribution", f(x) notitle

