clc,clear
%% add all of the funciton in this folder include sub-folders
addpath(genpath(pwd));
%  addpath(genpath('c:/matlab/myfiles')); % add the functions in the folder with certain path 
%% the initial setting 
figure
figure_all_plot=2;
mesh_mode=0; % the normal mesh size unit
plot_switch=0;  %  plot or not 
bbox=[-55,-55;60,65]; % the zone region of the whole trap Bounding box [xmin,ymin; xmax,ymax]
mesh_divide=13;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% a poly in loading region %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% pos1=[0,0,-0.5]; % position on the left,front,bottom (x1,y1,z1)
% pos2=[10,2,0]; % position on the right,back, up (x2,y2,z2)
% num_op=7;   % the number of optimization points 
% mesh_size=Normal_mesh_size(pos1,pos2,15); 
% shape_mode=2;tmp_opdis=[0.4,0,0.2,-0.2,0.2,-0.2,0.2,0,0,-0.2,0.2,-0.2,0.2,-0.2,0]; %　the distance of each optimization  points
% % shape_mode=1;tmp_opdis=[0,0.2,-0.2,0.2,-0.2,0.2,0,0,-0.2,0.2,-0.2,0.2,-0.2,0]; %　the distance of each optimization  points
% [p1,num1] = trap_mesh_rfpoly(tmp_opdis,shape_mode,num_op,pos1,pos2,mesh_size,mesh_mode,bbox,plot_switch,figure_all_plot);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


% %%%%%%%%%%%%%%%%%%%%%%%%%%% a cube with two point pos1 and pos2%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pos1=[0,0,-0.5]; % position on the left,front,bottom (x1,y1,z1)
% pos2=[5,3,0]; % position on the right,back, up (x2,y2,z2)
% mesh_size=Normal_mesh_size(pos1,pos2,15); 
% [p,num]=trap_mesh_cube(pos1,pos2,mesh_size,bbox,plot_switch,figure_all_plot);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3 elctrode example %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% meshing saving and loading %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% inital the mesh information 
T_array=[]; % the triangle position of all electrodes 
node_array=[]; % the nodes position is at the center of each triangele 
T_num_electrode=[]; 
T_total=0;
T_pos1=[]; T_pos2=[];

% path of example 
Path=strcat(pwd,'\Example\one_electrode_and_ground\ ');  % the path where the meshing  data stores   
%% mesing
%%%%%%%%%%%%%%%%%%%%% doing meshing %%%%%%%%%%%%%%%%%%%%%%%
Switch_new_mesh=0;  % 0 is doing a new mesh for surface trap, 1 is not meshing just loading
Filename='mesh_1DC_with_ground.json';
if (Switch_new_mesh==0)
    %DC_p1=[0,0,-10^(-2);100,100,-10^(-2)]; DC_p2=[5,3,0;104,107,0]; % the position 
    DC_p1=[0,0,-10^(-2);10,8,-10^(-2)]; DC_p2=[5,3,0;12,13,0]; % the position
    num_DC=2; 
    % mesh all of the DC cube and print them in blue 
    [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = mesh_all_DC(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,DC_p1,DC_p2,num_DC,mesh_divide,bbox,plot_switch,figure_all_plot); 
   % mesh the ground part, and print it in black 
   [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = Mesh_ground_expectDC(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,bbox,plot_switch,figure_all_plot);
   % if this is the first time you mesh this surface trap, you can save the  mesh data in the form of josn. 
    Mdata=save_mesh_json(Path,Filename,T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2); 
    fprintf('doing a new meshing ----  done!!\n')
else 
   [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2]=load_mesh_json(Path,Filename);  
   fprintf('loading a meshing ----- done !!\n ')
end 
%% charge_basis
%%%%%%%%%%%%%%%%%%%%%%%% charge basis %%%%%%%%%%%%%%%%%%%%
Switch_new_charge=0; %　0: doing a new chargebasis calculation       1: loading a exist 
Filename='chargebasis_2DC_with_ground.json';
Check_chargebasis_large=0; Threshold_chargebasis=10^5; % if Check_chargebasis_large=0 don't delete the large element; =1 delete > threshold_chargebasis
if (Switch_new_charge==0)
    [charge_basis,T_num_before,T_total,num_total_electrode]=Calculate_chargebasis(Check_chargebasis_large,Threshold_chargebasis,T_num_electrode,T_total,T_array,node_array);
    Mdata=save_chargebasis_json(Path,Filename,charge_basis,T_num_before,T_total,num_total_electrode,T_array);  % save the charge basis 
    fprintf('doing charge-basis done!!\n'); 
else 
    [charge_basis,T_num_before,T_total,num_total_electrode,T_array]=load_chargebasis_json(Path,Filename);   %　load the charge basis
    fprintf('loading charge basis ----- and done !!\n ')
end 
%% calculate the potential basis 
%%%%%%%%%%%%%%%%%%%%%%% calculate the potential basis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xr=[-10,20,6];
yr=[-10,20,6];
zr=[10,60,6]; % xyz_range=[begin,  end ,  number]
Switch_new_potential=0; %　0: doing a new chargebasis calculation       1: loading a exist 
Filename='potentialbasis_2DC_with_ground.json';
[potential_basis,points,P_num_total,xr,yr,zr,num_total_electrode] = Calculate_potential_basis_all_electrode(Path,Filename,Switch_new_potential,charge_basis,num_total_electrode,T_array,T_total,xr,yr,zr);

V=[3,5,0];
static_potential=[];
for j=1:num_total_electrode
    if (j==1)
        static_potential=potential_basis(:,:,1)*V(1);
    else 
        static_potential=static_potential+potential_basis(:,:,j)*V(j);
    end 
end 
