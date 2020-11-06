function V=change_voltage_N1_TO_N(v0)
%add a RF voltage , voltage number from N-1 to N

n=size(v0,1);
if (size(v0,1)>size(v0,2))
    V=zeros(1,n+1);
    V(1,1)=v0(1); V(1,2)=v0(1);
    for j=3:n+1
        V(1,j)=v0(j-1);
    end
    
else
    fprintf('wrong !! with number of voltages\n ');
end

end

