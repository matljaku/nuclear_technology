function [Pr] =  Prandtl(c_p, mu, k_f);
	
	for i=1:length(c_p)
		Pr(i) = (c_p(i)*mu(i))/k_f(i);
	
	end
endfunction

function [Re] =  Reynolds(G, A_f, D_h, mu);
	
	for i=1:length(c_p)
		Re(i) = (G*D_h(i))/(A_f(i)*mu(i));
	
	end
endfunction


//function [Nu] = Chen(q2p, xa, press, G_density, )
function [Nu] = Chen(x_a, rho_l, rho_v, my_l, my_v, G, D_h, k_fl, c_pl, sigma, i_sat, Delta_p, k_f)
	X_tt = ((1 - x_a)/x_a)^0.9 * (rho_g/rho_f)^0.5 * (mu_l/mu_v)^0.1;
	Re = (G*(1 - x_a)*D_h)/mu_l;
	Pr = (c_pl * my_l)/k_fl;
	if X_tt^(-1) < 0.1;
		F = 1;
	else
		F = 2.35*(0.213  + 1/X_tt)^0.736;
	end
	
	S = (1 + 2.56e-6 * F^(1.463) * Re^(1.17))^(-1)
	
	h_mac = 0.023 * (k_fl/D_h) * Re^(0.8) * Pr^(0.4) * F
	DeltaT = 20;
	epsilon = 2;
	while epsilon > 1
		h_mic = 0.00122*((k_fl^(0.79) * c_pl^(0.45) * rho_l^(0.49))/(sigma^(0.5) * my_l^(0.29) * i_sat^(0.24) * rho_v^(0.24)))*DeltaT^(0.24)*(Delta_p)^0.75 * S;            
		
		h = h_mac + h_mic;
		new_DeltaT = q2p/h;
		
		epsilon = abs(new_DeltaT - DeltaT);
		DeltaT = new_DeltaT;
	end
	Nu = (D_h * h)/k_fl;
endfunction

function [Nu] = DittusBoelter(Re, Pr)
	for i=1:length(Re)


		//if x_a(i) == 0 
		Nu(i) = 0.023*Re(i)^(0.8)*Pr(i)^(0.4);		
		//else 
		//Nu(i) = Chen(x_a(i), rho_l(i), rho_v(i), my_l(i), my_v(i), G(i), D_h(i), k_fl(i), c_pl(i), sigma(i), i_sat(i), Delta_p(i), k_f(i))
		//end
	end
endfunction



function [D_eff] = Osmachkin(epsilon, D_h)
	for i=1:length(D_h)
		D_eff(i) = D_h(i)*2*( ((epsilon(i) - 3)/(2)) - ((log(epsilon(i)))/(1 - epsilon(i))))/(1 - epsilon(i))^2  ;
	end 
endfunction

function [Nu] = Weissman(P, D_co, Re, Pr)
	for i=1:length(Re)
		Nu(i) = (0.042 * P / D_co - 0.024)*Re(i)^0.8 * Pr(i)^(1/3);
	end
endfunction

function [Nu] = Markoczy(P, D_co, Re, Pr, Nu_DB)
	for i=1:length(Re)
		Nu(i) = (1+0.91*Re(i)^(-0.1)*Pr(i)^(0.4)*(1-2*exp(-(4/%pi*(P/D_co)^2-1))))*Nu_DB(i);
	end
endfunction

function [h] = HeatTransferCC(Nu, D_h, k_f)
	for i=1:length(Nu)
		h(i) = (Nu(i)*k_f(i))/D_h(i);
	end

endfunction

function [temp_cout] = CladdingOutterTemp(itemp, q2p, h)
	for i=1:length(itemp)
		temp_cout(i) = itemp(i) + (q2p(i))/h(i);
	end
endfunction

function [k_clad] = CladdingConductivity(T)
	for i=1:length(T)
		k_clad = 12.6 + 0.0118*(T-273.15); 
	
	end
endfunction


// Parameters of cladding function
a = 12.6;
b = 0.0118;


function [temp_cin] = CladdingInnerTemp(D_co, D_ci, q2p, a, b, temp_cout) 
	for i=1:length(temp_cout)
		temp_cin(i) = (sqrt((%pi*(a + b*temp_cout(i))^2)+(b*q2p(i)*%pi*D_co*log(D_co/D_ci)))-(sqrt(%pi)*a))/(sqrt(%pi)*b);
	end
endfunction




function [temp_fout] = FuelOutterTemp(h_g, D_fo, D_ci, q2p, temp_cin)
	for i=1:length(temp_cin)
		temp_fout(i) = temp_cin(i) + (q2p(i)*(D_co/D_fo))/(h_g);	
	end
endfunction

c = -0.00367452;
d = 7.14185;

function [temp_fcen] = FuelCenterTemp(D_co, q2p, temp_fout, c, d, D_f, D_fo)
	for i=1:length(temp_fout)
		//temp_fcen(i) = 938.53 - 250142330302.0/(9331429085151291.0* temp_fout(i)^3 - 26273590188374911500.0 * temp_fout(i)^2 + sqrt((9331429085151291.0* temp_fout(i)^3 ...
		//- 26273590188374911500.0 * temp_fout(i)^2 + 51058249855624930500000.0* temp_fout(i) + 4986371470612500000000 * q2p(i) * D_co/2.0 - 32491244242442317500000000)^2 ...
		//+ 292105496937191704046730580849683357339506339479552) + 51058249855624930500000 * temp_fout(i) + 4986371470612500000000.0 *q2p(i)* (D_co/2) ...
		 //- 32491244242442317500000000.0)^(1/3);

		q_l = q2p * %pi * D_co;
		temp_fcen(i) = (-d +sqrt( d^2 + (c * q_l(i) * (1 - (D_f/D_fo)^2 ) / (2 * %pi)) + c^2 * temp_fout(i)^2 + 2* d * c * temp_fout(i)) )/(c)	
		//temp_fcen(i) = 1/36.0 * (sqrt(1296.0 *temp_fout(i)^2 - 3563928.0 * temp_fout(i) - 360000.0*q2p(i)*(D_co/2.0) + 2450151001.0) + 49499.0)
		//temp_fcen(i) = (sqrt((%pi*(d + c*temp_fout(i))^2)+(b*q2p(i)*%pi*D_co*log(D_co/D_ci)))-(sqrt(%pi)*a))/(sqrt(%pi)*b);		 
	end


endfunction
