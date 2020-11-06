function [center_by_min] = find_center_by_minimum(x,y,z,pseudo2_matrix,xr_plot,yr_plot,zr_plot)
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

end

