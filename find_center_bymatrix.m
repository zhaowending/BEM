function [center_data,difference,center_round] = find_center_bymatrix(center_ini,x,y,z,static_matrix,pseudo2_matrix,um,rrx,rry,rrz)
% find the center point by matrix operation just calculate the gradient of
% this matrix
round=1; round_limit=60;
cut_off=0.0001*um; difference=3*um;
center=[];
center(1,:)=center_ini;
for j=1:round_limit
    ratio=(1-(j/round_limit))+0.2; 
    ratio2=1+(j/round_limit); 
    xr_plot=[-rrx*ratio+center(round,1),rrx*ratio+center(round,1),floor(50*ratio2)]; % x plotting range around center_X
    yr_plot=[-rry*ratio+center(round,2),rry*ratio+center(round,2),floor(30*ratio2)];  %  y plotting range around center_Y
    zr_plot=[-rrz*ratio+center(round,3),rrz*ratio+center(round,3),floor(40*ratio2)]; % the plot range
    
    [xq,yq,zq]=meshgrid(linspace(xr_plot(1),xr_plot(2),xr_plot(3)+1),linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1),linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1));
    nx=xr_plot(3)+1; ny=yr_plot(3)+1; nz=zr_plot(3)+1;  % the number and length of plot XYZ
    n_plot_all=nx*ny*nz; % the number of all points
    static_q_matrix= interp3(x,y,z,static_matrix,xq,yq,zq); % enlarge the matrix of static potential
    pseudo_q_matrix= interp3(x,y,z,pseudo2_matrix,xq,yq,zq);% enlarge the matrix of pseudo potential
    
    unit_y=(yr_plot(2)-yr_plot(1))/(ny-1);
    unit_x=(xr_plot(2)-xr_plot(1))/(nx-1);
    unit_z=(zr_plot(2)-zr_plot(1))/(nz-1);
    [PX,PY,PZ] = gradient(pseudo_q_matrix,unit_y,unit_x,unit_z);
    pp=zeros(n_plot_all,4);
    pp(:,1)=reshape(PX,n_plot_all,1);
    pp(:,2)=reshape(PY,n_plot_all,1);
    pp(:,3)=reshape(PZ,n_plot_all,1);
    
    for j=1:n_plot_all
        pp(j,4)=abs(pp(j,1))+abs(pp(j,2))+abs(pp(j,3));
    end
    [minpp,mindd]=min(pp(:,4));
    
    iz=floor((mindd-1)/(nx*ny))+1; iy=floor((mindd-((iz-1)*nx*ny)-1)/ny)+1; ix=rem(mindd,ny);
    
    if (iz<1)
        iz=1;
    end
    if (ix<1)
        ix=1;
    end
    if (iy<1)
        iy=1;
    end
    center_data=[xq(ix,iy,iz),yq(ix,iy,iz),zq(ix,iy,iz)];
    round=round+1;
    center(round,:)=center_data;
    dd=center(round,:)-center(round-1,:); 
    difference=(abs(dd(1))+abs(dd(2))+abs(dd(3)))/3; 
    if (difference<cut_off)
        break
    end
end

center_data=center(round,:);
center_round=round; 
end

