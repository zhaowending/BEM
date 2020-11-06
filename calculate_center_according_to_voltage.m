function [center_pseudo,center_fit_byTF]= calculate_center_according_to_voltage(um,q,mass,Vrf,V_dcsegement,xr,yr,zr,num_total_electrode,points,potential_basis,V,pseudo_C,center_pseudo_ini) 
%calculate the center point of all pseudo potential field by RF voltage and
% DC segement voltage. 

%% define the voltage 
V=[Vrf,Vrf,V_dcsegement]; % voltage combine together

%% calculate potential 
%%%%%%%%%%%%%%%%%%%%% calculate the static potential %%%%%%%%%%%%%%%%
[x,y,z]=meshgrid(linspace(xr(1),xr(2),xr(3)+1),linspace(yr(1),yr(2),yr(3)+1),linspace(zr(1),zr(2),zr(3)+1)); % the matrix of points
nx=size(x,2); ny=size(x,1); nz=size(x,3);
[static_potential,static_matrix,pseudo_potential,npot,pseudo2_line,pseudo2_matrix,A_line,A_matrix,Q_line,Q_matrix,pseudo_matrix] = calculate_static_pseudo_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);
[RF_static_potential,RF_static_matrix,RF_pseudo_line,RF_pseudo_matrix]  = calculate_RF_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);
[DC_potential_line,DC_potential_matrix] = calculate_DC_static_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);
% the first manner to calculate the pesudo potential in pesudo_potential maybe wrong

%% calculate the trap center and frequency by matrix operation 
rrx=20*um; rry=20*um; rrz=20*um;  % define the region for calculate center point by 
center_ini=center_pseudo_ini;  % the initial center point for trying 
% calculate the center point of only RF potential field 
[center_pseudo,difference_center_data,center_round] = find_center_bymatrix(center_ini,x,y,z,static_matrix,pseudo2_matrix,um,rrx,rry,rrz);

%% calculate the center point by fitting 
[center_fit_byTF,H_matrix_fit,omega3,frequency3,c_H,H_fit_V,H_fit_D]= calculate2_trap_freq_poly(center_pseudo,x,y,z,static_matrix,pseudo2_matrix,um,q,mass);

end

