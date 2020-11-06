function F= myfun_trapfrequency_pseudo2(c,x)
% the function of pseudo potential around the position used to calculate trap freuqency
% myfun_trapfrequency_pseudo2 include 1.second order 2. cross term 3. first order 4. C0 constant 
% The difference between myfun_trapfrequency_pseudo is croos term 
%  Psi = c1*(x-c4)^2 +c2*(y-c5)^2+ c3*(z-c6)^2+ c7*xy+ c8*yz + c9*xz + c10
% In this function, we assume that and center point is at c4,c5,c6 
%   x(j,1)==X, x(j,2)==Y, x(j,3)==Z


n=size(x,1);
for j=1:n
    F(j,1)=c(1)*(x(j,1)-c(4))^2+ c(2)*(x(j,2)-c(5))^2+ c(3)*(x(j,3)-c(6))^2+ c(7)*x(j,1)*x(j,2)+ c(8)*x(j,2)*x(j,3)+ c(9)*x(j,1)*x(j,3)+ c(10); 
end

end

