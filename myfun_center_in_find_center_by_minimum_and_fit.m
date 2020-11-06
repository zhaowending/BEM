function F= myfun_center_in_find_center_by_minimum_and_fit(c,x)
% the function of pseudo potential around the position
%   x(j,1)==X, x(j,2)==Y, x(j,3)==Z
n=size(x,1);
F=zeros(n,1);
for j=1:n
    F(j,1)=c(1)*(x(j,1)-c(2))^2+ c(3)*(x(j,2)-c(4))^2 + c(5)*(x(j,3)-c(6))^2 + c(7);
end

end 

