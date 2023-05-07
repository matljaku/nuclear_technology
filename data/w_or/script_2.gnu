set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "p_mix_axial.pdf"
#set decimalsign ','
set ylabel "{/Symbol D}p (kPa)"
set xlabel "z (m)"
#set xtics 0,0.125,2.5
#set xrange [1.10:1.55]
set title "" font "CMU serif, 13"
#set samples 10000
set grid
set key lef bottom
#set logscale y
#set format y "%.0s⋅10^{%T}"
#set xtics 0, 0.125, 2
set samples 50000

f(x) = 0
#fit f(x) "data_2" u 1:2 via a, b
plot "data_4.txt" using 1:($2*1e-3) w lp pt 7 ps 0.2 lc 7 title "Gravitational pressure drop",\
	"data_4.txt" using 1:($3*1e-3) w lp pt 7 ps 0.2 lc 8 title "Friction pressure drop",\
	"data_4.txt" using 1:($4*1e-3) w lp pt 7 ps 0.2 lc 9 title "Acceleration pressure drop",\
	"data_4.txt" using 1:($5*1e-3) w lp pt 7 ps 0.2 lc 10 title "Local losses", f(x) lc 6 notitle
	
set output "p_rev_irrev.pdf"
plot "data_4.txt" using 1:($2*1e-3) w lp pt 7 ps 0.2 lc 7 title "Reversible pressure loss",\
	"data_4.txt" using 1:(($3+$4+$5)*1e-3) w lp pt 7 ps 0.2 lc 8 title "Irreversible pressure loss",\
