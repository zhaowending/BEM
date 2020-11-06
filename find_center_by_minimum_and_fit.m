function [center_by_min_and_fit,center_by_min] =  find_center_by_minimum_and_fit(x,y,z,pseudo2_matrix,xr_plot,yr_plot,zr_plot,um)
% calculate the center point of pseudo potential matrix by finding minimum 

%% calculate a new matrix by interpration 
[xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
nx=xr_plot(3)+1; ny=yr_plot(3)+1; nz=zr_plot(3)+1;  % the number and length of plot XYZ
n_plot_all=nx*ny*nz; % the number of all points
pseudo_q_matrix= interp3(x,y,z,pseudo2_matrix,xq,yq,zq);% enlarge the matrix of pseudo potential
%% find minimum 
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

x_pos=xq(xi,yi,zi); 
y_pos=yq(xi,yi,zi);
z_pos=zq(xi,yi,zi);
center_by_min=[x_pos,y_pos,z_pos]; 

%% build a small matrix 
x_range=10*um; nnx=25; 
y_range=10*um; nny=25; 
z_range=10*um; nnz=25; 
[xq2,yq2,zq2]=meshgrid(linspace(x_pos-x_range,x_pos+x_range,nnx),linspace(y_pos-y_range,y_pos+y_range,nny),linspace(z_pos-z_range,z_pos+z_range,nnz));
n_line2=nnx*nny*nnz; % the number of all points
pseudo_q_matrix2= interp3(xq,yq,zq,pseudo_q_matrix,xq2,yq2,zq2);% enlarge the matrix of pseudo potential

%% fit to solve center 
line2_pseudo = reshape(pseudo_q_matrix2,[n_line2,1]);
line2_xq = reshape(xq2,[n_line2,1]); 
line2_yq = reshape(yq2,[n_line2,1]); 
line2_zq = reshape(zq2,[n_line2,1]); 
X=zeros(n_line2,3);
X(:,1)=line2_xq;  X(:,2)=line2_yq; X(:,3)=line2_zq;
c0=[10, x_pos, 10, y_pos, 10, z_pos, min_value]; 
rng('default') % for reproducibility
c = nlinfit(X,line2_pseudo,@myfun_center_in_find_center_by_minimum_and_fit,c0);

%% return result 
center_by_min_and_fit= [c(2),c(4),c(6)];

end

