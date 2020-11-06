set(0,'defaultfigurecolor','w');

%% the physics parameter settings of surface trap
Z=1;
q=Z*1.60218*10^(-19); %% use yb 171 + the q=1e 
ee0=8.855*10^(-12);   %% coulomb force 
k_c=q/(4*pi*ee0); %
Omega_rf=20.6265*(2*pi)*10^6; %for example  250V 20Mhz
mass=174*1.66*10^(-27); % 
U0=1; %U0=(q/(mass*um^2*(Omega_rf/2)^2)); 
pseudo_C=(q)/(4*mass*Omega_rf^2);

%% voltage setting
Vrf=300;
V_dcsegement=[0.787,0.987,0.09,0.14,-0.71,-0.66,-0.71,-0.66,0.09,0.14,0.78,0.98,0.265,0.375];
% V_dcsegement=zeros(1,size(T_num_electrode,2)-2);
V=[Vrf,Vrf,V_dcsegement]; % voltage combine together

%% calculate potential 
%%%%%%%%%%%%%%%%%%%%% calculate the static potential %%%%%%%%%%%%%%%%
[x,y,z]=meshgrid(linspace(xr(1),xr(2),xr(3)+1),linspace(yr(1),yr(2),yr(3)+1),linspace(zr(1),zr(2),zr(3)+1)); % the matrix of points
nx=size(x,2); ny=size(x,1); nz=size(x,3);
[static_potential,static_matrix,pseudo_potential,npot,pseudo2_line,pseudo2_matrix,A_line,A_matrix,Q_line,Q_matrix,pseudo_matrix] = calculate_static_pseudo_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);
[RF_static_potential,RF_static_matrix,RF_pseudo_line,RF_pseudo_matrix]  = calculate_RF_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);
[DC_potential_line,DC_potential_matrix] = calculate_DC_static_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);
% the first manner to calculate the pesudo potential in pesudo_potential maybe wrong

%% plot YZ Plane of pseudo potential as the range you want
%%%%%%%%%%%%%% plot it in any range as you want %%%%%%%%%%%%%%%%%
xr_plot=xr;
yr_plot=[-28*um,28*um,30];
zr_plot=[80*um,120*um,40];
x_want=0;
plot_switch=0;plot_density=30;

% plot only RF pseudo potential in the region you want (defined by [xr_plot,yr_plot,zr_plot])

% RF static potential field 
title_txt='The RF static potential field on YZ plane when x==x_{want}'; 
[y_plot,z_plot] = Plot_YZ_pseudo_only_plot(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,RF_static_matrix,title_txt);

% RF pseudo potential field 
title_txt='The RF pseudo potential field on YZ plane when x==x_{want}'; 
[y_plot,z_plot,potential_plot,center_pseudo_RF_ini] = Plot_YZ_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,RF_pseudo_matrix,title_txt);

% ALL pseudo potential field 
title_txt='The ALL pseudo potential field on YZ plane when x==x_{want}'; 
[y_plot,z_plot,potential_plot,center_pseudo_all_ini] = Plot_YZ_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,pseudo2_matrix,title_txt);

% DC  potential field 
title_txt='The DC potential field on YZ plane when x==x_{want}'; 
[y_plot,z_plot] = Plot_YZ_pseudo_only_plot(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,static_matrix,DC_potential_matrix);


%% calculate the trap center and frequency by matrix operation 
rrx=20*um; rry=20*um; rrz=20*um;  % define the region for calculate center point by 
center_ini=center_pseudo_RF_ini;  % the initial center point for trying 
% calculate the center point of only RF potential field 
[center_RF,difference_center_data,center_round] = find_center_bymatrix(center_ini,x,y,z,RF_static_matrix,RF_pseudo_matrix,um,rrx,rry,rrz);
[center_pseudo,difference_center_data,center_round] = find_center_bymatrix(center_ini,x,y,z,static_matrix,pseudo2_matrix,um,rrx,rry,rrz);


%% calculate the trap frequency
% use fitting method to calculate trap frequency 
% this method include first order 
[center_fit_trapF,H_matrix_fit,omega3,frequency3,c_H,H_V_fit,H_fit] = calculate_trap_freq_byfitting(center_pseudo,x,y,z,static_matrix,pseudo2_matrix,um,q,mass);

% this fitting method doesn;t include first order 
[center_fit_trapF,H_matrix_fit,omega3,frequency3,c_H,H_V_fit,H_fit] = calculate_trap_freq_byfitting_NOfirst(center_pseudo,x,y,z,static_matrix,pseudo2_matrix,um,q,mass);
