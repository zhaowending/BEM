%%%%%%% this is a test code is for the real surface trap %%%%%%%%%%%%%%%%
clc,clear
%%%%%%%%%%%%%%%%%%% add all of the funciton in this folder include sub-folders %%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath(pwd));%  addpath(genpath('c:/matlab/myfiles')); % add the functions in the folder with certain path
Path=strcat(pwd,'\Example\Hchange_alongX\ao_check\');  % the path where the meshing  data stores, path of example

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Some constants in physics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
um=10^(-6);

%% the initial setting
figure
figure_all_plot=2;
mesh_mode=0; % the normal mesh size unit
plot_switch=0;  %  plot or not
bbox=[-1500*um,-1500*um;1500*um,1500*um]; % the zone region of the whole trap Bounding box [xmin,ymin; xmax,ymax]
mesh_divide=17;

% inital the mesh information
T_array=[]; % the triangle position of all electrodes
node_array=[]; % the nodes position is at the center of each triangele
T_num_electrode=[];
T_total=0;
T_pos1=[]; T_pos2=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% design the surface trap's pattern %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% the size parameter setting in general
slot_L=100*um; slot_W=60*um; % the size of loading slot
midDC_W=100*um; midDC_L=1000*um; % size of midDC always is grounded
if (midDC_W<=slot_W)
    fprintf('Wrong, check size!　The width of middle DC electrodes should larger than  slots\n ');
end
%%%%%%%%%%%%%%%% two compensation electrodes on the both side of slot, in the middle of RFs
downdc_W=0*um; updc_W=0*um;
dc_L=200*um;
%%%%%%%%%%%%%%% two rf's size
downrf_W=80*um; uprf_W=60*um; rf_L=1000*um ; %　size of rf electrodes
gap_Y=10*um; gap_X=15*um;  % gapY is the gap between DC and RF, gapX is the gap between DC electrodes
%%%%%%%%%%%% for DC segment
num_DC_pair=5; DC_Y=400*um; DC_X=100*um; % the length and width of DC electrode
Z_surface=0; Z_depth=-1*um; % the thickness of electrodes suggest the surface's Z position had better be 0


%% the rf setting
num_op=7; % the number of optimization points
shape_mode=2;
Tworf_opdis=-[30,0,-2,-4,-5,-4,-2,0,0,2,4,5,4,2,0,0,-2,-4,-5,-4,-2,0,0,2,4,5,4,2,0]*um;
Tworf_opdis(1)=-Tworf_opdis(1);
%Tworf_opdis=zeros(1,4*num_op+1);Tworf_opdis(1)=1.5*20*um;
% shape_mode=2;tmp_opdis=[0.4,0,0.2,-0.2,0.2,-0.2,0.2,0,0,-0.2,0.2,-0.2,0.2,-0.2,0]; % this is for one electrode
%　the distance of each optimization  points, the fist, tmp_opdis(1) is X distance between each point, the else tmp_opdis(1,2:2*num_op+1) is the distance on Y axis of each point


%% mesh
%%%%%%%%%%%%% doing mesh %%%%%%%%%%%%%%%%%
Switch_new_mesh=1;  % 0 is doing a new mesh for surface trap, 1 is not meshing just loading
Filename='mesh_surface2_ground.json';
%% doing RF meshing
if (Switch_new_mesh==0)
    RF_p1=[-(rf_L/2), -(midDC_W/2)-2*gap_Y-downdc_W-downrf_W, Z_depth; -(rf_L/2), (midDC_W/2)+2*gap_Y+updc_W, Z_depth ]; % position on the left,front,bottom (x1,y1,z1)
    RF_p2=[ (rf_L/2), -(midDC_W/2)-2*gap_Y-downdc_W, Z_surface;    (rf_L/2), (midDC_W/2)+2*gap_Y+updc_W+uprf_W, Z_surface ]; % position on the right,back, up (x2,y2,z2)
    [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = mesh_two_rf(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,RF_p1,RF_p2,num_op,shape_mode,Tworf_opdis,mesh_divide,mesh_mode,bbox,plot_switch,figure_all_plot);
    
    %% DC electrode
    en=0; en11=0; % en is the number of DC segemnt after rf, en11 is the nufid=fopen([Path,Filename],'w');
    [DC_p1,DC_p2,en,en11]=design_trapGT_DC(rf_L,num_DC_pair,en,midDC_W,gap_Y,uprf_W,downrf_W,gap_X,DC_X,DC_Y,updc_W,downdc_W,Z_surface,Z_depth,dc_L);
    [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = mesh_all_DC(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,DC_p1,DC_p2,en,mesh_divide,bbox,plot_switch,figure_all_plot);
    
    %% mid DC electrode and SLOT
    N_slotdc=0; % N
    [slotdc_p1,slotdc_p2,N_slotdc]=design_trapGT_slotDC(slot_L,slot_W,midDC_W,midDC_L,Z_surface,Z_depth);  % size of midDC always is grounded )
    [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = mesh_slotDC(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,slotdc_p1,slotdc_p2,N_slotdc,mesh_divide,bbox,plot_switch,figure_all_plot);
   
    %% save the mesh data 
    Mdata=save_mesh_json(Path,Filename,T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2); 
    fprintf('doing a new meshing ----  done!!\n')
else 
    [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2]=load_mesh_json(Path,Filename);  
    fprintf('loading a meshing ----- done !!\n ')
end 

%% charge_basis
%%%%%%%%%%%%%%%%%%%%%%%% charge basis %%%%%%%%%%%%%%%%%%%%
Switch_new_charge=0; %　0: doing a new chargebasis calculation       1: loading a exist 
Filename='charge_surface2_ground.json';
Check_chargebasis_large=0; Threshold_chargebasis=10^2; % if Check_chargebasis_large=0 don't delete the large element; =1 delete > threshold_chargebasis
if (Switch_new_charge==0)
    [charge_basis,T_num_before,T_total,num_total_electrode]=Calculate_chargebasis_check(Check_chargebasis_large,Threshold_chargebasis,T_num_electrode,T_total,T_array,node_array);
    Mdata=save_chargebasis_json(Path,Filename,charge_basis,T_num_before,T_total,num_total_electrode,T_array);  % save the charge basis 
    fprintf('doing charge-basis done!!\n'); 
else 
    [charge_basis,T_num_before,T_total,num_total_electrode,T_array]=load_chargebasis_json(Path,Filename);   %　load the charge basis
    fprintf('loading charge basis ----- and done !!\n ')
end 
%% calculate the potential basis 
%%%%%%%%%%%%%%%%%%%%%%% calculate the potential basis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xr=[-100*um,100*um,50];
yr=[-30*um,50*um,30];
zr=[60*um,220*um,60]; % xy0: doing a new chargebasis calculationz_range=[begin,  end ,  number]
Switch_new_potential=0;  %　       1: loading a exist 
Filename='potential_surface2_ground_both_centerandescape.json';
[potential_basis,points,P_num_total,xr,yr,zr,num_total_electrode] = Calculate_potential_basis_all_electrode(Path,Filename,Switch_new_potential,charge_basis,num_total_electrode,T_array,T_total,xr,yr,zr);
fclose('all');
%% to test_real_surface_2
