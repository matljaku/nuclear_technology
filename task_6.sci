// Script to run BWR/6 average and hot channels
// Before running: generate and load
// CHAN library
//--------------------------


// BEFOR RUNNING: exec ./lib/CHAN_temperature_solver.sci
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
D_ci 		     = 8.2804*mm;	//Cladding inner diameter
D_co 		     = 9.4996*mm;	//Cladding outter diameter
D_fo 		     = 8.1153*mm;	//Fuel pellet diameter
Assembly_width       = 214.9*mm; 
P       = 12.59*mm; 
//
Assembly_heated_perimeter = %pi*Fuel_rod_OD * Number_of_fuel_rods;
Averaged_heat_flux = Thermal_core_power/Number_of_assemblies ...
                   / (Active_core_height*Assembly_heated_perimeter);
                   
A_f = chAv.Axs;
A = Assembly_width;

epsilon = [];
disp(A)

// Osmachkin correlation for "effective" hydraulic diameter
for i=1:length(A_f)
	epsilon(i) = (A-A_f(i))/A;
end


D_h = chAv.Dh;
D_eff = Osmachkin(epsilon, D_h);
disp(D_eff)
q2p_av = Averaged_heat_flux;
z = chAv.z;  // vector with node coordinates, length nk

rpf = 1;
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


chAv.q2p = 1.3775 * chAv.q2p
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

// Task 5 - calculation of the temp
// Parameters

G = 0.95*chAv.G(1);
q2p = chAv.q2p;
chAv = CHAN_solver(chAv);
press = Pref + chAv.Dpz;				
itemp = CHAN_fluidProperty(z,'T_ph', press, chAv.iz);  // Temperature distribution

disp(press($));
disp(itemp($));

Tsat = CHAN_fluidProperty(z,'Tsat_p',press); // Saturated temperature
//c_p = CHAN_fluidProperty(z, 'Cp_pT', press, itemp); // [J/kg*K]
c_pl = CHAN_fluidProperty(z, 'Cp_pT', press, Tsat - 0.01);
c_pv = CHAN_fluidProperty(z, 'Cp_pT', press, Tsat + 0.01);

my_l = CHAN_fluidProperty(z,'my_pT',press,Tsat-0.01); // To ensure liquid
my_v = CHAN_fluidProperty(z,'my_pT',press,Tsat+0.01); // To ensure vapour

k_fl = CHAN_fluidProperty(z, 'tc_pT', press, Tsat-0.01);
k_fv = CHAN_fluidProperty(z, 'tc_pT', press, Tsat+0.01);

v_f = chAv.vf
x_a = chAv.xa
disp(x_a)
sigma = 20.6537*1e-3 * ones(length(itemp));
for i=1:length(my_l)
	my(i) = (1-x_a(i))*my_l(i) + x_a(i)*my_v(i);
	c_p(i) = (1-x_a(i))*c_pl(i) + x_a(i)*c_pv(i);
	k_f(i) = (1-x_a(i))*k_fl(i) + x_a(i)*k_fv(i);
end
//disp(my)
//disp(c_p)

c_p = CHAN_fluidProperty(z, 'Cp_pT', press, itemp);
my = CHAN_fluidProperty(z,'my_pT',press, itemp);
k_f = CHAN_fluidProperty(z, 'tc_pT', press, itemp);

rho_l = CHAN_fluidProperty(z, 'rhoL_p', press); //[kg/m^3]
rho_v = CHAN_fluidProperty(z, 'rhoV_p', press);
Delta_p = CHAN_fluidProperty(z, 'psat_T', itemp) - press;
i_sat = CHAN_fluidProperty(z, 'hV_p', press);
// Helium conductivity for p = 4MPa and T = 630
h_g = 3658 // [W/m^2*K]



Pr = Prandtl(c_p, my, k_f);
Re = Reynolds(G, A_f, D_h, my);
//Nu = DittusBoelter(Re, Pr, x_a, rho_l, rho_v, my_l, my_v, G*ones, D_h, k_fl, c_pl, sigma, i_sat, Delta_p, k_f);
Nu = DittusBoelter(Re, Pr);
h = HeatTransferCC(Nu, D_h, k_f);


disp("Reynolds number:")
disp(Re)
disp("Prandtl number:")
disp(Pr)
D_f = 0.0 // We want the temperature in the center of the fuel pellet


temp_cout = CladdingOutterTemp(itemp, q2p, h);
temp_cin  = CladdingInnerTemp(D_co, D_ci, q2p, a, b, temp_cout);
temp_fout = FuelOutterTemp(h_g, D_fo, D_ci, q2p, temp_cin);
temp_fcen = FuelCenterTemp(D_co,q2p, temp_fout, c, d, D_f, D_fo);

disp("cladding outter temp")
disp(temp_cout)
disp("cladding inner temp")
disp(temp_cin)
disp("fuel pellet outter temp")
disp(temp_fout)
disp("gap gradient:")
disp((temp_fout-temp_cin)/((D_ci - D_fo)/2))
disp("fuel center temp")
disp(temp_fcen)


fid = mopen("./data/temp/dz.txt", "w");
for i=1:length(chAv.z)
    print(fid,chAv.z(i));
end
mclose(fid);
fid = mopen("./data/temp/it.txt", "w");
for i=1:length(chAv.z)
    print(fid,itemp(i));
end
mclose(fid);
fid = mopen("./data/temp/temp_cout.txt", "w");
for i=1:length(chAv.z)
    print(fid,temp_cout(i));

end
mclose(fid);
fid = mopen("./data/temp/temp_cin.txt", "w");
for i=1:length(chAv.z)
	 print(fid,temp_cin(i));
end
mclose(fid);

fid = mopen("./data/temp/temp_fout.txt", "w");
for i=1:length(chAv.z)
	 print(fid,temp_fout(i));
end
mclose(fid);
fid = mopen("./data/temp/temp_fcen.txt", "w");
for i=1:length(chAv.z)
	 print(fid,temp_fcen(i));
end
mclose(fid);


fid = mopen("./data/temp/dvf.txt", "w");
for i=1:length(chAv.z)
	 print(fid,chAv.vf(i));
end
mclose(fid);


t_max_clad = max(temp_cin);
index_max_clad = find(t_max_clad == temp_cin);

disp(t_max_clad);
disp(z(index_max_clad));

t_max_fuel = max(temp_fcen);
index_max_fuel = find(t_max_fuel == temp_fcen);

disp(t_max_fuel);
disp(z(index_max_fuel));

halt("Press Enter to continue:");

// Iterations for radial pellet

r_fp = linspace(0.0, D_fo-0.1*mm, 10);
disp(r_fp)
fid = mopen("./data/temp/temp_fuel_db.txt", "w");
for i=1:length(r_fp)
	temp_fcen = FuelCenterTemp(D_co,q2p, temp_fout, c, d, r_fp(i));
	//disp(r_fp(i));
	disp(temp_fcen(index_max_fuel));
	
	
	print(fid,temp_fcen(index_max_fuel));
		
	
	
end
mclose(fid);
fid = mopen("./data/temp/fuel_temp_dr.txt", "w");
	for i=1:length(r_fp)
		print(fid, r_fp(i));

	end
mclose(fid);


