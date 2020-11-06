function f=Goal_center_simulannealbnd_findvoltage(v,center_goal,num_total_electrode,xr,yr,zr,points,potential_basis,pseudo_C,um)
% use fmincon to find voltage to make the center point to make  
V=change_voltage_N1_TO_N(v);
%% calculate the potential field 
[x,y,z]=meshgrid(linspace(xr(1),xr(2),xr(3)+1),linspace(yr(1),yr(2),yr(3)+1),linspace(zr(1),zr(2),zr(3)+1)); % the matrix of points
nx=size(x,2); ny=size(x,1); nz=size(x,3);
[static_potential,static_matrix,pseudo_potential,npot,pseudo2_line,pseudo2_matrix,A_line,A_matrix,Q_line,Q_matrix,pseudo_matrix] = calculate_static_pseudo_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr);


%% calculate the trap center and frequency by matrix operation 
% rrx=20*um; rry=20*um; rrz=30*um;  % define the region for calculate center point by 
% center_ini=center_goal;  % the initial center point for trying 
% % calculate the center point of all pseudo potential field 
% [center_pseudo,difference_center_data,center_round] = find_center_bymatrix(center_ini,x,y,z,static_matrix,pseudo2_matrix,um,rrx,rry,rrz);

%% put the result in global parameter list 
global list_center 
global list_v
global list_fmin

n_round=size(list_center,1)+1;

% %% calculate the trap center and frequency by matrix operation 
% rrx=10*um; rry=10*um; rrz=15*um;  % define the region for calculate center point by 
% center_ini=list_center(n_round-1,:);  % the initial center point for trying 
% % calculate the center point of all pseudo potential field 
% [center_pseudo,difference_center_data,center_round] = find_center_bymatrix(center_ini,x,y,z,static_matrix,pseudo2_matrix,um,rrx,rry,rrz);
% % calculate the center point of only RF potential field 


%% find center point by find minimum point in pseudo potential matrix 
xr_plot=[-15*um,15*um,50];
yr_plot=[-15*um,15*um,50];
zr_plot=[80*um,120*um,70];
[center_by_min] = find_center_by_minimum(x,y,z,pseudo2_matrix,xr_plot,yr_plot,zr_plot);
center_pseudo= center_by_min; 



%% calculate the difference value between trap center and RF center 
f=0; 
for j=1:3 
   f=f+abs(center_pseudo(j)-center_goal(j))*10^6; 
end 

%% refresh list 
list_center(n_round,:)=center_pseudo;
list_v(n_round,:)=V;
list_fmin(n_round,1)=f;

end

