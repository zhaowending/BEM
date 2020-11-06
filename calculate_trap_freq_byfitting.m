function [center_fit,H_matrix_fit,omega3,frequency3,c,H_fit_V,H_fit] = calculate_trap_freq_byfitting(center_data,x,y,z,static_matrix,pseudo2_matrix,um,q,mass)
%calculate the center point and trap frequency by poly function fit after
%find the center points by matrix, BUT it maybe wrong !!!!

%% setting the plot range, nnx is the number, rrx is the +-range 
nnx=35; nny=35; nnz=40;
rrx=10; rry=10; rrz=10;

%% 
xr_plot=[-rrx*um+center_data(1),rrx*um+center_data(1),nnx]; % x plotting range around center_X
yr_plot=[-rry*um+center_data(2),rry*um+center_data(2),nny];  %  y plotting range around center_Y
zr_plot=[-rrz*um+center_data(3),rrz*um+center_data(3),nnz]; % the plot range

[xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
nx=xr_plot(3)+1; ny=yr_plot(3)+1; nz=zr_plot(3)+1;  % the number and length of plot XYZ
n_plot_all=nx*ny*nz; % the number of all points
static_q_matrix= interp3(x,y,z,static_matrix,xq,yq,zq); %¡¡enlarge the matrix of static potential
pseudo_q_matrix= interp3(x,y,z,pseudo2_matrix,xq,yq,zq);% enlarge the matrix of pseudo potential

%%ploy fit to calculate C
xr_plot=[-rrx*um,rrx*um,nnx]; % x plotting range around center_X
yr_plot=[-rry*um,rry*um,nny];  %  y plotting range around center_Y
zr_plot=[-rrz*um,rrz*um,nnz]; 
[xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
%% fit
X=zeros(n_plot_all,3);
X(:,1)=reshape(xq,n_plot_all,1); 
X(:,2)=reshape(yq,n_plot_all,1); 
X(:,3)=reshape(zq,n_plot_all,1);

Y=zeros(n_plot_all,1);
Y(:,1)=reshape(pseudo_q_matrix,n_plot_all,1);

% myfun_trapfrequency_pseudo include 1.second order 2.cross second order 3.
% first order 4. C0 constant 

c0=[1704193.87682525,99677283.3784870,149211742.006985,-2514.13265209891,253453.131616755,-4947.07205745995,-0.828538682602669,-1.42270509426326,-238.390899938751,0.126969746246891];
c = nlinfit(X,Y,@myfun_trapfrequency_pseudo,c0);


%% slove the equation for the center point
c_H=c;
syms xc yc zc
eqns = [2*c(1)*xc + c(4)*yc + c(6)*zc +c(7) == 0, 2*c(2)*yc+c(4)*xc+c(5)*zc+c(8)== 0, 2*c(3)*zc+c(5)*yc+c(6)*xc+c(9)==0];
vars = [xc,yc,zc];
center_struct=solve(eqns, vars);
center_fit(1)=double(center_struct.xc)+center_data(1);
center_fit(2)=double(center_struct.yc)+center_data(2);
center_fit(3)=double(center_struct.zc)+center_data(3);
%% calculate trap frequency

% define pseudo potential (syms parameter) Psi
Psi= c(1)*xc^2+c(2)*yc^2+c(3)*zc^2+c(4)*xc*yc+c(5)*yc*zc+c(6)*xc*zc+c(7)*xc+c(8)*yc+c(9)*zc+c(10);
% define H matrix (syms parameter) by diff(Psi)
H_syms=[diff(Psi,xc), diff(diff(Psi,xc),yc), diff(diff(Psi,xc),zc); 
    diff(diff(Psi,yc),xc), diff(Psi,yc,2), diff(diff(Psi,yc),zc); 
    diff(diff(Psi,zc),xc), diff(diff(Psi,zc),yc), diff(Psi,zc,2)]; 
% subs the position by value center_fit, and give a matrix of H (double matrix )
H_fit=double(subs(subs(subs(H_syms,xc,center_fit(1)),yc,center_fit(2)),zc,center_fit(3)));

% diagonalization of H matrix 
[H_fit_V,H_fit_D]=eig(H_fit);
omega3=zeros(1,3); frequency3=zeros(1,3);
for j=1:3
    omega3(j)=sqrt(H_fit_D(j,j)*(q/mass));
end

% H matrix in unit of Hz
for j=1:3
    for k=1:3
        if H_fit(j,k)>0
            H_matrix_fit(j,k)= sqrt( H_fit(j,k)*(q/mass) )/ (2*pi);
        else  
            H_matrix_fit(j,k)=  sqrt( -H_fit(j,k)*(q/mass) )/ (2*pi);
        end 
    end 
    frequency3(j)=H_matrix_fit(j,j); % trap frequency is diagonal element 

end

end

