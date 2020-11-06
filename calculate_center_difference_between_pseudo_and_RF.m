function [delta_value, delta_vector] = calculate_center_difference_between_pseudo_and_RF(center_RF,center_pseudo)
% calculate the difference between two center point, often center point of
% RF and pseudo potential field. Center of RF potential is the first one,
% of pseudo potential field is the second one. 

delta_vector= center_pseudo - center_RF; 
n = size(center_RF,2);
if (n == 3)
    tmp = 0; 
    for j =1:3
        tmp = tmp+ abs(delta_vector(j));
    end 
    delta_value = tmp;  
else
    fprintf('Wrong! The size of center point is wrong !\n'); 
end 

end

