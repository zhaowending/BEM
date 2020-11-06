function [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] =mesh_slotDC(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,slotdc_p1,slotdc_p2,N_slotdc,mesh_divide,bbox,plot_switch,figure_all_plot)
% mesh the slot DC electrode, always ground, Thus these area can be ground
% electrode or vacuum. The electrode will be divided into several rectangle
% and mesh each rectangle electrode, usually 4 in all
T_time_array=[];
T_time_num=0;

ntmp=size(slotdc_p1);
num_now=size(T_num_electrode,2);
T_num_electrode(num_now+1)=0;
if (ntmp(1)==N_slotdc)
    for j=1:N_slotdc
        pos1=slotdc_p1(j,:); pos2=slotdc_p2(j,:); % take out the boundary points of j-th DC electrodes
        mesh_size=Normal_mesh_size(pos1,pos2,mesh_divide);
        [p,num]=Topsurface_mesh_cube(pos1,pos2,mesh_size,bbox,plot_switch,0);
        T_num_electrode(num_now+1)=T_num_electrode(num_now+1)+num;
        T_array(:,:,T_total+1:T_total+num)=p;
        for k=1:num
            node_array(1,k+T_total)=mean(p(:,1,k));
            node_array(2,k+T_total)=mean(p(:,2,k));
            node_array(3,k+T_total)=mean(p(:,3,k));
        end
        T_total=T_total+num;
        
        if (figure_all_plot==1)
            fill_x=[pos1(1),pos2(1),pos2(1),pos1(1),pos1(1)];
            fill_y=[pos1(2),pos1(2),pos2(2),pos2(2),pos1(2)];
            fill(fill_x,fill_y,'y');
        else
            if (figure_all_plot==2)
                for ii=1:num
                    plot_tt=p(:,:,ii);
                    t_x=[plot_tt(1,1),plot_tt(2,1),plot_tt(3,1),plot_tt(1,1)];
                    t_y=[plot_tt(1,2),plot_tt(2,2),plot_tt(3,2),plot_tt(1,2)];
                    fill(t_x,t_y,'y');
                    hold on
                end
            end
        end
    end
    T_pos1(num_now+1,:)=slotdc_p1(1,:); T_pos2(num_now+1,:)=slotdc_p2(2,:);
else
    fprintf('Wrong in the number of mid DC electrodes around  slot')
end


end

