function [center_fitA,A_fit_matrix,A3_fit,c_A] = calculate2_trap_Apara_poly(center_data,x,y,z,static_matrix,A_matrix,um,q,mass,Omega_rf)
%calculate the center point and trap frequency by poly function fit after
%find the center points by matrix
%%¡¡the plot range set 
nnx=35; nny=35; nnz=40;
rrx=10; rry=8; rrz=8;
A_C=(4*q)/(mass*Omega_rf^2);
%% 
xr_plot=[-rrx*um+center_data(1),rrx*um+center_data(1),nnx]; % x plotting range around center_X
yr_plot=[-rry*um+center_data(2),rry*um+center_data(2),nny];  %  y plotting range around center_Y
zr_plot=[-rrz*um+center_data(3),rrz*um+center_data(3),nnz]; % the plot range

[xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
nx=xr_plot(3)+1; ny=yr_plot(3)+1; nz=zr_plot(3)+1;  % the number and length of plot XYZ
n_plot_all=nx*ny*nz; % the number of all points
static_q_matrix= interp3(x,y,z,static_matrix,xq,yq,zq); %¡¡enlarge the matrix of static potential
Aq_matrix= interp3(x,y,z,A_matrix,xq,yq,zq);% enlarge the matrix of pseudo potential
%%¡¡ploy fit to calculate C

xr_plot=[-rrx*um,rrx*um,nnx]; % x plotting range around center_X
yr_plot=[-rry*um,rry*um,nny];  %  y plotting range around center_Y
zr_plot=[-rrz*um,rrz*um,nnz]; % the plot range
[xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
X=zeros(n_plot_all,3);
X(:,1)=reshape(xq,n_plot_all,1); X(:,2)=reshape(yq,n_plot_all,1); X(:,3)=reshape(zq,n_plot_all,1);

Y=zeros(n_plot_all,1);
Y(:,1)=reshape(Aq_matrix,n_plot_all,1);

c0=[1,1,1,0,0,0,0,0,0,0];
c = nlinfit(X,Y,@myfun_trapfrequency_pseudo,c0);
c_A=c; % record the c parameter 
%% record Ax Ay Az and return the function 
A3_fit(1)=A_C*2*c(1);
A3_fit(2)=A_C*2*c(2);
A3_fit(3)=A_C*2*c(3);
%%  record the A matrix and return
A_fit_matrix=A_C*[2*c(1),c(4),c(6); c(4),2*c(2),c(5); c(6),c(5),2*c(3)];

%% center for A potential by fit equation 
syms xc yc zc
eqns = [2*c(1)*xc + c(4)*yc + c(6)*zc +c(7) == 0, 2*c(2)*yc+c(4)*xc+c(5)*zc+c(8)== 0, 2*c(3)*zc+c(5)*yc+c(6)*xc+c(9)==0];
vars = [xc,yc,zc];
center_struct=solve(eqns, vars);
center_fitA(1)=double(center_struct.xc)+center_data(1);
center_fitA(2)=double(center_struct.yc)+center_data(2);
center_fitA(3)=double(center_struct.zc)+center_data(3);


end


