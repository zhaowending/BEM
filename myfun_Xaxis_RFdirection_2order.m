function F= myfun_Xaxis_RFdirection_2order(c,x)
% the function of pseudo potential around the position
%   x(j,1)==X, 
% F= c1 x^2+c2*x+c3
n=size(x,2);
for j=1:n 
  F(j)= c(1)*x(j)*x(j)+c(2)*x(j)+c(3); 
end
end 

