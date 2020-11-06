% help distmeshsurface
% distmeshsurface 3-D Surface Mesh Generator using Distance Functions.
%    [P,T]=distmeshsurface(FD,FH,H0,BBOX,FPARAMS)
%   NOTE:
%       P:         Node positions (Nx2)
%       T:         Triangle indices (NTx3)
%      FD:         Distance function d(x,y)
%       FH:        Scaled edge length function h(x,y)
%       H0:        Initial edge length
%       BBOX:      Bounding box [xmin,ymin; xmax,ymax]
%       FPARAMS:   Additional parameters passed to FD and FH
%  %%  Example: (Uniform Mesh on Unit Sphere)
%        fd=@(p) dsphere(p,0,0,0,1);
%        [p,t]=distmeshsurface(fd,@huniform,0.2,1.1*[-1,-1,-1;1,1,1]);
%  
%  %%  Example: (Graded Mesh on Unit Sphere)
%        fd=@(p) dsphere(p,0,0,0,1);
%        fh=@(p) 0.05+0.5*dsphere(p,0,0,1,0);
%        [p,t]=distmeshsurface(fd,fh,0.15,1.1*[-1,-1,-1;1,1,1]);
%  
%  %% Example: (Uniform Mesh on Torus)
%        fd=@(p) (sum(p.^2,2)+.8^2-.2^2).^2-4*.8^2*(p(:,1).^2+p(:,2).^2);
%        [p,t]=distmeshsurface(fd,@huniform,0.1,[-1.1,-1.1,-.25;1.1,1.1,.25]);
%  
% %% Example: (Uniform Mesh on Ellipsoid)
%        fd=@(p) p(:,1).^2/4+p(:,2).^2/1+p(:,3).^2/1.5^2-1;
%        [p,t]=distmeshsurface(fd,@huniform,0.2,[-2.1,-1.1,-1.6; 2.1,1.1,1.6]);

%% Example for a cube
fd=@(p)dpoly;
pv=[0,0,0;]
[p,t]=distmeshsurface(fd,@huniform,0.2,1.1*[0,0,0;1,1,2],pv);
nt=size(t);
triangle_realp=zeros(nt(1),nt(2),3);
for j=1:nt(1)
    for k=1:nt(2)
        tmp_node=t(j,k);
        triangle_realp(j,k,:)=p(tmp_node,:);
    end 
end 
