% a backup code , delete after it works
set(0,'defaultfigurecolor','w');

%%%%%% main program  (modify DC voltage) to change center point

%% initialize the parameter to record to store voltage every time



%% setting  modify parameter
cutoff_range = 0.2*um; % if difference of center point is
Vrf_range=[250,500]; Vrf_range(3)=(Vrf_range(1)+Vrf_range(2))/2; % Vrf change rage in experiment
% In experiment, in order to see mirco motion, we often make RF voltage change between upper and lower limit, ie, [250-500]

cutoff_center_1= 0.1*um; % when modify along a certain direction, the cutoff value to stop


%% calculate the inital condition of different
% calcualte the condition when Vrf = Vrf_range(1), lower limit of RF voltage
Vrf= Vrf_range(1); % define Rf Voltage
[center_pseudo_low,center_fit_low]= calculate_center_according_to_voltage(um,q,mass,Vrf,V_dcsegement,xr,yr,zr,num_total_electrode,points,potential_basis,V,pseudo_C,center_pseudo_ini);

% calcualte the condition when Vrf = Vrf_range(2), upper limit of RF voltage
Vrf= Vrf_range(2); % define Rf Voltage
[center_pseudo_up,center_fit_up]= calculate_center_according_to_voltage(um,q,mass,Vrf,V_dcsegement,xr,yr,zr,num_total_electrode,points,potential_basis,V,pseudo_C,center_pseudo_ini);

% calcualte the condition when Vrf = Vrf_range(3),  Middle RF voltage
Vrf= Vrf_range(3); % define Rf Voltage
[center_pseudo_mid,center_fit_mid]= calculate_center_according_to_voltage(um,q,mass,Vrf,V_dcsegement,xr,yr,zr,num_total_electrode,points,potential_basis,V,pseudo_C,center_pseudo_ini);

% calculate the center difference of them (3 kinds of pseudo potential center between RF center point
center_3pseudo = [center_pseudo_low; center_pseudo_up; center_pseudo_mid];
center_3fit = [center_fit_low; center_fit_up; center_fit_mid];
[delta_value3, delta_vector3] = calculate_center_difference_between_3pseudo_and_RF(center_RF, center_3fit );

% calculate the center difference between RF and mid pseudo center
[delta_value_mid, delta_vector_mid] = calculate_center_difference_between_pseudo_and_RF(center_RF,center_fit_mid);


%% begin loop
bool_loop=true; % means we can go on loop
while (delta_value3 > cutoff_)&(bool_loop==true)
    % pick a direction to modify(X or Y or Z), according to delta_vector_mid, save in max_index
    [max_delta_index, delta_value_1]= find_max_delta_in_delta_vector(delta_vector_mid);
    fprintf('Begin to change along direction-%f (index), now center is at %f \n', max_delta_index,center_fit_mid);
    
    change_dc_way=[max_delta_index, 0.1, 3]; % define the initial vlaue of [ index, changing value , ratio ]
    delta_ini= center_fit_mid(max_delta_index)- center_RF(max_delta_index); % the delta of position along one direction
    
    %%%%%%%%%%%%%  begin a small code, put in function %%%%%%%%%%%%%%%%%%%%%%%%%
    %% initial parameter in one direction
    turn_pos_neg=0;
    bool_one_vector =true; % judge one direction modify is right or not
    list_Vdc_now = V_dcsegement; % record dc segemnt voltage in list
    list_center_mid_now = center_fit_mid; %  record center in list
    list_center3_now(:,:,1) = center_3fit; % record 3 kind center in list
    list_delta_ini_now = delta_ini; % record delta value along one direction
    n=1; % record the number 
    
    while (bool_one_vector == true)
              
            V_dcsegement_new = Rule_change_DC_voltage(change_dc_way,V_dcsegement,num_total_electrode);
            n=n+1;   list_Vdc_now(n,:)=V_dcsegement_new; % increase number n and save voltage  
            
            %% calculate the center point under new DC voltage
            Vrf= Vrf_range(1); % define Rf Voltage
            [center_pseudo_l,center_fit_low]= calculate_center_according_to_voltage(um,q,mass,Vrf,V_dcsegement_new,xr,yr,zr,num_total_electrode,points,potential_basis,V,pseudo_C,center_pseudo_ini);
            
            % calcualte the condition when Vrf = Vrf_range(2), upper limit of RF voltage
            Vrf= Vrf_range(2); % define Rf Voltage
            [center_pseudo_up,center_fit_up]= calculate_center_according_to_voltage(um,q,mass,Vrf,V_dcsegement_new,xr,yr,zr,num_total_electrode,points,potential_basis,V,pseudo_C,center_pseudo_ini);
            
            % calcualte the condition when Vrf = Vrf_range(3),  Middle RF voltage
            Vrf= Vrf_range(3); % define Rf Voltage
            [center_pseudo_mid,center_fit_mid]= calculate_center_according_to_voltage(um,q,mass,Vrf,V_dcsegement_new,xr,yr,zr,num_total_electrode,points,potential_basis,V,pseudo_C,center_pseudo_ini);
            
            % calculate the center difference of them (3 kinds of pseudo potential center between RF center point
            center_3pseudo = [center_pseudo_low; center_pseudo_up; center_pseudo_mid];
            center_3fit = [center_fit_low; center_fit_up; center_fit_mid];
            [delta_value3, delta_vector3] = calculate_center_difference_between_3pseudo_and_RF(center_RF, center_3fit );
            
            % calculate the center difference between RF and mid pseudo center
            [delta_value_mid, delta_vector_mid] = calculate_center_difference_between_pseudo_and_RF(center_RF,center_fit_mid);
            
            % record now center position in list
            list_center_mid_now(n,:) = center_fit_mid; %  record center in list
            list_center3_now(:,:,n) = center_3fit; % record 3 kind center in list
            
            %% judge-ment the change way is right or not , according to how center_mid change 
            delta_one_direction_now= center_fit_mid(max_delta_index)- center_RF(max_delta_index); 
            
            
            %% judge-ment along this direction is right or not
            
        end
    end
    %
end