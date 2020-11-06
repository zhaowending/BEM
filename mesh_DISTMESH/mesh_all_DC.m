function [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = mesh_all_DC(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,DC_p1,DC_p2,num_DC,mesh_divide,bbox,plot_switch,figure_all_plot)
% mesh all of the DC electrode, refresh and store them in this four array 
% The positions of cube DC electrodes are stored im DC_p1 amd DC_p2, the
% number of DC electrodes is num_DC 
ntmp=size(DC_p1);
if (ntmp(1)==num_DC)
   for j=1:num_DC
      pos1=DC_p1(j,:); pos2=DC_p2(j,:); % take out the boundary points of j-th DC electrodes
      mesh_size=Normal_mesh_size(pos1,pos2,mesh_divide);
      [p,num]=Topsurface_mesh_cube(pos1,pos2,mesh_size,bbox,plot_switch,figure_all_plot);
      if (T_total==0)
         T_array=p;  
         T_num_electrode(1)=num; 
         T_total=num; 
         for k=1:num 
             node_array(1,k)=mean(p(:,1,k));
             node_array(2,k)=mean(p(:,2,k));
             node_array(3,k)=mean(p(:,3,k));
         end 
         T_pos1(1,:)=DC_p1(1,:); T_pos2(1,:)=DC_p2(1,:); 
      else 
          ntmp=size(T_num_electrode); 
          num_now=ntmp(2);
          T_num_electrode(num_now+1)=num;
          T_pos1(num_now+1,:)=DC_p1(j,:); T_pos2(num_now+1,:)=DC_p2(j,:); 
          T_array(:,:,T_total+1:T_total+num)=p; 
          for k=1:num
             node_array(1,k+T_total)=mean(p(:,1,k));
             node_array(2,k+T_total)=mean(p(:,2,k));
             node_array(3,k+T_total)=mean(p(:,3,k));
          end    
          T_total=T_total+num;
      end 
   end 
else 
    fprintf('Wrong in the number of DC electrodes ')
end 


end

