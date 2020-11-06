function [y_plot,z_plot,potential_plot] =  Plot_YZ_static_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,static_matrix,title_txt)
%calculate and plot the pseudo_potential's  YZ plane 

[xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
nx=xr_plot(3)+1; ny=yr_plot(3)+1; nz=zr_plot(3)+1; 
n_plot_all=nx*ny*nz; 
static_q_matrix= interp3(x,y,z,static_matrix,xq,yq,zq);
points_line_now=[reshape(xq,[n_plot_all,1]), reshape(yq,[n_plot_all,1]), reshape(zq,[n_plot_all,1])];
potential_now=reshape(static_q_matrix,[1,n_plot_all]) ;
[y_plot,z_plot,potential_plot] = calplot_yzplane_pseudo_potential(plot_switch,yr_plot,zr_plot,plot_density,xr_plot,yr_plot,zr_plot,x_want,nx,ny,nz,points_line_now,potential_now,title_txt);

end

