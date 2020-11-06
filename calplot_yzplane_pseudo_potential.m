function  [y_plot,z_plot,potential_plot] = calplot_yzplane_pseudo_potential(plot_switch,yr_plot,zr_plot,plot_density,xr,yr,zr,x_want,nx,ny,nz,points,pseudo_potential,title_txt)
%calculate and plot the XZ plane (x==c)
cut_off=2*10^(-8); 
x_line=linspace(xr(1),xr(2),xr(3)+1);
if (x_want<x_line(1))|(x_want>x_line(nx))
    fprintf('Wrong, the want X position of YZ plane is out of range!!\n');
else
    %% find the position of plane between begin and end
    x_begin=-1; x_end=-1;
    for j=1:nx
        if (abs(x_line(j)-x_want)<cut_off)
            x_begin=j;
            break;
        else
            if (x_line(j)<x_want-cut_off)&(x_line(j+1)>x_want+cut_off)
                x_begin=j; x_end=j+1;
                break
            end
        end
    end
    %% deal with
    if (x_begin>0)&(x_end==-1) % the position is at y_begin alright
        y_plot=zeros(ny,nz); z_plot=zeros(ny,nz); potential_plot=zeros(ny,nz);
        for k=1:nz
            for j=1:ny
                nowi=(k-1)*nx*ny+(x_begin-1)*ny+j; 
                y_plot(j,k)=points(nowi,2);
                z_plot(j,k)=points(nowi,3);
                potential_plot(j,k)=pseudo_potential(nowi);
            end
        end
    else % the position between y_begin and end
        y_plot=zeros(ny,nz); z_plot=zeros(ny,nz); potential_plot=zeros(ny,nz);
        for k=1:nz
            for j=1:ny
                nowi=(k-1)*nx*ny+x_begin*ny+j; 
                y_plot(j,k)=points(nowi,2);
                z_plot(j,k)=points(nowi,3);
                %¡¡calculate the potential value 
                line_x=linspace(xr(1),xr(2),xr(3)+1);
                for ii=1:nx
                  nowi=(k-1)*nx*ny+(ii-1)*ny+j;
                  line_pot(ii)=pseudo_potential(nowi);
                end 
                
                dis_left=abs(line_x(x_begin)-x_want); dis_right=abs(line_x(x_end)-x_want); 
                dis_unit=abs(line_x(x_begin)-line_x(x_end));
                multi=floor(dis_unit/min(dis_left,dis_right));
                line_x2=linspace(xr(1),xr(2),multi*xr(3)+1);              
                line_pot2=interp1(line_x,line_pot,line_x2); 
                find_x1=-1;find_x2=-1;
                for ii=1:size(line_x2,2)
                    if (line_x2(ii)==x_want)
                       find_x1=ii;
                    else
                       if (line_x2(ii)<x_want)&(line_x2(ii+1)>x_want)
                         find_x1=ii;find_x2=ii+1;
                       end 
                    end 
                end 
                if (find_x1>-1)&(find_x2==-1)
                    potential_plot(j,k)=line_pot2(find_x1);
                else 
                    if (find_x1>-1)&(find_x2>-1)
                      potential_plot(j,k)=(line_pot2(find_x1)+line_pot2(find_x2))/2;
                    end 
                end
                

            end
        end 
    end
end
if (plot_switch==0)
figure
[C,h]=contourf(y_plot,z_plot,potential_plot,plot_density);
clabel(C,h) 
colorbar 
title(title_txt);
xlabel('Y axis perpendicular to RF electrode');
ylabel('Z axis along gravity vertical ');
hold on
end
% 
% figure
% 
% yline=linspace(yr_plot(1),yr_plot(2),yr_plot(3)+1);
% zline=linspace(zr_plot(1),zr_plot(2),zr_plot(3)+1);
% [yq,zq] = meshgrid(yline,zline);
% potential_q = interp2(y_plot,z_plot,potential_plot,yq,zq);
% contour(yq,zq,potential_q);
% title('The real potential field on YZ plane of x==x_{want}');
% xlabel('Y axis perpendicular to RF electrode');
% ylabel('Z axis along gravity vertical ');

end

