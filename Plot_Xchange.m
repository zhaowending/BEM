%% potential
figure
zzr_height=linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1);
[Plot_x,Plot_z]=meshgrid(xxr_height,zzr_height);
Plot_x=Plot_x'; Plot_z=Plot_z';
contourf(Plot_x,Plot_z,Plot_H_ydata_ao,plot_density);
hold on 
plot(xxr_height,center_XH_Ao(:,3),'r','LineWidth',4);
hold on
plot(xxr_height,center_XH_TU(:,3),'y','LineWidth',4);
hold on
title('Pseudo potnetial field on XZ plane'); 
xlabel('X(m)');
ylabel('Z(m)');
legend('Potential Field','Before optimization','After optimization')

%% Q 

figure
plot(xxr_height,Q_XH_ao(:,1),'LineWidth',3);
hold on
plot(xxr_height,Q_XH_ao(:,2),'LineWidth',3);
hold on
plot(xxr_height,Q_XH_ao(:,3),'LineWidth',3);
hold on
plot(xxr_height,Q_XH_tu(:,1),'--','LineWidth',3);
hold on
plot(xxr_height,Q_XH_tu(:,2),'--','LineWidth',3);
hold on
plot(xxr_height,Q_XH_tu(:,3),'--','LineWidth',3);
hold on 
title('Q parameter changes along X plane');
xlabel('X(m)');
ylabel('Q parameter');
legend('Q_x(After)','Q_y(After)','Q_z(After)','Q_x(Before)','Q_y(Before)','Q_z(Before)'); 

%% freqency 

figure 
plot(xxr_height,frequency_lineH_ao(:,1),'LineWidth',3);
hold on
plot(xxr_height,frequency_lineH_ao(:,5),'LineWidth',3);
hold on
plot(xxr_height,frequency_lineH_ao(:,9),'LineWidth',3);
hold on 
plot(xxr_height,frequency_lineH_TU(:,1),'--','LineWidth',3);
hold on
plot(xxr_height,frequency_lineH_TU(:,5),'--','LineWidth',3);
hold on
plot(xxr_height,frequency_lineH_TU(:,9),'--','LineWidth',3);
hold on 
title('Trap frequency changes along X plane');
xlabel('X(m)');
ylabel('Trap frequency(Mhz) ');
legend('f_x(After)','f_y(After)','f_z(After)','f_x(Before)','f_y(Before)','f_z(Before)'); 
