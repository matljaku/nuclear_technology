
// Task 5 - calculation of the DNBR
// Parameters
coeff = 10.0
G   = 0.95*Coolant_flow; // Assume 15% bypass flow
Pref                 = 12.76*MPa;  // System pressure (Pa)
Inlet_temperature_K  = 258.33+273.15; // Inlet temperature (K)
Thermal_core_power   = 160*MW;  // Thermal core power (W)
Number_of_assemblies = 37;      // Number of assemblies
Active_core_height   = 2*m;   // Active core height (m)
Coolant_flow         = 587; // (kg/s)
Fuel_rod_OD          = 9.5*mm;  // Fuel rod outer diameter (m)
Number_of_fuel_rods  = 264;       // Number of fuel rods
//
Assembly_heated_perimeter = %pi*Fuel_rod_OD * Number_of_fuel_rods;
Averaged_heat_flux = Thermal_core_power/(Number_of_assemblies*Active_core_height*Assembly_heated_perimeter);
q2p_av = Averaged_heat_flux; // this is averge heat flux for one assembly, we need for one rod
z = chAv.z;  // vector with node coordinates, length nk
apf = 1.4; // Axial peaking factor
s= apf*cos((z-z($)/2)*5/6/z($)); // We assume here H/H_tilde = 5/6 and cosine shape
power_shape = [z;s]; // Power axial shape
W   = 0.95*Coolant_flow/Number_of_assemblies; // Assume 15% bypass flow
grav = -9.81*ones(z);  // gravity acceleration
iin = CHAN_fluidProperty(1,'h_pT',Pref,Inlet_temperature_K); // inlet enthalpy
chAv = CHAN_setOperatingConditions(chAv,Pref,iin,W,q2p_av,power_shape,grav);

chAv = CHAN_solver(chAv);
press = Pref + chAv.Dpz;				
itemp = CHAN_fluidProperty(z,'T_ph', press, chAv.iz);  // Temperature distribution


P_cr = 22.064*MPa // Critical pressure
G_density = G/(chAv.Axs(1))  

  
a1 = 0.5328;
a2 = 0.1212;
a3 = -0.3040;
a4 = 0.3285;

c1 = 1.6151;
c2 = 1.4066;
c3 = 0.4843;
c4 = -2.0749;

p_r = Pref/P_cr;
G_r = G_density/1356.23;

A = a1 * p_r^a2 * G_r^(a3 + a4*p_r);
B = 3.1544*1e6;
C = c1 * p_r^c2 * G_r^(c3 + c4*p_r);


dnbr = [];
q_crit = []  

for i=1:length(z)
	q_r = chAv.q2p(i)/3.1544e6;
  	q_crit(i) = B*(A - chAv.xa(1))/(C + (chAv.xa(i) - chAv.xa(1))/(q_r));
    	dnbr(i) = q_crit(i)/chAv.q2p(i);
    	disp(q_crit(i))
    	disp(dnbr(i))
end
      
// critical heat flux
fid = mopen("./data/dnbr/q_cr.txt", "w");
for i=1:length(z)
	print(fid, q_crit(i));
	
end
mclose(fid);
fid = mopen("./data/dnbr/dnbr.txt", "w");
for i=1:length(z)
	print(fid, dnbr(i));
	
end
mclose(fid);

// power density distribution
fid = mopen("./data/dnbr/q2p.txt", "w");
for i=1:length(z)
	print(fid, chAv.q2p(i));
	
end
mclose(fid);
fid = mopen("./data/dnbr/xa.txt", "w");
for i=1:length(z)
	print(fid, chAv.xa(i));
end
mclose(fid);
