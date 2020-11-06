function [DC_p1,DC_p2,en,en11]=design_trapGT_DC(rf_L,num_DC_pair,en,midDC_W,gap_Y,uprf_W,downrf_W,gap_X,DC_X,DC_Y,updc_W,downdc_W,Z_surface,Z_depth,dc_L) 
x=[];z=[];
line1=midDC_W/2+gap_Y+updc_W+gap_Y+uprf_W+gap_Y+DC_Y; 
line2=midDC_W/2+gap_Y+updc_W+gap_Y+uprf_W+gap_Y;
line3=-(midDC_W/2+gap_Y+downdc_W+gap_Y+downrf_W+gap_Y);
line4=-(midDC_W/2+gap_Y+downdc_W+gap_Y+downrf_W+gap_Y+DC_Y);
if mod(num_DC_pair,2)==1  %  odd number of pair
    ban=floor(num_DC_pair/2);  % the number of half of EN 
    bz=0-ban*(DC_X+gap_X)-0.5*DC_X;   % the begin position of z
    while (en<num_DC_pair*2)
        en=en+1;
        if (mod(en,2)==1) %up dc 
            nowpair=floor(en/2);
            x(en,1)=line2; z(en,1)=bz+nowpair*(DC_X+gap_X);
            x(en,2)=line1;  z(en,2)=bz+nowpair*(DC_X+gap_X)+DC_X;
        else  % down dc 
            nowpair=floor(en/2)-1;
            x(en,1)=line4; z(en,1)=bz+nowpair*(DC_X+gap_X);
            x(en,2)=line3;  z(en,2)=bz+nowpair*(DC_X+gap_X)+DC_X; 
        end 
    end 
  else   % even number of pari
    ban=num_DC_pair/2;
    bz=-ban*(DC_X+gap_X)+0.5*gap_X;
    while (en<num_DC_pair*2)
        en=en+1;
        if (mod(en,2)==1) %up dc 
            nowpair=floor(en/2);
            x(en,1)=line2; z(en,1)=bz+nowpair*(DC_X+gap_X);
            x(en,2)=line1;  z(en,2)=bz+nowpair*(DC_X+gap_X)+DC_X;
        else  % down dc 
            nowpair=floor(en/2)-1;
            x(en,1)=line4; z(en,1)=bz+nowpair*(DC_X+gap_X);
            x(en,2)=line3;  z(en,2)=bz+nowpair*(DC_X+gap_X)+DC_X; 
        end 
    end   
end
%% change the order of xyz
x_dc=z;  y_dc=x;
DC_p1=zeros(en,3); DC_p2=zeros(en,3);
DC_p1(:,1)=x_dc(:,1); DC_p1(:,2)=y_dc(:,1);
DC_p2(:,1)=x_dc(:,2); DC_p2(:,2)=y_dc(:,2);
DC_p1(:,3)=Z_depth*ones(en,1);
DC_p2(:,3)=Z_surface*ones(en,1);

%% the two dc in the middle of RFs, one is u, the other one is down 
en11=0; % the number of middle dc  s
% mline1=midDC_W/2+gap_Y+updc_W;
% mline2=midDC_W/2+gap_Y;
% mline3=-(midDC_W/2+gap_Y);
% mline4=-(midDC_W/2+gap_Y+downdc_W);
% 
% en11=en11+1;
% DC_p1(en+en11,1)=-dc_L/2; DC_p1(en+en11,2)=mline2; DC_p1(en+en11,3)=Z_depth; 
% DC_p2(en+en11,1)=dc_L/2; DC_p2(en+en11,2)=mline1; DC_p2(en+en11,3)=Z_surface; 
% 
% 
% en11=en11+1;
% DC_p1(en+en11,1)=-dc_L/2; DC_p1(en+en11,2)=mline4; DC_p1(en+en11,3)=Z_depth; 
% DC_p2(en+en11,1)=dc_L/2; DC_p2(en+en11,2)=mline3; DC_p2(en+en11,3)=Z_surface; 
% 
% %% print the rectangle 
% en=en+en11; 
% for j=1:en
%     x1=DC_p1(j,1); x2=DC_p2(j,1); 
%     y1=DC_p1(j,2); y2=DC_p2(j,2); 
%     fill_x=[x1,x2,x2,x1,x1];
%     fill_y=[y1,y1,y2,y2,y1];
%     fill(fill_x,fill_y,'b');
%     hold on; 
% end 

end