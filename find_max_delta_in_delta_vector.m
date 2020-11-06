function [max_index,max_value]= find_max_delta_in_delta_vector(vector)
%find the max difference direction, X Y or Z direction, then, we will modify along this
% direction in the next. The direction (XYZ) is saved in max_index by (1,2,3)

n=size(vector,2); 
if (n==3)
    max_index=1; max_value=vector(1); 
    for j=1:3
        if max_value<= abs(vector(j))
            max_value = abs(vector(j));
            max_index = j; 
        end
    end 
else
    fprintf('Wrong! The size of center delta vector is wrong !');
end


end

