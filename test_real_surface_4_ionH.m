%% the setting of surface trap
Z=1;
q=Z*1.60218*10^(-19); %% use yb 171 + the q=1e 元电荷
ee0=8.855*10^(-12);   %% coulomb force  介电系数
k_c=q/(4*pi*ee0); % 系数 算电场力
mass=174*1.66*10^(-27); % 质量
x0_um=((Z^2*q^2)/ (4*pi*ee0*mass*Omega_rf^2))^(-1/3); % 长度无量纲化条件
U0=1; %U0=(q/(mass*um^2*(Omega_rf/2)^2)); 电势场无量纲化，这里后来没有加上去，可以在算psi_eigen_rf的地方加入
pseudo_C=(q)/(4*mass*Omega_rf^2);
%% voltage setting
Omega_rf=20*(2*pi)*10^6; % 设置 加上去的rf的 电压 和 频率 2pi f, for example  250V 20Mhz
Vrf=200;
V_rf=[Vrf,Vrf]; V_dc2=[1,1];
%V_dcsegement=[1,1,1,1,-5,-5,1,1,1,1];
 V_dcsegement=zeros(1,size(T_num_electrode,2)-3);
V=[V_rf,V_dcsegement,0]; % voltage combine together
center_data_ini=[-3.15929435618854e-08,7.54503959499008e-06,8.67711517460073e-05];
%% calculate potential
%%%%%%%%%%%%%%%%%%%%% calculate the static potential %%%%%%%%%%%%%%%%
[x,y,z]=meshgrid(linspace(xr(1),xr(2),xr(3)+1),linspace(yr(1),yr(2),yr(3)+1),linspace(zr(1),zr(2),zr(3)+1)); % the matrix of points
nx=size(x,2); ny=size(x,1); nz=size(x,3);
[static_potential,static_matrix,pseudo_potential,npot,pseudo2_line,pseudo2_matrix,A_line,A_matrix,Q_line,Q_matrix] = calculate_static_pseudo_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);
% the first manner to calculate the pesudo potential in pesudo_potential maybe wrong

%% set the range on X axis which you want to calculate trap's height
xr_height=[-90*um,90*um,36];
xxr_height=linspace(xr_height(1),xr_height(2),xr_height(3)+1);
n_height=size(xxr_height,2);
center_XH=zeros(n_height,3); frequency_XH=zeros(n_height,3); Q_XH=zeros(n_height,3); 
frequency_lineH=zeros(n_height,9); H_lineH=zeros(n_height,9); 
figure
for round=1:n_height
    x_now=xxr_height(round);
    %% plot the YZ axis when X==x_want, line(round)
    xr_plot=[-15*um+x_now,15*um+x_now,20];
    yr_plot=[-12*um+center_data_ini(2),12*um+center_data_ini(2),25];
    zr_plot=[-15*um+center_data_ini(3),30*um+center_data_ini(3),44];
    plot_switch=1; plot_density=10;
    [y_plot,z_plot,potential_plot,center_pseudo_PP,pseudo_PPdepth_center] = Plot_YZ_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_now,x,y,z,pseudo2_matrix);
    center_XH(round,:)=center_pseudo_PP;
    subplot(7,7,round)
    [C,h]=contourf(y_plot,z_plot,potential_plot,plot_density);
%     clabel(C,h)
%     colorbar
%     title('The pseudo potential field on YZ plane of x==x_{want}');
%     xlabel('Y axis perpendicular to RF electrode');
%     ylabel('Z axis along gravity vertical ');
    hold on
    %%  record the center line along Y axis of the center on different X position and prepare to plot 
    [Plot_H_ydata(round,:),Plot_H_ydata_Mean(round,:)]=record_Zdata(center_pseudo_PP,y_plot,z_plot,potential_plot,yr_plot,zr_plot,um); 
    %% calculate the trap frequency
    [center_fitF,H_fit_matrix,omega3,frequency3,c_H,H_fit_V,H_fit_D]= calculate2_trap_freq_poly(center_pseudo_PP,x,y,z,static_matrix,pseudo2_matrix,um,q,mass);
    frequency_XH(round,:)=frequency3; 
    for jj=1:3
        for kk=1:3 
            frequency_lineH(round,kk+(jj-1)*3)=(sqrt(abs(H_fit_matrix(jj,kk))/mass))/(2*pi);
            H_lineH(round,kk+(jj-1)*3)=H_fit_matrix(jj,kk); 
        end 
    end 
    %% calculate the A Q matrix of trapped ions
    [center_fitQ,Q_fit_matrix,Q3_fit,c_Q] = calculate2_trap_Qpara_poly(center_pseudo_PP,x,y,z,static_matrix,Q_matrix,um,q,mass,Omega_rf);
    Q_XH(round,:)=Q3_fit;     
end 
zzr_height=linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1);
[Plot_x,Plot_z]=meshgrid(xxr_height,zzr_height);
Plot_x=Plot_x'; Plot_z=Plot_z';
figure
contourf(Plot_x,Plot_z,Plot_H_ydata,plot_density);
hold on 
plot(xxr_height,center_XH(:,3),'r','LineWidth',4);
title('Pseudo potnetial field on XZ plane'); 
xlabel('X(\mum)');
ylabel('Z(\mum)');

figure
plot(xxr_height,Q_XH(:,1),'LineWidth',3);
hold on
plot(xxr_height,Q_XH(:,2),'LineWidth',3);
hold on
plot(xxr_height,Q_XH(:,3),'LineWidth',3);
title('Q parameter changes along X plane');
xlabel('X(\mum)');
ylabel('Q parameter');
legend('Q_x','Q_y','Q_z'); 

figure 
plot(xxr_height,frequency_lineH(:,1),'LineWidth',3);
hold on
plot(xxr_height,frequency_lineH(:,5),'LineWidth',3);
hold on
plot(xxr_height,frequency_lineH(:,9),'LineWidth',3);
title('Trap frequency changes along X plane');
xlabel('X(\mum)');
ylabel('Trap frequency(Mhz) ');
legend('f_x','f_y','f_z'); 
