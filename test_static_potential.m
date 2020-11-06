xr=[-10,15,15];
yr=[-10,14,15];
zr=[10,60,20]; % xyz_range=[begin,  end ,  number]
Switch_new_potential=0; %¡¡0: doing a new chargebasis calculation       1: loading a exist 
Filename='potentialbasis_3DC.json';
%% static electric field calculation 
ntmp=size(charge_basis);
ntmp2=size(V); 
if (num_total_electrode==ntmp(2))&(T_total==ntmp(1))&(ntmp(2)==num_total_electrode)
    %%%%%%%%%%%%%% doning the potential basis and store in pb %%%%%%%%%%%%%
    if (Switch_new_potential==0)
    [x,y,z]=meshgrid(linspace(xr(1),xr(2),xr(3)+1),linspace(yr(1),yr(2),yr(3)+1),linspace(zr(1),zr(2),zr(3)+1)); % the matrix of points 
    P_num_total=[numel(x) 1]; % the number of points that you want to calculate in the range of [xr,yr,zr]
    points=[reshape(x,P_num_total) reshape(y,P_num_total) reshape(z,P_num_total)];% points array (N*3)
    voltage_I=eye(num_total_electrode);  % The unit matrix of voltage 
    potential_basis=[]; 
    for k=1:num_total_electrode
       [pot,fx,fy,fz]=Calculate_Potential_in_kth(T_array,charge_basis*voltage_I(:,k),points);
        potential_basis(:,:,k)=[pot;fx;fy;fz];
    end 
    %%%%%%%%%%%%% save the potential file %%%%%%%%%%%%%%%%%%%%%
    Mdata=save_potentialbasis_json(Path,Filename,potential_basis,points,P_num_total,xr,yr,zr,num_total_electrode); 
    fprintf('Potential basis calculations done !!\n'); 
    else %% Load the file of potential  
        [potential_basis,points,P_num_total,xr,yr,zr,num_total_electrode]=load_potentialbasis_json(Path,Filename);  
        fprintf('loading charge basis ----- and done !!\n '); 
    end 
else 
    fprintf('Wrong in the number of charge basis!!\n ');
end 
    