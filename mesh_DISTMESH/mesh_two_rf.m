function [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2] = mesh_two_rf(T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2,RF_p1,RF_p2,num_op,shape_mode,Tworf_opdis,mesh_divide,mesh_mode,bbox,plot_switch,figure_all_plot)
% mesh two RF electrode, refresh and store them in the arrays with Captial
ntmp=size(RF_p1);
nop=size(Tworf_opdis,2);
if (ntmp(1)==2)&(shape_mode==2)&(num_op*4+1==nop)
    for j=1:2
        pos1=RF_p1(j,:); pos2=RF_p2(j,:); % take out the boundary points of j-th DC electrodes
        mesh_size=Normal_mesh_size(pos1,pos2,mesh_divide);
        % set the opizimation array
        tmp_opdis=zeros(1,2*num_op+1);        tmp_opdis(1)=Tworf_opdis(1);
        if (j==1)
            tmp_opdis(1,2:2*num_op+1)= Tworf_opdis(1,2:2*num_op+1);
        else
            tmp_opdis(1,2:2*num_op+1)= Tworf_opdis(1,2*num_op+2:(4*num_op+1));
        end
        % set a bigger bbox for rf (where bbox is so large didn't use )
        bbox_line=abs(pos1(1)-pos2(1))/5;
        for k=1:2*num_op+1
            bbline(k)=abs(tmp_opdis(k));
        end 
        bbline(1)=bbox_line;
        bbox_line=max(bbline);
        bbox_rf=[min(pos1(1),pos2(1))-bbox_line, min(pos1(2),pos2(2))-bbox_line ; max(pos1(1),pos2(1))+bbox_line, max(pos1(2),pos2(2))+bbox_line];
        % meshing the electrode
        [p,num] = Topsurface_mesh_rfpoly(tmp_opdis,shape_mode,num_op,pos1,pos2,mesh_size,mesh_mode,bbox_rf,plot_switch,figure_all_plot);
        
        if (T_total==0)&(j==1)
            T_array=p;
            T_num_electrode(1)=num;
            T_total=num;
            for k=1:num
                node_array(1,k)=mean(p(:,1,k));
                node_array(2,k)=mean(p(:,2,k));
                node_array(3,k)=mean(p(:,3,k));
            end
            T_pos1(1,:)=RF_p1(1,:); T_pos2(1,:)=RF_p2(1,:);
        else
            ntmp=size(T_num_electrode);
            num_now=ntmp(2);
            T_num_electrode(num_now+1)=num;
            T_pos1(num_now+1,:)=RF_p1(j,:); T_pos2(num_now+1,:)=RF_p2(j,:);
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
    fprintf('Wrong in the number of RF electrodes or optizmation information \n ')
end

end

