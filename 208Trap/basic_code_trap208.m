%%%%%%% this is a test code is for the real surface trap %%%%%%%%%%%%%%%%
clc,clear
%%%%%%%%%%%%%%%%%%% add all of the funciton in this folder include sub-folders %%%%%%%%%%%%%%%%%%%%%%%%%%
root_folder='E:\zhaowending\BEM-zhao\trap_design_tiqc\BEM\';
addpath(genpath(root_folder));%  addpath(genpath('c:/matlab/myfiles')); % add the functions in the folder with certain path
Path=strcat(root_folder,'Example\surface_208\');  % the path where the meshing  data stores, path of example

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Some constants in physics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
um=10^(-6);
%% the initial setting
figure
figure_all_plot=2;
mesh_mode=0; % the normal mesh size unit
plot_switch=0;  %  plot or not
bbox=[-1500*um,-1500*um;1500*um,1500*um]; % the zone region of the whole trap Bounding box [xmin,ymin; xmax,ymax]
mesh_divide=16;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% design the surface trap's pattern %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% the size parameter setting in general
slot_W=102*um; % the size of loading slot
%%%%%%% two compensation electrodes on the both side of slot, in the middle  of RFs %%%%%%%%%
downdc_W=20*um; updc_W=20*um;
dc_L=1500*um;
%%%%%%%%%%%%%%% two rf's size %%%%%%%%%%%%%%%%%%%%%%%%
downrf_W=58*um; uprf_W=58*um; rf_L=1500*um ; % size of rf electrodes
gap_Y=28*um; gap_X=16*um;  % gapY is the gap between DC and RF, gapX is the gap between DC electrodes
%%%%%%%%%%%% for DC segments %%%%%%%%%%%%%%%%%%%%%%%%%%%
DC_Y=173*um; DC_X=62*um; % the length and width of DC electrode
Z_surface=0*um; Z_depth=-2*um; % the thickness of electrodes suggest the surface's Z position had better be 0

%% the rf tooth setting
num_op=3; % the number of optimization points
shape_mode=2;
Tworf_opdis=[30,0,0,0,0,0,0,0,0,0,0,0,0]*um; % No tooth on RF setting

%% give the positions of boundary points of DC segements electrodes
out_length=990*um; %  the length of
left_points=[-870, -590, -310, 130, 410, 690]*um;
right_points=[-690, -410, -130, 310, 590, 870]*um;
num_DC_pair=6;  % the number of DC segment electrodes pairs (in center) you want to build
use_pair=[1:1:6];  % the DC segement electrodes pairs (in center) you will use in real


%% meshing
% inital the mesh information
T_array=[]; % the triangle position of all electrodes
node_array=[]; % the nodes position is at the center of each triangele
T_num_electrode=[];
T_total=0;
T_pos1=[]; T_pos2=[];

%%%%%%%%%%%%% doing mesh %%%%%%%%%%%%%%%%%
Switch_new_mesh=1;  % 0 is doing a new mesh for surface trap, 1 is not meshing just loading
Filename='mesh_surface208.json';
%% doing RF meshing
if (Switch_new_mesh==0)
    RF_p1=[-(rf_L/2), -(slot_W/2)-gap_Y-downdc_W-downrf_W, Z_depth; -(rf_L/2), (slot_W/2)+gap_Y+updc_W, Z_depth ]; % position on the left,front,bottom (x1,y1,z1)
    RF_p2=[ (rf_L/2), -(slot_W/2)-gap_Y-downdc_W, Z_surface;    (rf_L/2), (slot_W/2)+gap_Y+updc_W+uprf_W, Z_surface ]; % position on the right,back, up (x2,y2,z2)
    [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = mesh_two_rf(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,RF_p1,RF_p2,num_op,shape_mode,Tworf_opdis,mesh_divide,mesh_mode,bbox,plot_switch,figure_all_plot);
    
    %% DC segement electrodes
    en=0;  % en is the number of DC segemnt after rf, en11 is the nufid=fopen([Path,Filename],'w');
    [DC_x,DC_y,en]=design_trap208_DCsegment(slot_W,rf_L,num_DC_pair,use_pair,gap_Y,uprf_W,downrf_W,gap_X,DC_X,DC_Y,updc_W,downdc_W,Z_surface,Z_depth,dc_L,right_points,left_points,out_length);
    [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = mesh_trap208_DC_segement(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,DC_x,DC_y,en,mesh_divide,plot_switch,figure_all_plot,Z_depth,Z_surface,um);
    [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = mesh_trap208_DC_mid(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,DC_x,DC_y,en,mesh_divide,plot_switch,figure_all_plot,Z_depth,Z_surface,um);
    
    %% save the mesh data
    Mdata=save_mesh_json(Path,Filename,T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2);
    fprintf('doing a new meshing ----  done!!\n')
else
    [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2]=load_mesh_json(Path,Filename);
    fprintf('loading a exist meshing ----- done !!\n ')
end


%% calculate charge_basis  %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% charge basis %%%%%%%%%%%%%%%%%%%%
Switch_new_charge=1; %0: doing a new chargebasis calculation       1: loading a exist
%Filename='charge_surface208_4.mat';
Filename='charge_surface208.json';

Check_chargebasis_large=0; Threshold_chargebasis=10^6; % if Check_chargebasis_large=0 don't delete the large element; =1 delete > threshold_chargebasis
if (Switch_new_charge==0)
    [charge_basis,T_num_before,T_total,num_total_electrode]=Calculate_chargebasis(Check_chargebasis_large,Threshold_chargebasis,T_num_electrode,T_total,T_array,node_array);
    %Mdata=save_chargebasis_mat(Path,Filename,charge_basis,T_num_before,T_total,num_total_electrode,T_array);
    Mdata=save_chargebasis_json(Path,Filename,charge_basis,T_num_before,T_total,num_total_electrode,T_array);  % save the charge basis
    fprintf('doing charge-basis done!!\n');
else
    %[charge_basis,T_num_before,T_total,num_total_electrode,T_array]=load_chargebasis_mat(Path,Filename);
    [charge_basis,T_num_before,T_total,num_total_electrode,T_array]=load_chargebasis_json(Path,Filename);   %¡¡load the charge basis
    fprintf('loading a exist charge basis ----- and done !!\n ')
end


%% calculate the potential basis
%%%%%%%%%%%%%%%%%%%%%%% calculate the potential basis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Switch_new_potential=1;  %0:doing a new one,  1: loading a exist
Filename='potential_surface208_4_more.mat';
%Filename='potential_surface208_center.json';

%%%%%%% calculate or loading the potential basis for all of electrodes and save it into potential bass (4*Num_points*Num_electrodes)
ntmp=size(charge_basis);
if (num_total_electrode==ntmp(2))&(T_total==ntmp(1))
    %%%%%%%%%%%%%% doning the potential basis and store in pb %%%%%%%%%%%%%
    if (Switch_new_potential==0)
        xr=[-50*um,50*um,50];
        yr=[-35*um,35*um,35];
        zr=[60*um,250*um,100]; % xy0: doing a new chargebasis
        [x,y,z]=meshgrid(linspace(xr(1),xr(2),xr(3)+1),linspace(yr(1),yr(2),yr(3)+1),linspace(zr(1),zr(2),zr(3)+1)); % the matrix of points
        P_num_total=[numel(x) 1]; % the number of points that you want to calculate in the range of [xr,yr,zr]
        points=[reshape(x,P_num_total) reshape(y,P_num_total) reshape(z,P_num_total)];% points array (N*3)
        voltage_I=eye(num_total_electrode);  % The unit matrix of voltage
        potential_basis=[];
        for k=1:num_total_electrode
            [pot,fx,fy,fz]=Calculate_Potential_in_kth(T_array,charge_basis(:,k),points);
            potential_basis(:,:,k)=[pot;fx;fy;fz];
        end
        %%%%%%%%%%%%% save the potential file %%%%%%%%%%%%%%%%%%%%%
        Mdata=save_potentialbasis_mat(Path,Filename,potential_basis,points,P_num_total,xr,yr,zr,num_total_electrode);
        %Mdata=save_potentialbasis_json(Path,Filename,potential_basis,points,P_num_total,xr,yr,zr,num_total_electrode);
        fprintf('Potential basis calculations done !!\n');
    else
        %% Load the file of potential
        [potential_basis,points,P_num_total,xr,yr,zr,num_total_electrode]=load_potentialbasis_mat(Path,Filename);
        %[potential_basis,points,P_num_total,xr,yr,zr,num_total_electrode]=load_potentialbasis_json(Path,Filename);
        fprintf('loading potential basis ----- and done !!\n ');
    end
else
    fprintf('Wrong in the number of charge basis!!\n ');
end

fclose('all');
%% to test_real_surface_2