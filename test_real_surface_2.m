%% the setting of surface trap
Z=1;
q=Z*1.60218*10^(-19); %% use yb 171 + the q=1e 元电荷
ee0=8.855*10^(-12);   %% coulomb force  介电系数
k_c=q/(4*pi*ee0); % 系数 算电场力
Omega_rf=20*(2*pi)*10^6; % 设置 加上去的rf的 电压 和 频率 2pi f, for example  250V 20Mhz
mass=174*1.66*10^(-27); % 质量
U0=1; %U0=(q/(mass*um^2*(Omega_rf/2)^2)); 电势场无量纲化，这里后来没有加上去，可以在算psi_eigen_rf的地方加入
pseudo_C=(q)/(4*mass*Omega_rf^2);
%% voltage setting
Vrf=200;
V_rf=[Vrf,Vrf]; V_dc2=[1,1];
%V_dcsegement=[1,1,1,1,-5,-5,1,1,1,1];
 V_dcsegement=zeros(1,size(T_num_electrode,2)-3);
V=[V_rf,V_dcsegement,0]; % voltage combine together

%% calculate potential
%%%%%%%%%%%%%%%%%%%%% calculate the static potential %%%%%%%%%%%%%%%%
[x,y,z]=meshgrid(linspace(xr(1),xr(2),xr(3)+1),linspace(yr(1),yr(2),yr(3)+1),linspace(zr(1),zr(2),zr(3)+1)); % the matrix of points
nx=size(x,2); ny=size(x,1); nz=size(x,3);
[static_potential,static_matrix,pseudo_potential,npot,pseudo2_line,pseudo2_matrix,A_line,A_matrix,Q_line,Q_matrix] = calculate_static_pseudo_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);
% the first manner to calculate the pesudo potential in pesudo_potential maybe wrong

%%%%%%%%%%%%%%%%%%%% plot figure in former way, plot directly %%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot the figure of potential field rough 
%% plot_xz figure, Y==y_want;
y_want=0;
plot_switch=0;plot_density=10;
[x_plot,z_plot,potential_plot] = calplot_xzplane_real_potential(plot_switch,plot_density,yr,y_want,nx,ny,nz,points,static_potential);

%%%%%%%%%%%%%% plot it in any range as you want %%%%%%%%%%%%%%%%%
%% plot YZ Plane of pseudo potential as the range you want
xr_plot=xr;
yr_plot=yr;
zr_plot=zr;
x_want=0;
plot_switch=0;plot_density=30;
[y_plot,z_plot,potential_plot,center_pseudo,pseudo_PPdepth] = Plot_YZ_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,pseudo2_matrix);
% here, the center_pseudo potential is very important to give you  a inital

%% calculate the center point and trap frequency by ploy fitting(can be ignore)
[center_fit_ini,c] = calculate_center_pyfit(center_pseudo,x,y,z,static_matrix,pseudo2_matrix,um); %the center fit is a rough result, but not precise result 

%% calculate the trap center and frequency by matrix operation 
rrx=20*um; rry=15*um; rrz=15*um;  
[center_data,difference_center_data,center_round] = find_center_bymatrix(center_fit_ini,x,y,z,static_matrix,pseudo2_matrix,um,rrx,rry,rrz);

%% calculate the trap frequency
[center_fitF,H_fit_matrix,omega3,frequency3,c_H,H_fit_V,H_fit_D]= calculate2_trap_freq_poly(center_data,x,y,z,static_matrix,pseudo2_matrix,um,q,mass);

%% calculate the A Q matrix of trapped ions 
[center_fitA,A_fit_matrix,A3_fit,c_A] = calculate2_trap_Apara_poly(center_data,x,y,z,static_matrix,A_matrix,um,q,mass,Omega_rf); 
[center_fitQ,Q_fit_matrix,Q3_fit,c_Q] = calculate2_trap_Qpara_poly(center_data,x,y,z,static_matrix,Q_matrix,um,q,mass,Omega_rf);


 %% plot YZ Plane of pseudo potential in the range as  you want for center 
xr_plot=[-15*um+center_data(1),15*um+center_data(1),20];
yr_plot=[-20*um+center_data(2),20*um+center_data(2),25];
zr_plot=[-30*um+center_data(3),30*um+center_data(3),44];
x_want=center_data(1);
plot_switch=0; plot_density=10;
 [y_plot,z_plot,potential_plot,center_pseudo_PP,pseudo_PPdepth_center] = Plot_YZ_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,pseudo2_matrix);
 pseudo_PPcenter(1)=x_want;

 %% just plot the static potential field around the center point
xr_plot=[-15*um+center_data(1),15*um+center_data(1),20];
yr_plot=[-20*um+center_data(2),20*um+center_data(2),25];
zr_plot=[-30*um+center_data(3),30*um+center_data(3),44];
x_want=center_data(1);
plot_switch=0; plot_density=10;
[y_plot,z_plot,potential_plot] = Plot_YZ_static_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,static_matrix);

%% plot the  pseudo potential field along the X axis(RF's direction)

xr_plot=[-30*um,30*um,80];
yr_plot=[-10*um+center_data(2),10*um+center_data(2),8];
zr_plot=[-10*um+center_data(3),10*um+center_data(3),8];
% the number of ny nz should be even number like 20,24
y_want=center_data(2); z_want=center_data(3);
plot_switch=0;
[c_2order,center_fit_xaxis_2order] = plot_Xais_arond_trap_center(plot_switch,center_data,xr_plot,yr_plot,zr_plot,x,y,z,pseudo2_matrix);


%% escape points 
xr_plot=[-15*um+center_data(1),15*um+center_data(1),20];
yr_plot=[-8*um,24*um,25];
zr_plot=[150*um,180*um,44];
x_want=center_data(1);
plot_switch=0; plot_density=10;
 [y_plot,z_plot,potential_plot,center_escape,pseudo_PPdepth] = Plot_YZescape_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,pseudo2_matrix,pseudo_PPdepth_center);

%% fprintf the information 
fprintf('The center point is at [%f um, %f  um,%f  um]\n ',center_data(1)/um,center_data(2)/um,center_data(3)/um);
fprintf('The trap depth is %f (ev) The escape point is at [%f um, %f  um,%f  um]\n',pseudo_PPdepth,  center_escape(1)/um,center_escape(2)/um,center_escape(3)/um);
fprintf('The trap frequency is wx= %f Mhz, wy=%f Mhz, wz=%f Mhz\n', frequency3(1)*10^(-6), frequency3(2)*10^(-6),frequency3(3)*10^(-6));
fprintf('A parameters are Ax=%f , Ay=%f , Az=%f \n', A3_fit(1),A3_fit(2),A3_fit(3));
fprintf('Q parameters are Qx=%f , Qy=%f , Qz=%f \n', Q3_fit(1),Q3_fit(2),Q3_fit(3));
