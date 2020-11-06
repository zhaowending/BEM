function [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = Mesh_ground_expectDC(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,bbox,plot_switch,figure_all_plot)
% mesh the grounded electrode and save in T-captial parameter
cutsize=10; % the cut size for divide in two functions named judge
ntmp=size(T_pos1); boundary_electrode=[];
for j=1:ntmp(1) %boundary_electrode=[..;x1,x2,y1,y2  ;  ; ]
    boundary_electrode(j,1)=min(T_pos1(j,1),T_pos2(j,1));
    boundary_electrode(j,2)=max(T_pos1(j,1),T_pos2(j,1));  % x1<x<x2
    boundary_electrode(j,3)=min(T_pos1(j,2),T_pos2(j,2));
    boundary_electrode(j,4)=max(T_pos1(j,2),T_pos2(j,2)); % y1<y<y2
end
mesh_size_all=3*Mesh_size_cube(boundary_electrode(1,1),boundary_electrode(1,2),boundary_electrode(1,3),boundary_electrode(1,4));
% mesh_size_all is the mesh size of ground, you can change the number
% before *, to modify the size of meshing triangle 
if (size(T_num_electrode,2)==ntmp(1))
    x1=bbox(1,1); x2=bbox(2,1); y1=bbox(1,2); y2=bbox(2,2);
    fd=@(p)drectangle(p,x1,x2,y1,y2);
    [p,t]=distmesh2d(plot_switch,fd,@huniform,mesh_size_all,[min(x1,x2),min(y1,y2); max(x1,x2),max(y1,y2)],[x1,y1;x1,y2;x2,y1;x2,y2]);
    node_num=size(p,1);
    if (T_pos2(1,3)==0)&(T_pos2(ntmp(1),3)==0)
        p(:,3)=zeros(node_num,1); % give the Z position, just the Z=0 surface
    end
    p_label=zeros(node_num,1); % 0 for this node ok, 1 for this node was in electrodes
    for j=1:node_num  % check node(i) was in the electrode already or not
        for k=1:ntmp(1) % for k-th electrode
            if (p(j,1)>=boundary_electrode(k,1))&(p(j,1)<=boundary_electrode(k,2)) & (p(j,2)>=boundary_electrode(k,3))&(p(j,2)<=boundary_electrode(k,4))
%                 [p_label(j,1),pj_new]=judge_inside_orout(k,boundary_electrode,p(j,:),ntmp(1),mesh_size_all,cutsize);
%                 if (p_label(j,1)==0)
%                      p(j,:)=pj_new; %¡¡mode-2, modify this point out of electrode 
%                      break
%                 else 
%                     p_label(j,1)=1; 
%                 end     
              p_label(j,1)=1; 
            end
        end % k
    end % j
    %% record the ground part
    num_gr=ntmp(1)+1;
    T_pos1(num_gr,1)=x1; T_pos1(num_gr,2)=y1; T_pos1(num_gr,3)=T_pos1(1,3);
    T_pos2(num_gr,1)=x2; T_pos2(num_gr,2)=y2; T_pos2(num_gr,3)=T_pos2(1,3);
    triangle_num=size(t,1);
    No_use_num=triangle_num;  % the number of triangle which has been electrode
    Yes_use_num=0; % the number of grounded triangle
    for j=1:triangle_num
        bool_use=0;
        for k=1:3
            if (p_label(t(j,k),1)==1) & (bool_use==0)
                bool_use=1;
                t(j,:)=zeros(1,3);
                break
            end
        end
%         if (bool_use==0)
%             i1=t(j,1); i2=t(j,2); i3=t(j,3); 
%             list(1,:)=p(i1,:); list(2,:)=p(i2,:); list(3,:)=p(i3,:);
%             list(4,:)=(list(1,:)+list(2,:))./2;
%             list(5,:)=(list(2,:)+list(3,:))./2;
%             list(6,:)=(list(1,:)+list(3,:))./2;
%             bool_use=judge_triangle_inside(mesh_size_all,list,boundary_electrode,cutsize );
%         end 
        if (bool_use==0) % if this triangle can be used as ground electrode
            Yes_use_num=Yes_use_num+1;
            No_use_num=No_use_num-1;
            T_array(1,:,T_total+Yes_use_num)=p(t(j,1),:);
            T_array(2,:,T_total+Yes_use_num)=p(t(j,2),:);
            T_array(3,:,T_total+Yes_use_num)=p(t(j,3),:);
            node_array(1,T_total+Yes_use_num)=mean(T_array(:,1,T_total+Yes_use_num));
            node_array(2,T_total+Yes_use_num)=mean(T_array(:,2,T_total+Yes_use_num));
            node_array(3,T_total+Yes_use_num)=mean(T_array(:,3,T_total+Yes_use_num));
            if (figure_all_plot==1)|(figure_all_plot==2)
                plot_tt=T_array(:,:,T_total+Yes_use_num);
                t_x=[plot_tt(1,1),plot_tt(2,1),plot_tt(3,1),plot_tt(1,1)];
                t_y=[plot_tt(1,2),plot_tt(2,2),plot_tt(3,2),plot_tt(1,2)];
                fill(t_x,t_y,'y');
                hold on
            end
        end
    end
    if (triangle_num-No_use_num==Yes_use_num)
        T_num_electrode(num_gr)=Yes_use_num;
        T_total=T_total+Yes_use_num;
    else
        fprintf('Wrong with the number of grounded electrode !!')
    end
else
    fprintf('Wrong with the number of T_pos when mesh Ground !!\n ');
end


end

