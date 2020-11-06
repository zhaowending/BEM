function [judge_label,pj_new]=judge_inside_orout(k,boundary_electrode,pos,num_electrode,M_size,cutsize)
%judge the node is the triangle or not, if it is close to the boudary
pj_new=zeros(1,3);
x=pos(1); y=pos(2);
dis1=x-boundary_electrode(k,1); dis2=boundary_electrode(k,2)-x;
dis3=y-boundary_electrode(k,3); dis4=boundary_electrode(k,4)-y;
%% modify the position
bool_c=1; % if bool_c=1 means out of electrode, give up; if bool_c=0 means it is can be used.
% inital condition: bool_c=1 means this point is not aiviable now
up_multi=1.5; 
up_part=8/10; y_length=abs(boundary_electrode(k,4)-boundary_electrode(k,3)); x_length=abs(boundary_electrode(k,2)-boundary_electrode(k,1));
down_multi=0.3;
down_part=1-up_part; 
if ((dis1<down_multi*M_size)|(dis1<down_part*x_length)) &(dis1>0)&(dis2>0)& ((dis2>up_multi*M_size)|(dis2>up_part*x_length)) %  x close to x1
    x=boundary_electrode(k,1)-M_size/cutsize;
    bool_c=0;  % means it may be aiviable
else
    if (dis1>0)&(dis2>0) & ((dis2<down_multi*M_size)|(dis2<down_part*x_length)) & ((dis1>up_multi*M_size)|(dis1>up_part*x_length)) % close to x2
        x=boundary_electrode(k,2)+M_size/cutsize;
        bool_c=0;
    end
end
if (dis3>0) & (dis4>0) & ((dis3<down_multi*M_size)| (dis3<down_part*y_length)) & ((dis4>up_multi*M_size) | (dis4>up_part*y_length))% close to y1
    y=boundary_electrode(k,3)-M_size/cutsize;
    bool_c=0;
else
    if (dis3>0) & (dis4>0)& ((dis4<down_multi*M_size)|(dis4<down_part*y_length))  & ((dis3>up_multi*M_size)| (dis3>up_part*y_length)) % close to y2
        y=boundary_electrode(k,4)+M_size/cutsize;
        bool_c=0;
    end
end
%% Check the new position [x,y] is aiviable or not, for the second time
bool_agin=0;
if (bool_c==0) % if the first check is right 
    num_el=size(boundary_electrode,1);
    for j=1:num_el
        if (x>=boundary_electrode(k,1))&(x<=boundary_electrode(k,2)) & (y>=boundary_electrode(k,3))&(y<=boundary_electrode(k,4))
           bool_agin=1; 
        end 
    end
else 
    bool_agin=1; 
end
%% rewrite the position of new point, the new point is out of electrodes
if (bool_c==0) & (bool_agin==0)
    pj_new(1,3)=pos(1,3);
    pj_new(1,1)=x; pj_new(1,2)=y;
    judge_label=0;
else % if it is still in the middle of electrode, not close to boundary in fact
    judge_label=1;
    pj_new=[];
end

