clc,clear;

%%　set
pos1=[0,0,0]; % position on the left,front,bottom (x1,y1,z1)
pos2=[2,0.5,1]; % position on the right,back, up (x2,y2,z2)
mesh_size=0.08; % the size of each mesh unit; zxa
mesh_mode=0; % the normal mesh size unit
plot_switch=0;  %  plot or not 
bbox=[-10,-10;10,10]; % the zone region of the whole trap Bounding box [xmin,ymin; xmax,ymax]
num_surface=5; % 5 surface for a electrode
num_op=3;   % ;
tmp_opdis=[0.1,-0.1,0.2,-0.1,0.2,0]; %　the distance of each optimization  points

%% build the figure plot in the begin 
figure
figure_all_plot=1; % 0 not plot; 1 plot the boundary; 2 plot triangle 


%% set the opzimation points
n_opdis=size(tmp_opdis); % for checking number of optizamtion points
ulength=(abs(pos2(1)-pos1(1)))/(num_op+1);  % the length along x axis of electrodes
num_opand2=num_op+2; num_opand3=num_op+3; num_opall=2*(num_op+2);
op_x=zeros(1,num_opall);op_y=zeros(1,num_opall); %　the X&Y poisition of optimization
if (n_opdis(2)==2*num_op)
    for j=1:num_opall
        switch j
            case 1
                op_x(j)=pos1(1); op_y(j)=pos1(2);
            case num_op+2
                op_x(j)=pos2(1); op_y(j)=pos1(2);
            case num_op+3
                op_x(j)=pos2(1); op_y(j)=pos2(2);
            case 2*(num_op+2)
                op_x(j)=pos1(1); op_y(j)=pos2(2);
            otherwise
                if (j<num_opand2) % (x1 line)
                    op_x(j)=pos1(1)+ulength*(j-1);
                    op_y(j)=tmp_opdis(j-1)+pos1(2);
                else  % (x2 line )
                    op_x(j)=pos2(1)-ulength*(j-num_opand3);
                    op_y(j)=tmp_opdis(j-num_opand3)+pos2(2);
                end
                
        end
    end
else
    fprintf('Wrong in optizmation point setting !!!')
end
pv=[op_x;op_y]; pv=pv'; % pv is the points array of [(x1,y1);(x2,y2);..(xn,yn)] of upper surface of electrode
npv=size(pv);
pv(npv(1)+1,:)=pv(1,:);


%% record the data
tmesh.realp=[];tmesh.t=[]; tmesh.p=[];
tmesh.num=0; tmesh.num_t=[];tmesh.num_p=[];
%% mian program
for is=1:num_surface
    fix_surface=0; % 1 for X, 2 for Y, 3 for Z
    fix_value=0; % the fixed value of X==
    switch is
        case 1 % the upper plane
            fix_surface=3; fix_value=pos2(3); % In fact x-X y-Y
            [p,t]=distmesh2d(plot_switch,@dpoly,@huniform,mesh_size,[min(op_x),min(op_y); max(op_x),max(op_y)],pv,pv);
            if (figure_all_plot==1) %　plot the boundary line for poly
                fill(pv(:,1)',pv(:,2)','r');
                hold on 
            end 
        case 2 %% the front plane
            x1=pos1(1); x2=pos2(1); y1=pos1(3); y2=pos2(3);
            fix_surface=2; fix_value=pos1(2);% in fact. x-X, y-Z
            fd=@(p)drectangle(p,x1,x2,y1,y2); % build mesh zone
            [p,t]=distmesh2d(plot_switch,fd,@huniform,mesh_size,[min(x1,x2),min(y1,y2); max(x1,x2),max(y1,y2)],[x1,y1;x1,y2;x2,y1;x2,y2]);
        case 3 % the right
            x1=pos1(2); x2=pos2(2); y1=pos1(3); y2=pos2(3);
            fix_surface=1; fix_value=pos2(1);% in  fact x-Y��y-Z
            fd=@(p)drectangle(p,x1,x2,y1,y2); % build mesh zone
            [p,t]=distmesh2d(plot_switch,fd,@huniform,mesh_size,[min(x1,x2),min(y1,y2); max(x1,x2),max(y1,y2)],[x1,y1;x1,y2;x2,y1;x2,y2]);
        case 4 % the back plane
            x1=pos1(1); x2=pos2(1); y1=pos1(3); y2=pos2(3);
            fix_surface=2; fix_value=pos2(2);
            fd=@(p)drectangle(p,x1,x2,y1,y2); % build mesh zone
            [p,t]=distmesh2d(plot_switch,fd,@huniform,mesh_size,[min(x1,x2),min(y1,y2); max(x1,x2),max(y1,y2)],[x1,y1;x1,y2;x2,y1;x2,y2]);
        otherwise % the left plane
            x1=pos1(2); x2=pos2(2); y1=pos1(3); y2=pos2(3);
            fix_surface=1; fix_value=pos1(1);
            fd=@(p)drectangle(p,x1,x2,y1,y2); % build mesh zone
            [p,t]=distmesh2d(plot_switch,fd,@huniform,mesh_size,[min(x1,x2),min(y1,y2); max(x1,x2),max(y1,y2)],[x1,y1;x1,y2;x2,y1;x2,y2]);
    end
    nt=size(t);
    for j=1:nt(1) % save 5 planes in tmesh.realp
        for k=1:nt(2)
            switch fix_surface
                case 1
                    tmesh.realp(j+tmesh.num,k,1)=fix_value;
                    tmesh.realp(j+tmesh.num,k,2)=p(t(j,k),1);
                    tmesh.realp(j+tmesh.num,k,3)=p(t(j,k),2);
                case 2
                    tmesh.realp(j+tmesh.num,k,1)=p(t(j,k),1);
                    tmesh.realp(j+tmesh.num,k,3)=p(t(j,k),2);
                    if (is==2)
                        tmesh.realp(j+tmesh.num,k,2)=find_y_sawtooth(mesh_size,p(t(j,k),1),op_x(1:num_opand2),op_y(1:num_opand2));
                    else
                        if (is==4)
                            tmesh.realp(j+tmesh.num,k,2)=find_y_sawtooth(mesh_size,p(t(j,k),1),op_x(num_opand3:num_opall),op_y(num_opand3:num_opall));
                        end
                    end
                case 3
                    tmesh.realp(j+tmesh.num,k,3)=fix_value;
                    tmesh.realp(j+tmesh.num,k,1)=p(t(j,k),1);
                    tmesh.realp(j+tmesh.num,k,2)=p(t(j,k),2);
                otherwise
                    fprintf('Wrong with the positions of electrode  !!!!!')
            end
        end
    end
    
    if (is==1)&(figure_all_plot==2)% plot the triangle figure 
            for j=1:nt(1)
                plot_tt=tmesh.realp(j,:,:);
                t_x=[plot_tt(1,1,1),plot_tt(1,2,1),plot_tt(1,3,1),plot_tt(1,1,1)];
                t_y=[plot_tt(1,1,2),plot_tt(1,2,2),plot_tt(1,3,2),plot_tt(1,1,2)];
                fill(t_x,t_y,'r');
                hold on 
            end 
    end 
        
    tmesh.num=tmesh.num+nt(1);
    if (is==1)
        tmesh.t=t;        
    else
        tmesh.t=[tmesh.t;t];
    end
    if (is==1)
        tmesh.p=p;
    else
        tmesh.p=[tmesh.p;p];
    end
    tmesh.num_t(is)=nt(1);
    np=size(p);
    tmesh.num_p(is)=np(1);
    
end


