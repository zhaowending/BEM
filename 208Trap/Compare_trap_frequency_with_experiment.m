set(0,'defaultfigurecolor','w');
%%%%%%%%%%%%%%%%%%% add all of the funciton in this folder include sub-folders %%%%%%%%%%%%%%%%%%%%%%%%%%
root_folder='E:\zhaowending\BEM-zhao\trap_design_tiqc\BEM\';
addpath(genpath(root_folder));%  addpath(genpath('c:/matlab/myfiles')); % add the functions in the folder with certain path
Path=strcat(root_folder,'Example\surface_208\');  % the path where the meshing  data stores, path of example

%% load data 
file_save_name=strcat(Path,'Data_trap_f_20200926.mat');
load(file_save_name); 

%% Experiment data
Ex_data=[3.8, 0.994,  0, 0.15;
   4.36,	1.052,  0, 0.15;
   5.12,    1.19,   0, 0.15; 
   5.88,	1.325,  0, 0.15;
   6.44,	1.47,   0, 0.15;
   6.64,    1.491,  0, 0.15;
   6.96,    1.544,  0, 0.15;
   7.28,    1.594,  0, 0.15;
   7.56,    1.662,  0, 0.15;
   7.72,    1.69,   0, 0.15;
   8.3,     1.791,  0, 0.15; 
   8.84,    1.892,  0, 0.15;
   9.32,    1.99,   0, 0.15;    
   ];
min_vpp=min(Ex_data(:,1));
max_vpp=max(Ex_data(:,1));
Ex_data(:,3)=Ex_data(:,2)+0.2; 

%% linear fitting to experiment result 
Ex_radial(:,1)=Ex_data(:,1); % experiemnt voltage 
Ex_radial(:,2)=(Ex_data(:,2)+Ex_data(:,3))/2; % experiment radial freqeuency 
f_ex=fit(Ex_radial(:,1),Ex_radial(:,2),'poly1');
Simulation_radial(:,1)=Data_save.Vrf_list; 
Simulation_radial(:,2)= (Data_save.frequency3(:,2)+ Data_save.frequency3(:,3))/2; 
f_sim=fit(Simulation_radial(:,1),Simulation_radial(:,2)/(10^6),'poly1');
enlarge_ratio=f_ex.p1/f_sim.p1

y_range=[0,2.3];
x_range_EX=[min_vpp,max_vpp];
x_range_sim= [165, 340];

fprintf('The amplifier factor of RF voltage (V_{pp} TO V_{rf}) is %f',enlarge_ratio)
%% plot trap frequency versus RF voltage amplitude 
figure 
HT=plot(Data_save.Vrf_list , Data_save.frequency3(:,2)/(10^6),'k'); 
hold on 
plot(Data_save.Vrf_list , Data_save.frequency3(:,3)/(10^6),'k' ); 
hold on 
plot(Data_save.Vrf_list ,Data_save.frequency3(:,1)/(10^6),'k' ); 
ax1 = gca;
ax1.XColor = 'k';
ax1.YColor = 'k';
xlim(x_range_sim);
ylim(y_range);
A_large=enlarge_ratio; 

ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','left',...
    'Color','none');

HE=line(Ex_data(:,1),Ex_data(:,2),'Parent',ax2,'Color','r');
hold on 
line(Ex_data(:,1),Ex_data(:,3),'Parent',ax2,'Color','r');
hold on 
line(Ex_data(:,1),Ex_data(:,4),'Parent',ax2,'Color','r');
box on 
ylim(y_range);
xlim(x_range_EX)

legend([HT,HE],{'Simulation','Experiment'})
xlabel(ax1,'RF voltage amplitude')
xlabel(ax2,'V_{pp} in Experiment ')
ylabel(ax1,'Trap frequency(MHz)')