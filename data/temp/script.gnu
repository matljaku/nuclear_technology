set term pdfcairo font "CMU serif,12" size 14cm, 7.5cm
set output "temp_profile_MAX.pdf"

#set grid xtics ytics ls 0 lw 1 lc rgb 'gray'
#set decimalsign ","

set ylabel "T (°C)" font ",12" offset 0,0
set xlabel "radius (mm)" font ",12" offset 0,0

set xrange[0:6]
set yrange[280:900]

set label 1 'Fuel pellet' font "CMU serif,13"  at 1.5,850
set label 2 'Helium gap' font "CMU serif,13"  at 3,850
set label 3 'Cladding' font "CMU serif,13"  at 4.15,850
set label 4 'Water' font "CMU serif,13"  at 5.2,850
set arrow 5 from 3.8,850 to 4.1,750 lt 1 lc rgb "black"

set offset 1,1,1,1

r0 = 0.0000
r1 = 1.0144
r2 = 2.0288
r3 = 3.0432
r4 = 4.0576
r5 = 4.1402
r6 = 4.7498
r7 = 5.2498

#set format x "%0.4f"
set key top right

a = -0.6334
b = 8.7578
c = 49.831
d = 2.5355
e = 835.55

k = -514.87
l = 7924.8
m = -40662
n = 69851

f(x) = a*x**4 + b*x**3 - c*x**2 + d*x + e
g(x) = f*x + g
h(x) = i*x + j
u(x) = k*x**3 + l*x**2 + m*x + n

fit [r0:r4]f(x) "temp_profile.txt" using 1:2 via a, b, c, d, e
fit [r4:r5]g(x) "temp_profile.txt" using 1:2 via f,g
fit [r5:r6]h(x) "temp_profile.txt" using 1:2 via i,j
#fit [r6:r7]u(x) "temp_profile.txt" using 1:2 via k,l,m,n

#set arrow from r0, graph 0 to 0, graph 1 nohead lt "dashed" lc rgb "black"
set arrow from r4, graph 0 to r4, graph 1 nohead lt "dashed" lc rgb "black"
set arrow from r5, graph 0 to r5, graph 1 nohead lt "dashed" lc rgb "black"
set arrow from r6, graph 0 to r6, graph 1 nohead lt "dashed" lc rgb "black"


# Max T_f (z = 1.35 m)
plot "temp_profile.txt" using 1:2:(sprintf("%d °C", $2)) with labels point pt 7 ps 0.5 lc rgb "red" offset char 3,0.5 title "", \
	  [r0:r4]f(x) with lines lc rgb "blue" title "",\
	  [r4:r5]g(x) with lines lc rgb "blue" title "",\
	  [r5:r6]h(x) with lines lc rgb "blue" title "",\
	  [r6:r7]u(x) with lines lc rgb "blue" title "",\

#----------------------------------------------------------------------------------------#

reset
set term pdfcairo font "CMU serif,12" size 14cm, 7.5cm
set output "temp_profile_MIN.pdf"

#set grid xtics ytics ls 0 lw 1 lc rgb 'gray'
#set decimalsign ","

set ylabel "T (°C)" font ",12" offset 0,0
set xlabel "radius (mm)" font ",12" offset 0,0

set offset 1,1,1,1

r0 = 0.0000
r1 = 1.0144
r2 = 2.0288
r3 = 3.0432
r4 = 4.0576
r5 = 4.1402
r6 = 4.7498
r7 = 5.2498


set label 1 'Fuel pellet' font "CMU serif,13"  at 1.5,720
set label 2 'Helium gap' font "CMU serif,13"  at 3,720
set label 3 'Cladding' font "CMU serif,13"  at 4.15,720
set label 4 'Water' font "CMU serif,13"  at 5.2,720
set arrow 5 from 3.8,720 to 4.1,620 lt 1 lc rgb "black"

#set arrow from r0, graph 0 to 0, graph 1 nohead lt "dashed" lc rgb "black"
set arrow from r4, graph 0 to r4, graph 1 nohead lt "dashed" lc rgb "black"
set arrow from r5, graph 0 to r5, graph 1 nohead lt "dashed" lc rgb "black"
set arrow from r6, graph 0 to r6, graph 1 nohead lt "dashed" lc rgb "black"


c = -17.435
d = - 10.405
e = 698.15

k = -514.87
l = 7924.8
m = -40662
n = 69851 *3/5

set yrange[240:780]
set xrange[0:6]

f1(x) = c*x**2 + d*x + e
g1(x) = f*x + g
h1(x) = i*x + j
u1(x) = k*x**3 + l*x**2 + m*x + n

fit [r0:r4]f(x) "temp_profile.txt" using 1:3 via c, d, e
fit [r4:r5]g(x) "temp_profile.txt" using 1:3 via f,g
fit [r5:r6]h(x) "temp_profile.txt" using 1:3 via i,j
#fit [r6:r7]u(x) "temp_profile.txt" using 1:3 via k,l,m,n


# Min T_f (z = 0 m)	
plot "temp_profile.txt" using 1:3:(sprintf("%d °C", $3)) with labels point pt 7 ps 0.5 lc rgb "red" offset char 3,0.5 title "",\
	  [r0:r4] f(x) with lines lc rgb "blue" title "",\
	  [r4:r5] g(x) with lines lc rgb "blue" title "",\
	  [r5:r6] h(x) with lines lc rgb "blue" title "",\
	  [r6:r7] u(x) with lines lc rgb "blue" title ""
