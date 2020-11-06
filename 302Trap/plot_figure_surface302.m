%% the setting of surface trap
Z=1;
q=Z*1.60218*10^(-19); %% use yb 171 + the q=1e 
ee0=8.855*10^(-12);   %% coulomb force 
k_c=q/(4*pi*ee0); %
Omega_rf=19.8*(2*pi)*10^6; %for example  250V 20Mhz
mass=171*1.66*10^(-27); % 
U0=1; %U0=(q/(mass*um^2*(Omega_rf/2)^2)); 
pseudo_C=(q)/(4*mass*Omega_rf^2);

%% voltage setting
Vrf=330;
V_dcsegement=[1.95,3.949,-2.76,1.14,-4.5677,-2.515,-2.768,-1.137,1.923,3.923,0.3542,-0.266];
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

%% plot the figure of real potential field rough 
%%%%%%%%%%%%%%%%%%%% plot figure in former way, plot directly %%%%%%%%%%%%%%%%%%%%%%%%%%

%% plot_xz figure, Y==y_want;
y_want=0;
plot_switch=0;plot_density=20;
[x_plot,z_plot,potential_plot] = calplot_xzplane_real_potential(plot_switch,plot_density,yr,y_want,nx,ny,nz,points,static_potential);

%% plot YZ Plane of pseudo potential as the range you want
%%%%%%%%%%%%%% plot it in any range as you want %%%%%%%%%%%%%%%%%
xr_plot=xr;
yr_plot=[-20*um,20*um,25];
zr_plot=[60*um,180*um,25];
x_want=(DC_X+gap_X)/2;
plot_switch=0;plot_density=30;
% plot all pseudo potential in the region you want (defined by [xr_plot,yr_plot,zr_plot])
title_txt='The All pseudo potential field on YZ plane when x==x_{want}'; 

[y_plot,z_plot,potential_plot,center_pseudo_DC_ini] = Plot_YZ_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,pseudo2_matrix,title_txt);
% plot only RF pseudo potential in the region you want (defined by [xr_plot,yr_plot,zr_plot])
title_txt='The RF pseudo potential field on YZ plane when x==x_{want}'; 
[y_plot,z_plot,potential_plot,center_pseudo_RF_ini] = Plot_YZ_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,RF_pseudo_matrix,title_txt);

% here, the center_pseudo potential is very important to give you  a inital

%% calculate the trap center and frequency by matrix operation 
rrx=20*um; rry=20*um; rrz=20*um;  % define the region for calculate center point by 
center_ini=[(DC_X+gap_X)/2,0,80*um];  % the initial center point for trying 
% calculate the center point of all pseudo potential field 
[center_pseudo,difference_center_data,center_round] = find_center_bymatrix(center_ini,x,y,z,static_matrix,pseudo2_matrix,um,rrx,rry,rrz);
% calculate the center point of only RF potential field 
[center_RF,difference_center_data,center_round] = find_center_bymatrix(center_ini,x,y,z,RF_static_matrix,RF_pseudo_matrix,um,rrx,rry,rrz);

%% find center point by find minimum point in pseudo potential matrix 
xr_plot=[(DC_X+gap_X)/2-20*um,(DC_X+gap_X)/2+20*um,40];
yr_plot=[-20*um,20*um,40];
zr_plot=[68*um,85*um,40];
[center_by_min] = find_center_by_minimum(x,y,z,pseudo2_matrix,xr_plot,yr_plot,zr_plot)


%% calculate the trap frequency
% this function is to calculate trap frequency 
[center_fit_byTF,H_matrix_fit,omega3,frequency3,c_H,H_fit_V,H_fit_D]= calculate2_trap_freq_poly(center_pseudo,x,y,z,static_matrix,pseudo2_matrix,um,q,mass);
%% use fitting method to calculate trap frequency 
%[center_fit_trapF,H_matrix_fit,omega3,frequency3,c_H,H_V_fit,H_fit] = calculate_trap_freq_byfitting(center_pseudo,x,y,z,static_matrix,pseudo2_matrix,um,q,mass);

%% calculate the A Q matrix of trapped ions 
[center_fitA,A_fit_matrix,A3_fit,c_A] = calculate2_trap_Apara_poly(center_pseudo,x,y,z,static_matrix,A_matrix,um,q,mass,Omega_rf); 
[center_fitQ,Q_fit_matrix,Q3_fit,c_Q] = calculate2_trap_Qpara_poly(center_pseudo,x,y,z,static_matrix,Q_matrix,um,q,mass,Omega_rf);


 %% plot YZ Plane of pseudo potential in the range as  you want for center 
xr_plot=[-15*um+center_pseudo(1),15*um+center_pseudo(1),25];
yr_plot=[-15*um+center_pseudo(2),15*um+center_pseudo(2),25];
zr_plot=[-15*um+center_pseudo(3),15*um+center_pseudo(3),40];
x_want=center_pseudo(1);
plot_switch=0; plot_density=10;
title_txt='The All pseudo potential field around center '; 
[y_plot,z_plot,potential_plot,center_pseudo_PP,pseudo_PPdepth_center] = Plot_YZ_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,pseudo2_matrix,title_txt);


 %% plot the static potential field around the center point
xr_plot=[-15*um+center_pseudo(1),15*um+center_pseudo(1),20];
yr_plot=[-15*um+center_pseudo(2),15*um+center_pseudo(2),25];
zr_plot=[-15*um+center_pseudo(3),15*um+center_pseudo(3),44];
x_want=center_pseudo(1);
plot_switch=0; plot_density=10;
title_txt='The All static potential field around center'; 
[y_plot,z_plot,potential_plot] = Plot_YZ_static_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,static_matrix,title_txt);

%% plot the  pseudo potential field along the X axis(RF's direction= axial direction)
xr_plot=[-30*um+center_pseudo(1),30*um+center_pseudo(1),80];
yr_plot=[-10*um+center_data(2),10*um+center_data(2),8];
zr_plot=[-10*um+center_data(3),10*um+center_data(3),8];
% the number of ny nz should be even number like 20,24
y_want=center_pseudo(2); z_want=center_pseudo(3);
plot_switch=0;
[c_2order,center_fit_xaxis_2order] = plot_Xais_arond_trap_center(plot_switch,center_data,xr_plot,yr_plot,zr_plot,x,y,z,pseudo2_matrix);


%% escape points 
xr_plot=[-40*um+center_pseudo(1),40*um+center_pseudo(1),20];
yr_plot=[-40*um,40*um,25];
zr_plot=[150*um,180*um,44];
x_want=center_pseudo(1);
plot_switch=0; plot_density=10;
title_txt='The All pseudo potential field around escape point'; 
 [y_plot,z_plot,potential_plot,center_escape,pseudo_PPdepth] = Plot_YZescape_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,pseudo2_matrix,pseudo_PPdepth_center,title_txt);

%% fprintf the information 
fprintf('The center point is at [%f um, %f  um,%f  um]\n ',center_data(1)/um,center_data(2)/um,center_data(3)/um);
fprintf('The trap depth is %f (ev) The escape point is at [%f um, %f  um,%f  um]\n',pseudo_PPdepth,  center_escape(1)/um,center_escape(2)/um,center_escape(3)/um);
fprintf('The trap frequency is wx= %f Mhz, wy=%f Mhz, wz=%f Mhz\n', frequency3(1)*10^(-6), frequency3(2)*10^(-6),frequency3(3)*10^(-6));
fprintf('A parameters are Ax=%f , Ay=%f , Az=%f \n', A3_fit(1),A3_fit(2),A3_fit(3));
fprintf('Q parameters are Qx=%f , Qy=%f , Qz=%f \n', Q3_fit(1),Q3_fit(2),Q3_fit(3));
