set(0,'defaultfigurecolor','w');

%% the setting of surface trap
Z=1;
q=Z*1.60218*10^(-19); %% use yb 171 + the q=1e
ee0=8.855*10^(-12);   %% coulomb force
k_c=q/(4*pi*ee0); %
Omega_rf=20.6265*(2*pi)*10^6; %for example  250V 20Mhz
mass=174*1.66*10^(-27); %
pseudo_C=(q)/(4*mass*Omega_rf^2);

%% initial Data for trap frequency and save
file_save_name=strcat(Path,'Data_trap_f_20200926.mat');
Vrf_list=[150:25:1000]; n_round=size(Vrf_list,2);
V_dcsegement=[0.787,0.987,0.09,0.44,-0.74,-0.38,-0.74,-0.38,0.09,0.44,0.787,0.9870,0.105,0.275];


Data_save.Vrf_list=Vrf_list; Data_save.V_dcsegement=V_dcsegement;
Data_save.center_pseudo = zeros(n_round,3); Data_save.center_fit_byTF = zeros(n_round,3);
Data_save.frequency3=zeros(n_round,3);  Data_save.H_matrix_fit=zeros(3,3,n_round);
Data_save.c_H=zeros(n_round,10); Data_save.c_A=zeros(n_round,10); Data_save.c_Q=zeros(n_round,10);
Data_save.center_fitA=zeros(n_round,3); Data_save.A3_fit=zeros(n_round,3);
Data_save.A3_fit_matrix=zeros(3,3,n_round);
Data_save.center_fitQ=zeros(n_round,3); Data_save.Q3_fit=zeros(n_round,3);
Data_save.Q3_fit_matrix=zeros(3,3,n_round);
Data_save.center_escape=zeros(n_round,3); Data_save.Trap_depth=zeros(n_round,1);
Data_save.Omega_rf=Omega_rf;

%% give a list of RF voltage

for rou=1:n_round
    %% voltage setting
    Vrf=Vrf_list(rou);
    % V_dcsegement=zeros(1,size(T_num_electrode,2)-2);
    V=[Vrf,Vrf,V_dcsegement]; % voltage combine together
    
    %% calculate potential
    %%%%%%%%%%%%%%%%%%%%% calculate the static potential %%%%%%%%%%%%%%%%
    [x,y,z]=meshgrid(linspace(xr(1),xr(2),xr(3)+1),linspace(yr(1),yr(2),yr(3)+1),linspace(zr(1),zr(2),zr(3)+1)); % the matrix of points
    nx=size(x,2); ny=size(x,1); nz=size(x,3);
    [static_potential,static_matrix,pseudo_potential,npot,pseudo2_line,pseudo2_matrix,A_line,A_matrix,Q_line,Q_matrix,pseudo_matrix] = calculate_static_pseudo_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);
    [RF_static_potential,RF_static_matrix,RF_pseudo_line,RF_pseudo_matrix]  = calculate_RF_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);
    [DC_potential_line,DC_potential_matrix] = calculate_DC_static_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);
    
    
    %% calculate the trap center and frequency by matrix operation
    rrx=20*um; rry=20*um; rrz=20*um;  % define the region for calculate center point by
    center_ini=[2.02769069469840e-08,-2.18121491411814e-06,9.53619919838980e-05];  % the initial center point for trying
    % calculate the center point of all pseudo potential field
    [center_pseudo,difference_center_data,center_round] = find_center_bymatrix(center_ini,x,y,z,static_matrix,pseudo2_matrix,um,rrx,rry,rrz);
    
    %% calculate the trap frequency
    % this function is to calculate trap frequency
    [center_fit_byTF,H_matrix_fit,omega3,frequency3,c_H,H_fit_V,H_fit_D]= calculate2_trap_freq_poly(center_pseudo,x,y,z,static_matrix,pseudo2_matrix,um,q,mass);
    
    %% calculate the trap frequency by linear algebra directly
    
    %% escape points
    xr_plot=[-30*um+center_pseudo(1),30*um+center_pseudo(1),20];
    yr_plot=[-20*um,20*um,25];
    zr_plot=[120*um,220*um,44];
    x_want=center_pseudo(1);
    plot_switch=0; plot_density=10;
    title_txt='The All pseudo potential field on YZ plane around escape point ';
    [y_plot,z_plot,potential_plot,center_escape,Trap_Depth] = Plot_YZescape_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,pseudo2_matrix,pseudo_PPdepth_center,title_txt);
    
    
    %% calculate the A Q matrix of trapped ions
    [center_fitA,A_fit_matrix,A3_fit,c_A] = calculate2_trap_Apara_poly(center_pseudo,x,y,z,static_matrix,A_matrix,um,q,mass,Omega_rf);
    [center_fitQ,Q_fit_matrix,Q3_fit,c_Q] = calculate2_trap_Qpara_poly(center_pseudo,x,y,z,static_matrix,Q_matrix,um,q,mass,Omega_rf);
    
    
    %% save data
    Data_save.center_pseudo(rou,:) = center_pseudo;
    Data_save.center_fit_byTF(rou,:)= center_fit_byTF;
    Data_save.frequency3(rou,:)=frequency3;
    Data_save.H_matrix_fit(:,:,rou)=H_matrix_fit;
    Data_save.c_H(rou,:)=c_H; Data_save.c_A(rou,:)=c_A; Data_save.c_Q(rou,:)=c_Q;
    
    Data_save.center_fitA(rou,:)=center_fitA; Data_save.A3_fit(rou,:)=A3_fit;
    Data_save.center_fitQ(rou,:)= center_fitQ; Data_save.Q3_fit(rou,:)=Q3_fit;
    Data_save.A_fit_matrix(:,:,rou)=A_fit_matrix;
    Data_save.Q_fit_matrix(:,:,rou)=Q_fit_matrix;
    Data_save.center_escape(rou,:)=center_escape; Data_save.Trap_depth(rou,1)=Trap_Depth;
    
end

save(file_save_name,'Data_save')