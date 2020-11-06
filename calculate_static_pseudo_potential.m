function [static_potential,static_matrix,pseudo_potential,npot,pseudo2_line,pseudo2_matrix,A_line,A_matrix,Q_line,Q_matrix,pseudo_matrix]  = calculate_static_pseudo_potential(num_total_electrode,points,potential_basis,V,pseudo_C,xr,yr,zr)
%calculate the RF potential field , pseudo potential 
[x,y,z]=meshgrid(linspace(xr(1),xr(2),xr(3)+1),linspace(yr(1),yr(2),yr(3)+1),linspace(zr(1),zr(2),zr(3)+1)); % the matrix of points
nx=size(x,2); ny=size(x,1); nz=size(x,3);
%% calculate the staic potential
static_potential=[]; %  
for j=1:num_total_electrode
    if (j==1)
        static_potential=potential_basis(:,:,1)*V(1);
    else
        static_potential=static_potential+potential_basis(:,:,j)*V(j);
    end
end
static_matrix=reshape(static_potential(1,:),[ny,nx,nz]);
%%%%%%%%%%%%%%%%%%%% calculate the pseudo_potential %%%%%%%%%%%%%%%%%%%
pseudo_potential=[];
np=size(points,1);npot=np;
for j=1:num_total_electrode
    if (j==1)
        pptmp=potential_basis(:,:,1)*V(1);
        for k=1:np
            pseudo_potential(k)=pseudo_C*(pptmp(2,k)^2+pptmp(3,k)^2+pptmp(4,k)^2);
        end
    else
        if (j==2)
            pptmp=potential_basis(:,:,2)*V(2);
            for k=1:np
                pseudo_potential(k)=pseudo_potential(k)+pseudo_C*(pptmp(2,k)^2+pptmp(3,k)^2+pptmp(4,k)^2);
            end
        else
            if (j>2)
                pptmp=potential_basis(:,:,j)*V(j);
                for k=1:np
                    pseudo_potential(k)=pseudo_potential(k)+pptmp(1,k);
                end
            end
        end
    end
end
pseudo_matrix=reshape(pseudo_potential,[ny,nx,nz]);
%% calculate the Q matrix data
pseudo_line=zeros(1,np);
for j=1:2
    pptmp=potential_basis(:,:,j)*V(j);
    if (j==1)
        for k=1:np
            pseudo_line(k)=pptmp(1,k);
        end
    else
        for k=1:np
            pseudo_line(k)=pseudo_line(k)+pptmp(1,k);
        end
    end
end

Q_line=pseudo_line;
Q_matrix=reshape(Q_line,[ny,nx,nz]);

%% calculate A matrix data 
static_line=zeros(1,np);
for j=3:num_total_electrode
    pptmp=potential_basis(:,:,j)*V(j);
    for k=1:np
        static_line(k)=static_line(k)+pptmp(1,k);
    end
end

static2=reshape(static_line,[ny,nx,nz]);
A_matrix=static2;
A_line=static_line;

%% calculate the pseudo potential 
pesudo2=reshape(pseudo_line,[ny,nx,nz]);
unit_y=(yr(2)-yr(1))/(ny-1);
unit_x=(xr(2)-xr(1))/(nx-1);
unit_z=(zr(2)-zr(1))/(nz-1);
[PX,PY,PZ] = gradient(pesudo2,unit_y,unit_x,unit_z);
if (size(pesudo2,1)==ny) & (size(pesudo2,2)==nx)&  (size(pesudo2,3)==nz)
    pseudo2_matrix=zeros(ny,nx,nz);
    for ii=1:ny
        for jj=1:nx
            for kk=1:nz
                pseudo2_matrix(ii,jj,kk)=pseudo_C*(PX(ii,jj,kk)^2+PY(ii,jj,kk)^2+PZ(ii,jj,kk)^2)+static2(ii,jj,kk);
            end
        end
    end
    pseudo2_line=reshape(pseudo2_matrix,[1,np]);
else
    fprintf('Wrong!! with the number of xyz axis of pesudo potential matrix ')
end

end

