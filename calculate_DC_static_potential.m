function [DC_potential_line,DC_potential_matrix] = calculate_DC_static_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr)
%calculate the RF potential field , pseudo potential 
[x,y,z]=meshgrid(linspace(xr(1),xr(2),xr(3)+1),linspace(yr(1),yr(2),yr(3)+1),linspace(zr(1),zr(2),zr(3)+1)); % the matrix of points
nx=size(x,2); ny=size(x,1); nz=size(x,3);
%% calculate the staic potential
static_potential=[]; %  
for j=3:num_total_electrode
    if (j==3)
        static_potential=potential_basis(:,:,1)*V(1);
    else
        static_potential=static_potential+potential_basis(:,:,j)*V(j);
    end
end
static_matrix=reshape(static_potential(1,:),[ny,nx,nz]);
%%%%%%%%%%%%%%%%%%%% calculate the pseudo_potential %%%%%%%%%%%%%%%%%%%
DC_potential_line = static_potential; 
DC_potential_matrix = static_matrix;


end

