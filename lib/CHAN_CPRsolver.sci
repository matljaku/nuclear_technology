function [DNBR]=CHAN_CPRsolver(chin)
// This function finds the DNBR in every node
// 
// On input:
// chin - channel list with the actual conditions

// On output:
// CPR - critical power ratio
        z    = chin.z;
        Pref = chin.Pref;
        iin  = chin.iin;
        Dh   = chin.Dh;
        Ph   = chin.Ph;
        Axs  = chin.Axs;
        q2p  = chin.q2p;
        G    = chin.G;
        W    = G(1)*Axs(1);
        iz   = CHAN_enthalpy(z,Ph,q2p,iin,W);
    
	// Define pipe dimensions and operating conditions
	L = 10; // Pipe length (m)
	D = 0.1; // Pipe diameter (m)
	Q = 100; // Heat flux (W/m^2)
	P = 5e6; // Pressure (Pa)
	T = 300; // Temperature (K)
	mdot = 1; // Mass flow rate (kg/s)
	c = 5000; // Specific heat capacity (J/kg-K)
	rho = 1000; // Density (kg/m^3)
	k = 0.6; // Thermal conductivity (W/m-K)

	// Define discretization parameters
	N = 100; // Number of nodes
	dx = L/N; // Node spacing (m)

	// Initialize arrays for node properties
	x = 0:dx:L; // Node positions (m)
	A = pi/4*D^2; // Cross-sectional area (m^2)
	V = A*dx; // Volume (m^3)
	T_node = T*ones(1,N+1); // Temperature (K)
	h_node = zeros(1,N+1); // Heat transfer coefficient (W/m^2-K)

	// Iterate over nodes and calculate heat transfer properties
	for i = 1:length(z)
	    Re = mdot*rho*D/(V(i)*mu(T_node(i))); // Reynolds number
	    Pr = c*mu(T_node(i))/k; // Prandtl number
	    h_node(i) = Nu(Re,Pr)*k/D; // Nusselt number
	end

	// Calculate DNBR for each node
	DNBR = zeros(1,N+1);
	for i = 1:N+1
	    q_node = Q/(A*dx); // Local heat flux (W/m^2)
	    q_crit = q_critical(P,T_node(i)); // Critical heat flux (W/m^2)
	    DNBR(i) = (q_node - q_crit)/(h_node(i)*(q_crit/Q - 1)); // DNBR
	end

	// Define functions for dynamic viscosity and Nusselt number correlations
	function mu = mu(T)
	    mu = 1e-3*exp(2500/T); // Sutherland's law
	end

	function Nu = Nu(Re,Pr)
	    Nu = 0.023*Re^(4/5)*Pr^0.3; // Dittus-Boelter correlation
	end

	function q_crit = q_critical(P,T)
	    q_crit = 1e6*0.067*(P/1e6)^0.8*(T/100)^2.5; // Groeneveld correlation
	end

endfunction
