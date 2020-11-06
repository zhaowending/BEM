function [c_2order,center_fit_xaxis_2order] = plot_Xais_arond_trap_center(plot_switch,center_data,xr_plot,yr_plot,zr_plot,x,y,z,pseudo2_matrix)
% plot the pseudo potential along X axis (RF's direction ) arond the trap
% center 
[xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
nx=xr_plot(3)+1; ny=yr_plot(3)+1; nz=zr_plot(3)+1;
n_plot_all=nx*ny*nz;
pesudo_q_matrix= interp3(x,y,z,pseudo2_matrix,xq,yq,zq);

if (mod(ny,2)==1) &(mod(nz,2)==1)
    plot_xline=zeros(1,nx);
    plot_pseudo_line=zeros(1,nx);
    iy=floor(ny/2)+1; iz=floor(nz/2)+1;
    for j=1:nx
        plot_xline(j)=xq(iy,j,iz);
        plot_pseudo_line(j)=pesudo_q_matrix(iy,j,iz);
    end
    if (plot_switch==0)
        figure
        plot( plot_xline, plot_pseudo_line);
        xlabel('x position along RFs direction.'); ylabel('The value pseudo potential')
        title('The pseudo potential along RF direction, orgin is the trap cneter(X is not center_Data(1))')
        hold on;
    end
    %% fit in 2 order
    X=plot_xline; Y=plot_pseudo_line;
    c0_2order=[8661715.50696070,0.0375843224111840,-0.138459274951453];
    c_2order = nlinfit(X,Y,@myfun_Xaxis_RFdirection_2order,c0_2order);
    
    syms xc
    eqns=[c_2order(1)*2*xc+c_2order(2)==0];
    vars=[xc];
    center_struct=solve(eqns, vars);
    center_fit_xaxis_2order=zeros(1,3);
    center_fit_xaxis_2order(1)=double(center_struct);
    center_fit_xaxis_2order(2)=center_data(2);
    center_fit_xaxis_2order(3)=center_data(3);
%    %% fit in 4 order
%     X=plot_xline; Y=plot_pseudo_line;
%     c0_4order=[0,0,866171.50696070,0.0375843224111840,-0.138459274951453];
%     c_4order = nlinfit(X,Y,@myfun_Xaxis_RFdirection_4order,c0_4order);
%     
%     syms xc
%     eqns=[c_4order(1)*4*xc^3+c_4order(2)*3*xc^2+c_4order(3)*2*xc+c_4order(4)==0];
%     vars=[xc];
%     center_struct=solve(eqns, vars);
%     center_fit_xaxis_4order=double(center_struct);
else
    fprintf('Wrong !! The number of Y_plot or Z_plot is odd. It should be even!! \n ');
end

end

