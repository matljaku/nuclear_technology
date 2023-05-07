function [chout]=CHAN_solver(chin)
    chout = chin;
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
	press = []
    chout.iz = iz;
    grav = chin.grav;
    rgh  = chin.rgh;
    Loss = chin.Loss;
    VF_opt = chin.VF_opt;
    Cf_opt = chin.Cf_opt;
    Fi2_opt= chin.Fi2_opt;
    Fi2l_opt = chin.Fi2l_opt;
    [Dpz, Dpz_grav, Dpz_fric, Dpz_acc, Dpz_loc, vf,xa,xe,iter,DpzErr]= ...
         CHAN_pressure(z,Pref,Dh,Axs,q2p,G,iz,grav,rgh,Loss,...
                       VF_opt,Cf_opt,Fi2_opt,Fi2l_opt);
    
	
	
    chout.Dpz = Dpz;
    chout.vf  = vf;
    chout.xa  = xa;
    chout.xe  = xe;
    chout.Dpz_grav = Dpz_grav;
    chout.Dpz_fric = Dpz_fric;
    chout.Dpz_acc = Dpz_acc;
    chout.Dpz_loc = Dpz_loc;
endfunction
