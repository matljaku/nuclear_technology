// Script to run BWR/6 average and hot channels
// Before running: generate and load
// CHAN library
// BEFOR RUNNING: exec ./lib/CHAN_temperature_solver.sci
//--------------------------
mm = 1.e-3;
cm = 1e-2;
m  = 1;
MW=1.0e6; 
MPa=1.0e6;
Million_kg_per_hour = 1.e6/3600;
//--------------------------
// Initialize a new channel variable (mlist): chAv
// We can use ch=CHAN_createGeometry('BWR6',nk); here
// which contains pre-defined data
nk = 100;  // Specify number of nodes in axial direction
//--------------------------
chAv = CHAN_createGeometry('NuScale',nk);
disp(chAv.Loss)
//--------------------------

// Set the coefficient to get DNBR !
// Setting the power
//
// Set operating conditions for an average assembly
//
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
Averaged_heat_flux = Thermal_core_power/Number_of_assemblies ...
                   / (Active_core_height*Assembly_heated_perimeter);
q2p_av = Averaged_heat_flux;
z = chAv.z;  // vector with node coordinates, length nk
apf = 1;
rpf = 1;


s= cos((z-z($)/2)*%pi*5/(6*z($))); // We assume here H/H_tilde = 5/6 and cosine shape

power_shape = [z;s]; // Power axial shape
W   = 0.95*Coolant_flow/Number_of_assemblies; // Assume 15% bypass flow
grav = -9.81*ones(z);  // gravity acceleration
iin = CHAN_fluidProperty(1,'h_pT',Pref,Inlet_temperature_K); // inlet enthalpy
// 
// Update chAv with operating conditions:
// Reference pressure
// inlet specific enthalpy
// Mass flow rate through assembly
// average heat flux in channel
// axial power shape
// gravity acceleration
//--------------------------
chAv = CHAN_setOperatingConditions(chAv,Pref,iin,W,q2p_av,power_shape,grav,rpf);

// To avoid two-phase flow, the overall power should be set to 80%
// The axial peaking factor is in the SetOperatingConditions, the radial peaking factor for hot 
// channel is 1.73836

chAv.q2p = 1.73836*chAv.q2p;
//--------------------------
//
// Set model options
//
VF_opt   = 'HEM';       // Void fraction model
Cf_opt   = 'Haaland';   // Fanning friction factor option
Fi2_opt  = 'HEM';       // Two-phase friction multiplier
Fi2l_opt = 'HEM';       // Two-phase local multiplier
//--------------------------
chAv = CHAN_setModelOptions(chAv,VF_opt,Cf_opt,Fi2_opt,Fi2l_opt);
//--------------------------
// Find enthalpy, pressure, and void distribution
//
//--------------------------

// Task 5 - calculation of the DNBR
// Parameters

G   = 0.95*Coolant_flow/Number_of_assemblies; // Assume 15% bypass flow
//


chAv = CHAN_solver(chAv);
press = Pref + chAv.Dpz;				
itemp = CHAN_fluidProperty(z,'T_ph', press, chAv.iz);  // Temperature distribution



G_density = G/chAv.Axs(1)  

disp(chAv.G)
disp(G_density)
disp(G_density)
disp(chAv.q2p)

// Levitan and Lantsmann


dnbr = [];
q_crit = [];

q_crit = CriticalHeatFlux_SUB(press, G_density, chAv.xe, chAv.q2p);
//q_crit = CriticalHeatFlux_LL(press, G_density, chAv.xe)
// calculations
for i=1:length(z)
	
	//q_crit(i) = CriticalHeatFlux_LL(press(i), G_density, chAv.xe(i) )
	//q_r = chAv.q2p(i)/3.1544e6;
    	dnbr(i) = q_crit(i)/chAv.q2p(i);
    	
end


//isp(max_z);
// critical heat flux
fid = mopen("./data/dnbr/q_cr.txt", "w");
for i=1:length(z)
	print(fid, q_crit(i));
	
end
// dnbr
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

// water quality
fid = mopen("./data/dnbr/xe.txt", "w");
for i=1:length(z)
	print(fid, chAv.xe(i));
	//disp(chAv.xe(i))
end
mclose(fid);


fid = mopen("./data/dnbr/dz.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.z(i));
end
mclose(fid);
fid = mopen("./data/dnbr/dpz.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.Dpz(i));
end
mclose(fid);
fid = mopen("./data/dnbr/diz.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.iz(i));

end

mclose(fid);
fid = mopen("./data/dnbr/dit.txt", "w");
for i=1:length(chAv.z)
	 print(fid,itemp(i));
end
mclose(fid);

fid = mopen("./data/dnbr/dvf.txt", "w");
for i=1:length(chAv.z)
	 print(fid,chAv.vf(i));
end
mclose(fid);

min_dnbr = min(dnbr);
index_max_dnbr = round(find(min_dnbr == dnbr, 1));
min_z = z(index_max_dnbr);
disp(min_dnbr);
disp(index_max_dnbr);
disp(min_z);




