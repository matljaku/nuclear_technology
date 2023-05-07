set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "flow_char.pdf"
#set decimalsign ','
set ylabel "{/Symbol D}p (Pa)"
set xlabel "G (kg/s)"
#set xtics 0,0.125,2.5
#set xrange [1.10:1.55]

set title "" font "CMU serif, 13"
#set samples 10000
set grid
set key left
#set logscale y
set format y "%.1s⋅10^{%T}"
#set xtics 0, 0.125, 2
set samples 50000


#fit f(x) "data_2" u 1:2 via a, b
plot  "data_2.txt" using 1:(-$3) w lp pt 7 ps 0.2 lc 7 title "Pow = 150% P_{ref}", "data_2.txt" using 1:(-$2) w lp pt 7 ps 0.2 lc 12 title "Pow = 100% P_{ref}",\
	"data_2.txt" using 1:(-$4) w lp pt 13 ps 0.2 lc 13 title "Pow = 50% P_{ref}", "data_2.txt" using 1:(-$5) w lp pt 7 ps 0.2 lc 14 title "Pow = 0% P_{ref}"


