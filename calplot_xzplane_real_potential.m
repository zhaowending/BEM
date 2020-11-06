function [x_plot,z_plot,potential_plot] = calplot_xzplane_real_potential(plot_switch,plot_density,yr,y_want,nx,ny,nz,points,static_potential)
%calculate and plot the XZ plane (y==c)

y_line=linspace(yr(1),yr(2),yr(3)+1);
if (y_want<y_line(1))|(y_want>y_line(ny))
    fprintf('Wrong, Y position of XZ plane is out of range!!\n');
else
    %% find the position of plane between begin and end
    y_begin=-1; y_end=-1;
    for j=1:ny
        if (y_line(j)==y_want)
            y_begin=j;
            break;
        else
            if (y_line(j)<y_want)&(y_line(j+1)>y_want)
                y_begin=j; y_end=j+1;
                break
            end
        end
    end
    %% deal with
    if (y_begin>0)&(y_end==-1) % the position is at y_begin alright
        x_plot=zeros(nx,nz); z_plot=zeros(nx,nz); potential_plot=zeros(nx,nz);
        for k=1:nz
            for j=1:nx
                nowi=(k-1)*nx*ny+(j-1)*ny+y_begin; 
                x_plot(j,k)=points(nowi,1);
                z_plot(j,k)=points(nowi,3);
                potential_plot(j,k)=static_potential(1,nowi);
            end
        end
    else % the position between y_begin and end
        x_plot=zeros(nx,nz); z_plot=zeros(nx,nz); potential_plot=zeros(nx,nz);
        for k=1:nz
            for j=1:nx
                nowi=(k-1)*nx*ny+(j-1)*ny+y_begin; 
                x_plot(j,k)=points(nowi,1);
                z_plot(j,k)=points(nowi,3);
                %¡¡calculate the potential value 
                line_y=linspace(yr(1),yr(2),yr(3)+1);
                for ii=1:ny
                  nowi=(k-1)*nx*ny+(j-1)*ny+ii;
                  line_pot(ii)=static_potential(1,nowi);
                end 
                
                dis_left=abs(line_y(y_begin)-y_want); dis_right=abs(line_y(y_end)-y_want); 
                dis_unit=abs(line_y(y_begin)-line_y(y_end));
                multi=floor(dis_unit/min(dis_left,dis_right));
                line_y2=linspace(yr(1),yr(2),multi*yr(3)+1);              
                line_pot2=interp1(line_y,line_pot,line_y2); 
                find_y1=-1;find_y2=-1;
                for ii=1:size(line_y2,2)
                    if (line_y2(ii)==y_want)
                       find_y1=ii;
                    else
                       if (line_y2(ii)<y_want)&(line_y2(ii+1)>y_want)
                         find_y1=ii;find_y2=ii+1;
                       end 
                    end 
                end 
                if (find_y1>-1)&(find_y2==-1)
                    potential_plot(j,k)=line_pot2(find_y1);
                else 
                    if (find_y1>-1)&(find_y2>-1)
                      potential_plot(j,k)=(line_pot2(find_y1)+line_pot2(find_y2))/2;
                    end 
                end
                

            end
        end 
    end
end

%% plot 
if (plot_switch==0)
figure
[C,h]=contourf(x_plot,z_plot,potential_plot,plot_density);
title('The real potential field on XZ plane of Y==y_{want}');
xlabel('X axis along RF electrode');
ylabel('Z axis along gravity vertical ')
colorbar 
hold on
end 
end

