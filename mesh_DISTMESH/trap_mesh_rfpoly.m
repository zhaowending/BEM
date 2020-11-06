function [p,num] = trap_mesh_rfpoly(tmp_opdis,shape_mode,num_op,pos1,pos2,mesh_size,mesh_mode,bbox,plot_switch,figure_all_plot)
% this code is going to mesh a rf electrode, whose shape is arbitrarily poly
% it is a pre-code for rf's mesh, basically build rf_electrodes,shape
%% the example of input example
%pos1=[0,0,0]; % position on the left,front,bottom (x1,y1,z1)
%pos2=[2,0.5,1]; % position on the right,back, up (x2,y2,z2)
%mesh_size=0.08; % the size of each mesh unit; zxa
%mesh_mode=0; % the normal mesh size unit
%plot_switch=0;  %  plot or not
%bbox=[-10,-10;10,10]; % the zone region of the whole trap Bounding box [xmin,ymin; xmax,ymax]
%num_op=3;   % ;
%tmp_opdis=[0.1,-0.1,0.2,-0.1,0.2,0]; %¡¡the distance of each optimization  points

if (shape_mode==1)
    n_opdis=size(tmp_opdis); % for checking number of optizamtion points
    ulength=(abs(pos2(1)-pos1(1)))/(num_op+1);  % the length along x axis of electrodes
    num_opand2=num_op+2; num_opand3=num_op+3; num_opall=2*(num_op+2);
    op_x=zeros(1,num_opall);op_y=zeros(1,num_opall); %¡¡the X&Y poisition of optimization
    if (n_opdis(2)==2*num_op)
        for j=1:num_opall
            switch j
                case 1
                    op_x(j)=pos1(1); op_y(j)=pos1(2);
                case num_opand2
                    op_x(j)=pos2(1); op_y(j)=pos1(2);
                case num_opand3
                    op_x(j)=pos2(1); op_y(j)=pos2(2);
                case num_opall
                    op_x(j)=pos1(1); op_y(j)=pos2(2);
                otherwise
                    if (j<num_opand2) % (x1 line)
                        op_x(j)=pos1(1)+ulength*(j-1);
                        op_y(j)=tmp_opdis(j-1)+pos1(2);
                    else  % (x2 line )
                        op_x(j)=pos2(1)-ulength*(j-num_opand3);
                        op_y(j)=tmp_opdis(j-3)+pos2(2);
                    end
                    
            end
        end
    else
        fprintf('Wrong in optizmation point setting, the number of optizmations points !!!')
    end
end

if (shape_mode==2)
    n_opdis=size(tmp_opdis);
    ulength=tmp_opdis(1);
    center_x=(pos1(1)+pos2(1))/2;
    ban=floor(num_op/2)+1;
    if ((num_op*2+1)==n_opdis(2)) & (abs(pos1(1)-pos2(1))>ban*ulength)
        num_opand2=num_op+2; num_opand3=num_op+3; num_opall=2*(num_op+2);
        op_x=zeros(1,num_opall);op_y=zeros(1,num_opall); %¡¡the X&Y poisition of optimization
        for j=1:num_opall
            switch j
                case 1
                    op_x(j)=pos1(1); op_y(j)=pos1(2);
                case num_opand2
                    op_x(j)=pos2(1); op_y(j)=pos1(2);
                case num_opand3
                    op_x(j)=pos2(1); op_y(j)=pos2(2);
                case num_opall
                    op_x(j)=pos1(1); op_y(j)=pos2(2);
                otherwise
                    if (j<num_opand2) % (x1 line)
                        tj=j-1-ban; 
                        op_x(j)=center_x+ulength*tj;
                        op_y(j)=tmp_opdis(j)+pos1(2);
                    else  % (x2 line )
                        tj=j-num_opand3-ban; 
                        op_x(j)=center_x-ulength*tj;
                        op_y(j)=tmp_opdis(j-3+1)+pos2(2);
                    end
            end
        end
    else
        fprintf('Wrong in optizmation point setting, the number of optizmations points !!!')
    end
end

[p,num] = trap_mesh_poly(pos1,pos2,op_x,op_y,mesh_mode,mesh_size,bbox,num_op,num_opand2,num_opand3,num_opall,plot_switch,figure_all_plot);


end

