function Ma=Malpha_approximate(alpha_old,triangles,A,len)
% calculate the alpha matrix (without threshold approximate)

%% set two threshold value, one to judge == , one to change
threshold_tuo=2*10^(-6);
threshold_judege=0.2*10^(-6);

%% check complex 
for j=1:len
    T_now = triangles(:,:,j);
    for k=1:len
        A_now=A(k,:);
        if (imag(alpha_old(k,j)) ~=0) % there is error, the 3 point of mesh triangle on a line
            % y position are same, 3 points on a X line
            if (abs(T_now(1,2)-T_now(2,2))< threshold_judege)& (abs(T_now(1,2)==T_now(3,2))<threshold_judege)
                max_X= max(T_now(:,1)); min_X= min(T_now(:,1));
                for ii=1:3
                    if ((T_now(ii,1)<max_X) & (T_now(ii,1)>min_X)) % find the mid one point in 3
                        T_now(ii,2)= T_now(ii,2)+ threshold_tuo; % make them become a triangle
                    end
                end
                
            end
            % x positions are same, 3 points on a Y line
            if (abs(T_now(1,1)-T_now(2,1))<threshold_judege) & (abs(T_now(1,1)-T_now(3,1))<threshold_judege  ) % y position same, 3 points on X
                max_Y= max(T_now(:,2)); min_Y= min(T_now(:,2));
                for ii=1:3
                    if (T_now(ii,2)<max_Y) & (T_now(ii,2)>min_Y) % find the mid one point in 3
                        T_now(ii,1)= T_now(ii,1)+ threshold_tuo; % make them become a triangle
                    end
                end
            end
            tmp = int_green3d_tri(A_now,T_now); % calculate again
            Ma(k,j)= double(tmp); 
            if (imag(alpha_old(k,j)) ~=0)  % if it is still wrong.
                fprintf('Wrong !\n');
                [k,j,alpha_old(k,j)]
                Ma(k,j)=0;
            end
        else
             Ma(k,j)=double(alpha_old(k,j)); 
        end
    end
end

end
