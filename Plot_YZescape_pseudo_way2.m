function [y_plot,z_plot,potential_plot,center_escape,trap_center_all] = Plot_YZescape_pseudo_way2(plot_switch,plot_density,xr_plot,yr_plot,zr_plot,x_want,x,y,z,pseudo2_matrix,pseudo_PPdepth_center,title_txt)
%calculate and plot the pseudo_potential's  YZ plane 

[xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
nx=xr_plot(3)+1; ny=yr_plot(3)+1; nz=zr_plot(3)+1; 
n_plot_all=nx*ny*nz; 
pesudo_q_matrix= interp3(x,y,z,pseudo2_matrix,xq,yq,zq);
points_line_now=[reshape(xq,[n_plot_all,1]), reshape(yq,[n_plot_all,1]), reshape(zq,[n_plot_all,1])];
potential_now=reshape(pesudo_q_matrix,[1,n_plot_all]) ;
[y_plot,z_plot,potential_plot] = calplot_yzplane_pseudo_potential(plot_switch,yr_plot,zr_plot,plot_density,xr_plot,yr_plot,zr_plot,x_want,nx,ny,nz,points_line_now,potential_now,title_txt);

%% find¡¡the escape point 
    unit_y=(yr_plot(2)-yr_plot(1))/(ny-1);
    unit_x=(xr_plot(2)-xr_plot(1))/(nx-1);
    unit_z=(zr_plot(2)-zr_plot(1))/(nz-1);
    [PX,PY,PZ] = gradient(pesudo_q_matrix,unit_y,unit_x,unit_z);
    pp=zeros(n_plot_all,4);
    pp(:,1)=reshape(PX,n_plot_all,1);
    pp(:,2)=reshape(PY,n_plot_all,1);
    pp(:,3)=reshape(PZ,n_plot_all,1);
    for j=1:n_plot_all
        pp(j,4)=abs(pp(j,1))+abs(pp(j,2))+abs(pp(j,3));
    end
    [minpp,mindd]=min(pp(:,4));
    iz=floor((mindd-1)/(nx*ny))+1; iy=floor((mindd-((iz-1)*nx*ny)-1)/ny)+1; ix=rem(mindd,ny);
    center_escape=[xq(ix,iy,iz),yq(ix,iy,iz),zq(ix,iy,iz)];    
    if (plot_switch==0)
        plot([yq(ix,iy,iz)],[zq(ix,iy,iz)],'x','MarkerSize',15,'MarkerEdgeColor','r'); 
        title('The pseudo potential field around the escape point on the YZ plane');
    end 
    trap_center_all=pesudo_q_matrix(ix,iy,iz)-pseudo_PPdepth_center; 
end

