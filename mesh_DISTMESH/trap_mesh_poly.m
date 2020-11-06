function [p,num] = trap_mesh_poly(pos1,pos2,op_x,op_y,mesh_mode,mesh_size,bbox,num_op,num_opand2,num_opand3,num_opall,plot_switch,figure_all_plot)
% This code is to mesh the poly electrode, rf in loading zone 
% here the fix index is 1,2,3 for x,y,z, means the plane is
% x==x0,y==y0,z==z0
%% the inital value for test 
% figure_all_plot=1; % 0 not plot; 1 plot the boundary; 2 plot triangle 
%pos1=[0,0,0]; % position on the left,front,bottom (x1,y1,z1)
% pos2=[2,0.5,1]; % position on the right,back, up (x2,y2,z2)
%% the poly's shape, should know the op_x and op_y at first 
pv=[op_x;op_y]; pv=pv'; % pv is the points array of [(x1,y1);(x2,y2);..(xn,yn)] of upper surface of electrode
npv=size(pv);
pv(npv(1)+1,:)=pv(1,:);
%% record the data
num_surface=5;
tmesh.realp=[];tmesh.t=[]; tmesh.p=[];
tmesh.num=0; tmesh.num_t=[];tmesh.num_p=[];
%% main 
for is=1:num_surface
    fix_surface=0; % 1 for X, 2 for Y, 3 for Z
    fix_value=0; % the fixed value of X==
    switch is
        case 1 % the upper plane
            fix_surface=3; fix_value=pos2(3); % In fact x-X y-Y
            [p,t]=distmesh2d(plot_switch,@dpoly,@huniform,mesh_size,[min(op_x),min(op_y); max(op_x),max(op_y)],pv,pv);
            if (figure_all_plot==1) %¡¡plot the boundary line for poly
                fill(pv(:,1)',pv(:,2)','r');
                hold on 
            end 
        case 2 %% the front plane
            x1=pos1(1); x2=pos2(1); y1=pos1(3); y2=pos2(3);
            fix_surface=2; fix_value=pos1(2);% in fact. x-X, y-Z
            fd=@(p)drectangle(p,x1,x2,y1,y2); % build mesh zone
            mesh_size=Mesh_size_cube(x1,x2,y1,y2); 
            [p,t]=distmesh2d(plot_switch,fd,@huniform,mesh_size,[min(x1,x2),min(y1,y2); max(x1,x2),max(y1,y2)],[x1,y1;x1,y2;x2,y1;x2,y2]);
        case 3 % the right
            x1=pos1(2); x2=pos2(2); y1=pos1(3); y2=pos2(3);
            fix_surface=1; fix_value=pos2(1);% in  fact x-Y£¬y-Z
            fd=@(p)drectangle(p,x1,x2,y1,y2); % build mesh zone
            mesh_size=Mesh_size_cube(x1,x2,y1,y2); 
            [p,t]=distmesh2d(plot_switch,fd,@huniform,mesh_size,[min(x1,x2),min(y1,y2); max(x1,x2),max(y1,y2)],[x1,y1;x1,y2;x2,y1;x2,y2]);
        case 4 % the back plane
            x1=pos1(1); x2=pos2(1); y1=pos1(3); y2=pos2(3);
            fix_surface=2; fix_value=pos2(2);
            fd=@(p)drectangle(p,x1,x2,y1,y2); % build mesh zone
            mesh_size=Mesh_size_cube(x1,x2,y1,y2); 
            [p,t]=distmesh2d(plot_switch,fd,@huniform,mesh_size,[min(x1,x2),min(y1,y2); max(x1,x2),max(y1,y2)],[x1,y1;x1,y2;x2,y1;x2,y2]);
        otherwise % the left plane
            x1=pos1(2); x2=pos2(2); y1=pos1(3); y2=pos2(3);
            fix_surface=1; fix_value=pos1(1);
            fd=@(p)drectangle(p,x1,x2,y1,y2); % build mesh zone
            mesh_size=Mesh_size_cube(x1,x2,y1,y2); 
            [p,t]=distmesh2d(plot_switch,fd,@huniform,mesh_size,[min(x1,x2),min(y1,y2); max(x1,x2),max(y1,y2)],[x1,y1;x1,y2;x2,y1;x2,y2]);
    end
    nt=size(t);
    for j=1:nt(1) % save 5 planes in tmesh.realp
        for k=1:nt(2)
            switch fix_surface
                case 1
                    tmesh.realp(k,1,j+tmesh.num)=fix_value;
                    tmesh.realp(k,2,j+tmesh.num)=p(t(j,k),1);
                    tmesh.realp(k,3,j+tmesh.num)=p(t(j,k),2);
                case 2
                    tmesh.realp(k,1,j+tmesh.num)=p(t(j,k),1);
                    tmesh.realp(k,3,j+tmesh.num)=p(t(j,k),2);
                    if (is==2)
                        tmesh.realp(k,2,j+tmesh.num)=find_y_sawtooth(mesh_size,p(t(j,k),1),op_x(1:num_opand2),op_y(1:num_opand2));
                    else
                        if (is==4)
                            tmesh.realp(k,2,j+tmesh.num)=find_y_sawtooth(mesh_size,p(t(j,k),1),op_x(num_opand3:num_opall),op_y(num_opand3:num_opall));
                        end
                    end
                case 3
                    tmesh.realp(k,3,j+tmesh.num)=fix_value;
                    tmesh.realp(k,1,j+tmesh.num)=p(t(j,k),1);
                    tmesh.realp(k,2,j+tmesh.num)=p(t(j,k),2);
                otherwise
                    fprintf('Wrong with the positions of electrode  !!!!!')
            end
        end
    end
    
    if (is==1)&(figure_all_plot==2)% plot the triangle figure 
            for j=1:nt(1)
                plot_tt=tmesh.realp(:,:,j);
                t_x=[plot_tt(1,1),plot_tt(2,1),plot_tt(3,1),plot_tt(1,1)];
                t_y=[plot_tt(1,2),plot_tt(2,2),plot_tt(3,2),plot_tt(1,2)];
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
%% recorde the mesh and return to p and num 
p=tmesh.realp;
num=tmesh.num;
end

