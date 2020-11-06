function [y_plot,z_plot,potential_plot,center_pseudo,pseudo_PPdepth_center] = Plot_YZ_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,pseudo2_matrix,title_txt)
%calculate and plot the pseudo_potential's  YZ plane 
%center pseudo is just the center point which is calculated by the potential on YZ plane£¬ in a 2D plane . 
% 
[xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
nx=xr_plot(3)+1; ny=yr_plot(3)+1; nz=zr_plot(3)+1; 
n_plot_all=nx*ny*nz; 
pesudo_q_matrix= interp3(x,y,z,pseudo2_matrix,xq,yq,zq);
points_line_now=[reshape(xq,[n_plot_all,1]), reshape(yq,[n_plot_all,1]), reshape(zq,[n_plot_all,1])];
potential_now=reshape(pesudo_q_matrix,[1,n_plot_all]) ;
[y_plot,z_plot,potential_plot] = calplot_yzplane_pseudo_potential(plot_switch,yr_plot,zr_plot,plot_density,xr_plot,yr_plot,zr_plot,x_want,nx,ny,nz,points_line_now,potential_now,title_txt);
%% find the maximum along Z axis 
min_potential=min(min(potential_plot));
[min_index,max_index]=find(potential_plot==min_potential);
%% find center Z
if potential_plot(min_index,max_index-1)< potential_plot(min_index,max_index+1)
  max2_index=max_index-1;
else
   max2_index=max_index+1;   
end 
dis1=abs(potential_plot(min_index,max_index-1)-potential_plot(min_index,max_index));
dis2=abs(potential_plot(min_index,max_index)-potential_plot(min_index,max_index+1));
dd=abs(dis1-dis2);
ratio=0.5*(dd/max(dis1,dis2));
if max2_index<max_index
  z_index=z_plot(min_index,max_index)-ratio*(z_plot(min_index,max_index)-z_plot(min_index,max2_index)); 
else 
  z_index=z_plot(min_index,max_index)+ratio*(z_plot(min_index,max2_index)-z_plot(min_index,max_index)); 
end

%% find center y
if potential_plot(min_index-1,max_index)< potential_plot(min_index+1,max_index)
  min2_index=min_index-1;
else
   min2_index=min_index+1;   
end 
dis1=abs(potential_plot(min_index-1,max_index)-potential_plot(min_index,max_index));
dis2=abs(potential_plot(min_index+1,max_index)-potential_plot(min_index,max_index));
dd=abs(dis1-dis2);
ratio=0.5*(dd/max(dis1,dis2));
if min2_index<min_index
  y_index=y_plot(min_index,max_index)-ratio*(y_plot(min_index,max_index)-y_plot(min2_index,max_index)); 
else 
  y_index=y_plot(min_index,max_index)+ratio*(y_plot(min2_index,max_index)-y_plot(min_index,max_index)); 
end


center_pseudo=[x_want,y_index,z_index];
if (plot_switch==0)
plot([y_index],[z_index],'x','MarkerSize',15,'MarkerEdgeColor','r');
end 

pseudo_PPdepth_center= min(min(potential_plot)); % not trap depth 

end

