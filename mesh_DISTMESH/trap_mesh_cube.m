function [p_one_electrode,num_one_electrode] = trap_mesh_cube(pos1,pos2,mesh_size,bbox,plot_switch,figure_all_plot)
%mesh a cube 
% pos1=[0,0,0]; % position on the left,front,bottom (x1,y1,z1)
% pos2=[2,3,1]; % position on the right,back, up (x2,y2,z2)
num_surface=5;
tmesh.realp=[];tmesh.t=[]; tmesh.p=[];
tmesh.num=0; tmesh.num_t=[];tmesh.num_p=[];
% mesh_size=0.15; % the size of each mesh unit; zxa
for is=1:num_surface
    fix_surface=0; % 1 for X, 2 for Y, 3 for Z
    fix_value=0; % the fixed value of X==
    switch is
        case 1 % the upper plane 
            x1=pos1(1); x2=pos2(1); y1=pos1(2); y2=pos2(2); % build xy in plane 
            fix_surface=3; fix_value=pos2(3); % In fact x-X y-Y
        case 2 %% the front plane 
            x1=pos1(1); x2=pos2(1); y1=pos1(3); y2=pos2(3); 
            fix_surface=2; fix_value=pos1(2);% in fact. x-X, y-Z
        case 3 % the right
            x1=pos1(2); x2=pos2(2); y1=pos1(3); y2=pos2(3); 
            fix_surface=1; fix_value=pos2(1);% in  fact x-Y£¬y-Z
        case 4 % the back plane
            x1=pos1(1); x2=pos2(1); y1=pos1(3); y2=pos2(3);
            fix_surface=2; fix_value=pos2(2);
        otherwise % the left plane 
            x1=pos1(2); x2=pos2(2); y1=pos1(3); y2=pos2(3);
            fix_surface=1; fix_value=pos1(1);
    end
    fd=@(p)drectangle(p,x1,x2,y1,y2); % build mesh zone 
    mesh_size=Mesh_size_cube(x1,x2,y1,y2); 
    % fh=@(p) 0.05+mesh_density_boundary(p,x1,x2,y1,y2);
    [p,t]=distmesh2d(plot_switch,fd,@huniform,mesh_size,[min(x1,x2),min(y1,y2); max(x1,x2),max(y1,y2)],[x1,y1;x1,y2;x2,y1;x2,y2]);
    nt=size(t);
    for j=1:nt(1) % save 5 planes in tmesh.realp
        for k=1:nt(2)
            switch fix_surface
                case 1
                     tmesh.realp(k,1,j+tmesh.num)=fix_value; 
                     tmesh.realp(k,2,j+tmesh.num)=p(t(j,k),1);
                     tmesh.realp(k,3,j+tmesh.num)=p(t(j,k),2);
                case 2
                    tmesh.realp(k,2,j+tmesh.num)=fix_value; 
                     tmesh.realp(k,1,j+tmesh.num)=p(t(j,k),1);
                     tmesh.realp(k,3,j+tmesh.num)=p(t(j,k),2);
                case 3
                     tmesh.realp(k,3,j+tmesh.num)=fix_value; 
                     tmesh.realp(k,1,j+tmesh.num)=p(t(j,k),1);
                     tmesh.realp(k,2,j+tmesh.num)=p(t(j,k),2);
                otherwise 
                    fprintf('Wrong with the posistion of electrodes !!!!!')
            end 
        end
    end
        
    if (is==1)
        if (figure_all_plot==2)% plot the triangle figure 
            for j=1:nt(1)
                plot_tt=tmesh.realp(:,:,j);
                t_x=[plot_tt(1,1),plot_tt(2,1),plot_tt(3,1),plot_tt(1,1)];
                t_y=[plot_tt(1,2),plot_tt(2,2),plot_tt(3,2),plot_tt(1,2)];
                fill(t_x,t_y,'b');
                hold on 
            end
        else 
            if (figure_all_plot==1)
                t_x=[x1,x1,x2,x2,x1];
                t_y=[y1,y2,y2,y1,y1];
                fill(t_x,t_y,'b');
                hold on 
            end 
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
p_one_electrode=tmesh.realp;
num_one_electrode=tmesh.num;
end

