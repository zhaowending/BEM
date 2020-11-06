function [charge_basis,T_num_before,T_total,num_total_electrode]=Calculate_chargebasis(Check_chargebasis_large,Threshold_chargebasis,T_num_electrode,T_total,T_array,node_array)
%calculate the charge_basis 
ntmp=size(T_num_electrode); num_total_electrode=ntmp(2);
%% calculate the number before
T_num_before=T_num_electrode;
for j=2:num_total_electrode
    T_num_before(j)=T_num_before(j-1)+T_num_electrode(j);
end
%% calculate
A=node_array';
alpha=Malpha(T_array,A,T_total);

na=size(alpha);
for ii=1:na(1)
    for jj=1:na(2)
        if (imag(alpha(ii,jj)) ~=0)
            [ii,jj]
            alpha(ii,jj)
            alpha(jj,ii)
        end
    end 
end 
%% calculate the charge-basis for each j-th electrode V_j=1
charge_basis=zeros(T_total,num_total_electrode);
for j=1:num_total_electrode
    %%%%%%%%%% give the voltage array,  v_j=1,    else=0 %%%%%%%%%%%%%%%
    vj=zeros(T_total,1);
    begin_index=1; final_index=T_total; % the triangle number of i-th electrodes
    if (j==1)
        final_index=T_num_electrode(1);
    else
        begin_index=T_num_before(j-1)+1;
        final_index=T_num_before(j);
    end
    vj(begin_index:final_index,1)=ones((final_index-begin_index+1),1);
    %%%%%%%%% matrix calculation of charge basis
    chargep=inv(alpha)*vj; 
    charge_basis(:,j)=chargep.*4*pi;
end

if (Check_chargebasis_large==1) % delete the elements > thershold_chargebasis in Chargebasis
    for j=1:T_total
        for k=1:num_total_electrode
            if (abs(charge_basis(j,k))>Threshold_chargebasis)
                charge_basis(j,k)=0; % delete this element
            end
        end
    end
end
end

