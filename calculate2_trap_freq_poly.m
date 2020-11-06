function [center_fit,H_matrix_fit,omega3,frequency3,c_H,H_fit_V,H_fit_D] = calculate2_trap_freq_poly(center_data,x,y,z,static_matrix,pseudo2_matrix,um,q,mass)
%calculate the center point and trap frequency by poly function fit after
%finding the center points by matrix. This method is to fitting pseudo potential
%function psi, then use pseudo potential function (psi) to calculate trap
%frequency directly. The paramter of second order domains  trap frequency 

%% setting the plot range, nnx is the number, rrx is the +-range
nnx=35; nny=35; nnz=40;
rrx=10; rry=8; rrz=8;

%%
xr_plot=[-rrx*um+center_data(1),rrx*um+center_data(1),nnx]; % x plotting range around center_X
yr_plot=[-rry*um+center_data(2),rry*um+center_data(2),nny];  %  y plotting range around center_Y
zr_plot=[-rrz*um+center_data(3),rrz*um+center_data(3),nnz]; % the plot range

[xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
nx=xr_plot(3)+1; ny=yr_plot(3)+1; nz=zr_plot(3)+1;  % the number and length of plot XYZ
n_plot_all=nx*ny*nz; % the number of all points
static_q_matrix= interp3(x,y,z,static_matrix,xq,yq,zq); %¡¡enlarge the matrix of static potential
pseudo_q_matrix= interp3(x,y,z,pseudo2_matrix,xq,yq,zq);% enlarge the matrix of pseudo potential

%% reshape data to line matrix 
X=zeros(n_plot_all,3);
X(:,1)=reshape(xq,n_plot_all,1); X(:,2)=reshape(yq,n_plot_all,1); X(:,3)=reshape(zq,n_plot_all,1);

Y=zeros(n_plot_all,1);
Y(:,1)=reshape(pseudo_q_matrix,n_plot_all,1);

%% fit data to Psi equation, pseudo potential field 
c0=[1572488.95926919,103192414.090225,160023477.984134,-2331.26839556518,3150765.11434095,1339.42698450801,-0.165900543168421,82.4304139831170,-30753.0689977601,1.58680284713896];
c = nlinfit(X,Y,@myfun_trapfrequency_pseudo,c0);

%% slove the equation for the center point
c_H=c;
syms xc yc zc
eqns = [2*c(1)*xc + c(4)*yc + c(6)*zc +c(7) == 0, 2*c(2)*yc+c(4)*xc+c(5)*zc+c(8)== 0, 2*c(3)*zc+c(5)*yc+c(6)*xc+c(9)==0];
vars = [xc,yc,zc];
center_struct=solve(eqns, vars);
center_fit(1)=double(center_struct.xc);
center_fit(2)=double(center_struct.yc);
center_fit(3)=double(center_struct.zc);

H_fit=[2*c(1),c(4),c(6); c(4),2*c(2),c(5); c(6),c(5),2*c(3)];
% die


[H_fit_V,H_fit_D]=eig(H_fit);
omega3=zeros(1,3); frequency3=zeros(1,3);
for j=1:3
    omega3(j)=sqrt(H_fit_D(j,j)*(q/mass) );
    frequency3(j)=omega3(j)/(2*pi);
end

for j=1:3
    H_fit_D(j,j)= sqrt( H_fit_D(j,j)*(q/mass))/(2*pi);
    for k=1:3
        if H_fit(j,k)>0
            H_matrix_fit(j,k)= sqrt( H_fit(j,k)*(q/mass) )/ (2*pi);
        else 
            H_matrix_fit(j,k)=  sqrt( -H_fit(j,k)*(q/mass) )/ (2*pi);
        end 
    end
end

end

