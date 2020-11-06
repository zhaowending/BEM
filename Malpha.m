function alpha=Malpha(triangles,A,len)
% calculate the alpha matrix (without threshold approximate)
alpha=zeros(len,len);
for j=1:len
    T_now= triangles(:,:,j); 
    alpha(:,j)=int_green3d_tri(A,T_now);
end
end