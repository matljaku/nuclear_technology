// Script to run BWR/6 average and hot channels
// Before running: generate and load
// CHAN library
//--------------------------
mm = 1.e-3;
cm = 1.e-2;
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

rpf = 1.0
s= cos((z-z($)/2)*(5*%pi)/(6*z($))); // We assume here H/H_tilde = 5/6 and cosine shape
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
chAv = CHAN_setOperatingConditions(chAv,Pref,iin,W,q2p_av,power_shape,grav, rpf);
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
chAv = CHAN_solver(chAv);
press = Pref + chAv.Dpz;
itemp = CHAN_fluidProperty(z,'T_ph', press, chAv.iz);



//--------------------------
//
// Plot pressure distribution
// Without the orifice pressure loss coefficient

fid = mopen("./data/wo_or/dz.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.z(i));
end
mclose(fid);
fid = mopen("./data/wo_or/dpz.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.Dpz(i));
end
mclose(fid);
fid = mopen("./data/wo_or/diz.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.iz(i));
end
mclose(fid);



fid = mopen("./data/wo_or/dit.txt", "w");
for i=1:length(chAv.z)
	 print(fid,itemp(i));
end
mclose(fid);

fid = mopen("./data/wo_or/dvf.txt", "w");
for i=1:length(chAv.z)
	 print(fid,chAv.vf(i));
end
mclose(fid);

disp(chAv.Axs)
disp(chAv.Dh)

disp(W)
halt("Press Enter to continue:");



// By default, inlet loss coefficient is 0
// We increase it to double pressure drop

chAv = CHAN_setInletLoss(chAv,18);
chAv = CHAN_solver(chAv);
press = Pref + chAv.Dpz;
itemp = CHAN_fluidProperty(z,'T_ph', press, chAv.iz);


//Multiple pressure drop graph
//fid = mopen("./data/w_or/dp_mix.txt", "w");
Dpz_mix = [[chAv.Dpz_grav], [chAv.Dpz_fric], [chAv.Dpz_loc], [chAv.Dpz_fric]];
disp(Dpz_mix);
fid = mopen("./data/w_or/Dpz_grav.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.Dpz_grav(i));
end
mclose(fid);
fid = mopen("./data/w_or/Dpz_fric.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.Dpz_fric(i));
end
mclose(fid);
fid = mopen("./data/w_or/Dpz_acc.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.Dpz_acc(i));
end
mclose(fid);
fid = mopen("./data/w_or/Dpz_loc.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.Dpz_loc(i));
end
mclose(fid);
fid = mopen("./data/w_or/dz.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.z(i));
end
mclose(fid);
fid = mopen("./data/w_or/dpz.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.Dpz(i));
end
mclose(fid);
fid = mopen("./data/w_or/diz.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.iz(i));

end
mclose(fid);
fid = mopen("./data/w_or/dit.txt", "w");
for i=1:length(chAv.z)
	 print(fid,itemp(i));
end
mclose(fid);

fid = mopen("./data/w_or/dvf.txt", "w");
for i=1:length(chAv.z)
	 print(fid,chAv.vf(i));
end
mclose(fid);

disp(chAv.xe)
disp(q2p_av)
disp(chAv.q2p)
halt("Press Enter to continue:");


// Will calculate the flow characteristics of the core
//Define the x-axis vector
//Write into G_grid file
G_grid = linspace(0.01,1.5,30)
G_grid = G_grid * Coolant_flow
fid = mopen("./data/flow_char/G_grid.txt", "w");
for i=1:length(G_grid)
	print(fid, G_grid(i));
    	disp(G_grid(i));
end
mclose(fid);


// Set thermal power to 100%
// Iterate through G_grid
Thermal_core_power = 1.0*160*MW;
disp(Thermal_core_power)
Averaged_heat_flux = Thermal_core_power/Number_of_assemblies ...
                   / (Active_core_height*Assembly_heated_perimeter);
                  
q2p_av = Averaged_heat_flux;
iin = CHAN_fluidProperty(1,'h_pT',Pref,Inlet_temperature_K); // inlet enthalpy
fid = mopen("./data/flow_char/P_100.txt", "w");
for i=1:length(G_grid)
	W   = 0.95*G_grid(i)/Number_of_assemblies;
	chAv = CHAN_setOperatingConditions(chAv,Pref,iin,W,q2p_av,power_shape,grav, rpf);
	chAv = CHAN_solver(chAv);
    	print(fid,chAv.Dpz($));
    	//disp(G_grid(i), chAv.Dpz($));
    	
end
mclose(fid);

for i=1:length(chAv.q2p)
	disp(chAv.q2p(i))
	

end
// Set thermal power to 150%
// Iterate through G_grid
Thermal_core_power = 1.5*160*MW;
Averaged_heat_flux = Thermal_core_power/Number_of_assemblies ...
                   / (Active_core_height*Assembly_heated_perimeter);
q2p_av = Averaged_heat_flux;
disp(q2p_av)
iin = CHAN_fluidProperty(1,'h_pT',Pref,Inlet_temperature_K); // inlet enthalpy

chAv = CHAN_setOperatingConditions(chAv,Pref,iin,W,q2p_av,power_shape,grav);

fid = mopen("./data/flow_char/P_150.txt", "w");
for i=1:length(G_grid)
	
	W   = 0.95*G_grid(i)/Number_of_assemblies;
	chAv = CHAN_setOperatingConditions(chAv,Pref,iin,W,q2p_av,power_shape,grav, rpf);
	chAv = CHAN_solver(chAv);
    	print(fid,chAv.Dpz($));
    	disp(chAv.Dpz_acc)
    	//disp(G_grid(i), chAv.Dpz(-1));
end
mclose(fid);

// Set thermal power to 50%
// Iterate through G_grid
Thermal_core_power = 0.5*160*MW;
Averaged_heat_flux = Thermal_core_power/Number_of_assemblies ...
                   / (Active_core_height*Assembly_heated_perimeter);
q2p_av = Averaged_heat_flux;
iin = CHAN_fluidProperty(1,'h_pT',Pref,Inlet_temperature_K); // inlet enthalpy

chAv = CHAN_setOperatingConditions(chAv,Pref,iin,W,q2p_av,power_shape,grav, rpf);

fid = mopen("./data/flow_char/P_050.txt", "w");
for i=1:length(G_grid)
	W   = 0.95*G_grid(i)/Number_of_assemblies;
	chAv = CHAN_setOperatingConditions(chAv,Pref,iin,W,q2p_av,power_shape,grav, rpf);
	chAv = CHAN_solver(chAv);
    	print(fid,chAv.Dpz($));
    	//disp(G_grid(i), chAv.Dpz($));
end
mclose(fid);


// Set thermal power to 0%
// Iterate through G_grid
Thermal_core_power = 0.0*160*MW;
Averaged_heat_flux = Thermal_core_power/Number_of_assemblies ...
                   / (Active_core_height*Assembly_heated_perimeter);
q2p_av = Averaged_heat_flux;
iin = CHAN_fluidProperty(1,'h_pT',Pref,Inlet_temperature_K); // inlet enthalpy

chAv = CHAN_setOperatingConditions(chAv,Pref,iin,W,q2p_av,power_shape,grav, rpf);
fid = mopen("./data/flow_char/P_000.txt", "w");
for i=1:length(G_grid)
	W   = 0.95*G_grid(i)/Number_of_assemblies;
	chAv = CHAN_setOperatingConditions(chAv,Pref,iin,W,q2p_av,power_shape,grav, rpf);
	chAv = CHAN_solver(chAv);
    	print(fid,chAv.Dpz($));
    	//disp(G_grid(i), chAv.Dpz($));
end
mclose(fid);





// Create now a "hot channel" with peaking factor 1.4
//
//chHot = chAv;    // Copy from the average channel
//
// Set higher power, keeping all other parameters the same
//
//chHot.q2p = chAv.q2p * 1.4;
//
// Solve the channel
//
//chHot = CHAN_solver(chHot);
//scf(3);clf
//subplot(2,2,1);plot(chHot.z,chHot.Dpz); title("Pressure as f(z): hot channel");
//subplot(2,2,2);plot(chHot.z,chHot.iz); title("Specific enthalpy as f(z)");
//subplot(2,2,3);plot(chHot.z,chHot.xe); title("Equilibrium quality as f(z)");
//subplot(2,2,4);plot(chHot.z,chHot.vf); title("Void as f(z): hot channel");
//halt("Press Enter to continue:");



