function v0=change_voltage_N_TO_N1(V)
%delete a RF voltage , voltage number from N to N-1

n=size(V,2);
v0=zeros(n-1,1);
v0(1)=V(1);
for j=3:n
    v0(j-1,1)=V(j); 
end 

end

