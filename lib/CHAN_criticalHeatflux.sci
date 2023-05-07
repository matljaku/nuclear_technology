// SUB channel critical heat flux
function [q_cr] = CriticalHeatFlux_SUB(p, G_density, xe, q2p)
	a1 = 0.5328;
	a2 = 0.1212;
	a3 = -0.3040;
	a4 = 0.3285;

	c1 = 1.6151;
	c2 = 1.4066;
	c3 = 0.4843;
	c4 = -2.0749;
	
	P_cr = 22.064*1e6 // Critical pressure
	p_r = [];
	
	G_r = G_density/1356.23;
	A = [];
	B = [];
	C = [];
	for i=1:length(p)
		p_r(i) = p(i)/P_cr;
		A(i) = a1 * ( p_r(i)^a2 ) * G_r^(a3 + a4*p_r(i));
		B(i) = 3.1544*1e6;
		C(i) = c1 * (p_r(i)^c2) * G_r^(c3 + c4*p_r(i));
		q_r(i) = q2p(i)/3.1544e6
		
		
		q_cr(i) = B(i)*(A(i) - xe(1))/(C(i) + (xe(i) - xe(1))/(q_r(i)));
	end
	
 
endfunction


// Levitan and Lantsmann correlation

function [q_cr] = CriticalHeatFlux_LL(p, G, x_e)
	p = p * 1e-5
	for i=1:length(p)
		q_cr(i) = (10.3 - 7.8*p(i)/98 + 1.6*(p(i)/98)^2)*(G/1000)^(1.2*((0.25*(p(i) - 98)/98)-x_e(i)))*exp(-1.5*x_e(i))
		q_cr(i) = q_cr(i)*1e6*(8/(Fuel_rod_OD*1e3))^0.5
	
	end
endfunction
