function [center_fit_end,c] = calculate_center_pyfit(center_pseudo,x,y,z,static_matrix,pseudo2_matrix,um)
%calculate the center point

round=1; round_up_limit=2;
cut_off=0.1*um;  difference=1*um;
center_fit(1,:)=center_pseudo; 

for j=1:round_up_limit
    %% Calculate the matrix
    xr_plot=[-15*um+center_fit(round,1),15*um+center_fit(round,1),30]; % x plotting range around center_X
    yr_plot=[-10*um+center_fit(round,2),10*um+center_fit(round,2),25];  %  y plotting range around center_Y
    zr_plot=[-10*um+center_fit(round,3),10*um+center_fit(round,3),40]; % the plot range

    [xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
    nx=xr_plot(3)+1; ny=yr_plot(3)+1; nz=zr_plot(3)+1;  % the number and length of plot XYZ
    n_plot_all=nx*ny*nz; % the number of all points
    static_q_matrix= interp3(x,y,z,static_matrix,xq,yq,zq); %¡¡enlarge the matrix of static potential
    pseudo_q_matrix= interp3(x,y,z,pseudo2_matrix,xq,yq,zq);% enlarge the matrix of pseudo potential
    %%¡¡ploy fit to calculate C
    X=zeros(n_plot_all,3);
    X(:,1)=reshape(xq,n_plot_all,1); X(:,2)=reshape(yq,n_plot_all,1); X(:,3)=reshape(zq,n_plot_all,1);
    Y=zeros(n_plot_all,1);
    Y(:,1)=reshape(pseudo_q_matrix,n_plot_all,1);
    c0=[1,1,1,0,0,0,0,0,0,0];
    c = nlinfit(X,Y,@myfun_trapfrequency_pseudo,c0);
    %% calculate the center point
    syms xc yc zc
    eqns = [2*c(1)*xc + c(4)*yc + c(6)*zc +c(7) == 0, 2*c(2)*yc+c(4)*xc+c(5)*zc+c(8)== 0, 2*c(3)*zc+c(5)*yc+c(6)*xc+c(9)==0];
    vars = [xc,yc,zc];
    center_struct=solve(eqns, vars);
    round=round+1; 
    center_fit(round,1)=double(center_struct.xc);
    center_fit(round,2)=double(center_struct.yc);
    center_fit(round,3)=double(center_struct.zc);
    %% refresh 
    dd=center_fit(round,:)-center_fit(round-1,:);
    difference=(abs(dd(1))+abs(dd(2))+abs(dd(3)))/3; 
    if (difference<cut_off)
        break
    end 
end
center_fit_end=center_fit(round,:); 
end

