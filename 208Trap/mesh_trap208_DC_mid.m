function [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = mesh_trap302_DC_mid(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,DC_x,DC_y,en,mesh_divide,plot_switch,figure_all_plot,Z_depth,Z_surface,um)
%mesh all DC electrode (302 surface trap)

for j=en-1:en
    pos1=[min(DC_x(j,:)), min(DC_y(j,:)) ,Z_depth]; % take out the boundary points of j-th DC electrodes , minimum 
    pos2=[max(DC_x(j,:)), max(DC_y(j,:)) ,Z_surface]; % take out the boundary points of j-th DC electrodes   maximum
    %% define the mesh size of meshing triangles 
    mesh_size=Normal_mesh_size(pos1,pos2,mesh_divide);
    %% mesh this electrode 
    op_x=DC_x(j,:); op_y=DC_y(j,:); % define the boundary points of this electrode
    bbox= [min(DC_x(j,:))-10*um, min(DC_y(j,:))-10*um ; max(DC_x(j,:))*um, max(DC_y(j,:))*um ]; % give boundary box 
    num_op=1; num_opand2=3; num_opand3=4; num_opall=6;
    mesh_mode=2;
    %% 
%     if j>=en-1
%         mesh_size=8*um; 
%     end
    [p,num]=Topsurface_mesh_cube(pos1,pos2,mesh_size,bbox,plot_switch,figure_all_plot);
    %[p,num] = Topsurface_mesh_poly_self(pos1,pos2,op_x,op_y,mesh_mode,mesh_size,bbox,num_op,num_opand2,num_opand3,num_opall,plot_switch,figure_all_plot);

    %%
    if (T_total==0)&(j==1)
        T_array=p;
        T_num_electrode(1)=num;
        T_total=num;
        for k=1:num
            node_array(1,k)=mean(p(:,1,k));
            node_array(2,k)=mean(p(:,2,k));
            node_array(3,k)=mean(p(:,3,k));
        end
        T_pos1(1,:)=pos1; T_pos2(1,:)=pos2;
    else
        num_now=size(T_num_electrode,2);
        T_num_electrode(num_now+1)=num; % save the number of meshing triangles in this electrode 
        T_pos1(num_now+1,:)=pos1; T_pos2(num_now+1,:)=pos2; % save the two boundary positions 
        T_array(:,:,T_total+1:T_total+num)=p;
        for k=1:num
            node_array(1,k+T_total)=mean(p(:,1,k));
            node_array(2,k+T_total)=mean(p(:,2,k));
            node_array(3,k+T_total)=mean(p(:,3,k));
        end
        T_total=T_total+num;
    end
    
end


end

