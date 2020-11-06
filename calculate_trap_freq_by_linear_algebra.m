function [H_matrix_algebra,omega3,frequency3,H_algebra,H_algebra_V,H_algebra_D] = calculate_trap_freq_by_linear_algebra(center_data,x,y,z,static_matrix,pseudo2_matrix,um,q,mass)
%calculate the center point and trap frequency by poly function algebra after
%find the center points by matrix

%% setting the plot range, nnx is the number, rrx is the +-range 
nnx=40; nny=40; nnz=40;
rrx=8; rry=8; rrz=8;

%% build a new matrix of pseudo potential 
xr_plot=[-rrx*um+center_data(1),rrx*um+center_data(1),nnx]; % x plotting range around center_X
yr_plot=[-rry*um+center_data(2),rry*um+center_data(2),nny];  %  y plotting range around center_Y
zr_plot=[-rrz*um+center_data(3),rrz*um+center_data(3),nnz]; % the plot range

[xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
nx=xr_plot(3)+1; ny=yr_plot(3)+1; nz=zr_plot(3)+1;  % the number and length of plot XYZ
n_plot_all=nx*ny*nz; % the number of all points
static_q_matrix= interp3(x,y,z,static_matrix,xq,yq,zq); %¡¡enlarge the matrix of static potential
pseudo_q_matrix= interp3(x,y,z,pseudo2_matrix,xq,yq,zq);% enlarge the matrix of pseudo potential

min_value= min(min(min(pseudo_q_matrix)));
for j=1:nx
    for k=1:ny
        for ii=1:nz
            if (pseudo_q_matrix(j,k,ii)==min_value)
                xi=j; yi=k; zi=ii; 
            end 
        end
    end
end

%% calculate the trap frequency by linear algebra
[gx,gy,gz]=gradient(pseudo_q_matrix); 
[gxx,gxy,gxz]=gradient(gx); 
[gyx,gyy,gyz]=gradient(gy);
[gzx,gzy,gzz]=gradient(gz);

%% build H 
H_algebra=[ gxx(xi,yi,zi),gxy(xi,yi,zi),gxz(xi,yi,zi); 
    gyx(xi,yi,zi),gyy(xi,yi,zi),gyz(xi,yi,zi);
    gzx(xi,yi,zi),gzy(xi,yi,zi),gzz(xi,yi,zi)]

% diagonalization of H matrix 
[H_algebra_V,H_algebra_D]=eig(H_algebra);
omega3=zeros(1,3); frequency3=zeros(1,3);
for j=1:3
    omega3(j)=sqrt(H_algebra_D(j,j)*(q/mass));
    frequency3(j)=omega3(j)/(2*pi);
end

% H matrix in unit of Hz
for j=1:3
    H_algebra_D(j,j) = sqrt( H_algebra_D(j,j)*(q/mass) )/ (2*pi);
    for k=1:3
        if H_algebra(j,k)>0
            H_matrix_algebra(j,k)= sqrt( H_algebra(j,k)*(q/mass) )/ (2*pi);
        else 
            H_matrix_algebra(j,k)=  sqrt( -H_algebra(j,k)*(q/mass) )/ (2*pi);
        end 
    end 
end

end

