%%%%%%%%%%%%%%%%%%% add all of the funciton in this folder include sub-folders %%%%%%%%%%%%%%%%%%%%%%%%%%
root_folder='E:\zhaowending\BEM-zhao\trap_design_tiqc\BEM\';
addpath(genpath(root_folder));%  addpath(genpath('c:/matlab/myfiles')); % add the functions in the folder with certain path
Path=strcat(root_folder,'Example\surface_302\');  % the path where the meshing  data stores, path of example

%% load data 
file_save_name=strcat(Path,'Data_trap_frequency.mat');
load(file_save_name); 

%% Experiment data
Ex_data=[1.1, 1.425,  1.694, 0.279;
    1.25,	1.642,1.877,0.276;
    1.46,   1.908,2.102,0.276; 
    1.65,	2.252,2.424,0.277;
    1.82,	2.529,2.688,0.289];
min_vpp=min(Ex_data(:,1));
max_vpp=max(Ex_data(:,1));

%% linear fitting to experiment result 
Ex_radial(:,1)=Ex_data(:,1); % experiemnt voltage 
Ex_radial(:,2)=(Ex_data(:,2)+Ex_data(:,3))/2; % experiment radial freqeuency 
f_ex=fit(Ex_radial(:,1),Ex_radial(:,2),'poly1');
Simulation_radial(:,1)=Data_save.Vrf_list; 
Simulation_radial(:,2)= (Data_save.frequency3(:,2)+ Data_save.frequency3(:,3))/2; 
f_sim=fit(Simulation_radial(:,1),Simulation_radial(:,2)/(10^6),'poly1');
enlarge_ratio=f_ex.p1/f_sim.p1; 
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
ylim([0 , 4]);
A_large=enlarge_ratio; 
xlim([min_vpp*A_large,max_vpp*A_large])

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
ylim([0 , 4]);

legend([HT,HE],{'Simulation','Experiment'})
xlabel(ax1,'RF voltage amplitude')
xlabel(ax2,'V_{pp} in Experiment ')
ylabel(ax1,'Trap frequency(MHz)')