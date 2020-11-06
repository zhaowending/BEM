function F= myfun_trapfrequency_pseudo(c,x)
% the function of pseudo potential around the position used to calculate
% trap freuqency % myfun_trapfrequency_pseudo include 1.second order 2.cross second order 3. first order 4. C0 constant 
%  Psi = c1*x^2 +c2*y^2+ c3*z^2+ c4*xy+ c5*yz+ c6*xz+ c7*x+ c8*y + c9*z+ c10
%   x(j,1)==X, x(j,2)==Y, x(j,3)==Z
n=size(x,1);
for j=1:n
    F(j,1)=c(1)*x(j,1)*x(j,1)+c(2)*x(j,2)*x(j,2)+c(3)*x(j,3)*x(j,3)+c(4)*x(j,1)*x(j,2)+c(5)*x(j,2)*x(j,3)+c(6)*x(j,1)*x(j,3)+c(7)*x(j,1)+c(8)*x(j,2)+c(9)*x(j,3)+c(10);
end

end

