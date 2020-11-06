function [delta_value, delta_vector] = calculate_center_difference_between_3pseudo_and_RF(center_RF,center_M)
% calculate the difference between 3 center point of pseudo potential under different RF 
% voltage  (3 in center_pseudo, a 3*3 matrix data )and  center point of RF potential field. 
% Center of RF potential is the first one and pseudo potential field is the second one. 

%% initial parameter 
delta_value = 0; % the whole distance bwteen (3)points and RF = up+ low + 2*mid
delta_vector = zeros(3,3); % difference vector 
delta_value_vector= zeros(3,1); % the abs distance between point and RF 

%% calculate distance 
n = size(center_RF,2);
if (n == 3)
    for j = 1:3 
        delta_vector(j,:)= center_M(j,:) - center_RF; 
        tmp=0; 
        for k =1:3
            tmp=tmp+abs( delta_vector(j,k) );             
        end 
        delta_value_vector(j,1) = tmp; 
        delta_value = delta_value + delta_value_vector(j,1);
    end 
    delta_value = delta_value + delta_value_vector(3,1); 
else
    fprintf('Wrong! The size of center point is wrong !\n'); 
end 

end

