V=[3,5,0];
static_potential=[];
for j=1:num_total_electrode
    if (j==1)
        static_potential=potential_basis(:,:,1)*V(1);
    else 
        static_potential=static_potential+potential_basis(:,:,j)*V(j);
    end 
end 
%%%%%%%%%%%%% compare with analysis equation %%%%%%%%%%%%%%%%%%%%%%
static_potential=static_potential';
x(:,1)=T_pos1(:,1); x(:,2)=T_pos2(:,1);
y(:,1)=T_pos1(:,2); y(:,2)=T_pos2(:,2);
syms xc;
syms yc;
syms zc; 
en=size(x,1);
for  j=1:en   %% each electrode potential    
      term(j,1)=atan(((x(j,2)-xc)*(y(j,2)-yc))/(zc*sqrt(zc^2+(x(j,2)-xc)^2+(y(j,2)-yc)^2)));
      term(j,2)=-atan(((x(j,1)-xc)*(y(j,2)-yc))/(zc*sqrt(zc^2+(x(j,1)-xc)^2+(y(j,2)-yc)^2)));
      term(j,3)=-atan(((x(j,2)-xc)*(y(j,1)-yc))/(zc*sqrt(zc^2+(x(j,2)-xc)^2+(y(j,1)-yc)^2)));
      term(j,4)=atan(( (x(j,1)-xc)*(y(j,1)-yc) )/(zc*sqrt(zc^2+(x(j,1)-xc)^2+(y(j,1)-yc)^2)));
end
for j=1:en
      psi_dc(j)=(term(j,1)+term(j,2)+term(j,3)+term(j,4))/(2*pi);    %% the eigen-potential of DC 
end
psi_dc(3)=0; 
pot_all=psi_dc*V';
ana_potential=[];
for j=1:P_num_total(1)
    ana_potential(j,1)=double( subs(subs(subs(pot_all,xc,points(j,1)),yc,points(j,2)),zc,points(j,3))  );
end 

did=static_potential(1,1)/ana_potential(1); %did=1.33
ana2=ana_potential.*did;
%% check the potential 
check_array(:,1)=static_potential(:,1);
check_array(:,2)=ana2; 
check_array(:,3)=check_array(:,1)-check_array(:,2);
for j=1:343     
    check_array(j,4)=check_array(j,3)/check_array(j,1) ;
end 