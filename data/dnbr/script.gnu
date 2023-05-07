set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "q2p.pdf"
#set decimalsign ','
set ylabel "q' (W/m)"
set xlabel "z (m)"
set title "" font "CMU serif, 13"

set grid
set key right
set format y "%.1s⋅10^{%T}"
set xtics 0, 0.125, 2
set samples 50000

plot "data_2.txt" using 1:($2) w lp pt 7 ps 0.2 lc 7 title "Linear power density distribution"

reset
set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "xa.pdf"
#set decimalsign ','
set ylabel "x (-)"
set xlabel "z (m)"

set title "" font "CMU serif, 13"

set grid
set key left
#set format y "%.1s⋅10^{%T}"
set xtics 0, 0.125, 2
#set samples 50000


plot "data_2.txt" using 1:3 w lp ps 0.2 pt 8 lc 10  title "Water quality"

reset 


set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "dnbr.pdf"
#set decimalsign ','
set ylabel "DNBR (-)"
set xlabel "z (m)"
#set yrange [3:10]
set yrange [1:8]
set xtics 0,0.125,2
#set xrange [0.35:0.7]
set title "" font "CMU serif, 13"
set grid
set key right
#set arrow from 1.1515152, 22 to 1.1515152, 4 nohead lt 1 lc rgb "grey" 
#set arrow from 0, 4.2719040 to 2, 4.2719040  nohead lt 1 lc rgb "grey" 
set arrow from 1.5353535, 8 to 1.5353535, 1 nohead lt 1 lc rgb "grey" 
set arrow from 0, 1.5646623 to 2, 1.5646623  nohead lt 1 lc rgb "grey" 
set label at 1.5353535, 1.5646623 "" point pt 7 ps 0.4
#set label "MNDR = 4.272" at 1.25, 7
#set label "z_{MNDR} = 1.64 m" at 1.25, 6
set label "MNDR = 1.565 " at 1.6, 4
set label "z_{MNDR} = 1.535 m" at 1.6, 3

f(x) = 1.6363636
plot "data_2.txt" using 1:5 w lp ps 0.2 pt 7 lc 9 title "DNBR"

reset 


set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "q_cr.pdf"
#set decimalsign ','
set ylabel "q_{cr} (MW/m^{-2})"
set xlabel "z (m)"
set xtics 0,0.125,2
#set xrange [0.35:0.7]
set format y "%.1s⋅10^{%T}"
set title "" font "CMU serif, 13"
set grid
set key right

plot "data_2.txt" using 1:4 w lp ps 0.2 pt 7 lc 10 title "q_{cr}"


reset 


set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "dpz.pdf"
#set decimalsign ','
set ylabel "{/Symbol D}p (kPa)"
set xlabel "z (m)"
set xtics 0,0.125,2
#set xrange [0.35:0.7]
set format y "%.1s⋅10^{%T}"
set title "" font "CMU serif, 13"
set grid
set key right

plot "data_4.txt" using 1:($2*1e-3) w lp ps 0.2 pt 7 lc 11 title "Axial pressure drop distribution"

reset 


set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "diz.pdf"
#set decimalsign ','
set ylabel "i (J/kg)"
set xlabel "z (m)"
set xtics 0,0.125,2
#set xrange [0.35:0.7]
set format y "%.1s⋅10^{%T}"
set title "" font "CMU serif, 13"
set grid
set key left

plot "data_4.txt" using 1:3 w lp ps 0.2 pt 7 lc 18 title "Enthalpy distribution"

reset

set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "dit.pdf"
#set decimalsign ','
set ylabel "T (K)"
set xlabel "z (m)"
set xtics 0,0.125,2
#set xrange [0.35:0.7]
set format y "%.0s"
set title "" font "CMU serif, 13"
set grid
set key left

plot "data_4.txt" using 1:4 w lp ps 0.2 pt 7 lc 19 title "Coolant temperature"

reset 




set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "vf.pdf"
#set decimalsign ','
set ylabel "{\Alpha a} (-)"
set xlabel "z (m)"
set xtics 0,0.125,2
#set xrange [0.35:0.7]
set format y "%.0s"
set title "" font "CMU serif, 13"
set grid
set key right

plot "data_4.txt" using 1:5 w lp ps 0.2 pt 7 lc 14 title "Void fraction"


set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "mix.pdf"
#set decimalsign ','
set ylabel "q_{cr} (MW/m^2)"
set y2label "q (MW/m^2)
set xlabel "z (m)"
set xtics 0,0.125,2
set y2tics
set y2range[0.2:0.9]
#set logscale y
#set logscale y2
set y2range[0.2:1.2]
set format y "%.1s"
set title "" font "CMU serif, 13"
set grid
set key right

plot "data_2.txt" using 1:($4*1e-6) w lp ps 0.2 pt 7 lc 10 title "Critical heat flux",\
	"data_2.txt" using 1:($2*1e-6) ax x1y2 w lp pt 7 ps 0.2 lc 7 title "Heat flux density distribution",\
	
reset 
set term pdf font "CMU serif, 13" size 14cm, 7.5cm
set output "mix_2.pdf"
#set decimalsign ','
set ylabel "q \\& q_{cr} (MW/m^2)"
set y2label "DNBR (-)"
set xlabel "z (m)"
set xtics 0,0.125,2
set y2tics 0, 0.25, 2.5
#set y2range[255000:295000]
#set logscale y
#set logscale y2
set y2range[0:2.75]
#set format y "%.3s"
#set y2range[3:10]
set title "" font "CMU serif, 13"
set grid
set key right
set arrow from second 1.5353535, 2 to second 1.5353535, 0 nohead lt 1 lc rgb "grey" 
set arrow from second 0, 1.5646623 to second 2, 1.5646623  nohead lt 1 lc rgb "grey" 
set label at second 1.5353535, 1.5646623 "" point pt 7 ps 0.4

plot "data_2.txt" using 1:($4*1e-6) w lp ps 0.2 pt 7 lc 10 title "Critical heat flux",\
	"data_2.txt" using 1:($2*1e-6)  w lp pt 7 ps 0.2 lc 7 title "Heat flux density distribution",\
	"data_2.txt" u 1:5 w lp ax x1y2 pt 7 ps 0.2 lc 9 title "DNBR"




