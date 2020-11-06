function [DC_x,DC_y,en]=design_trap302_DCsegment(slot_W,rf_L,num_DC_pair,use_pair,gap_Y,uprf_W,downrf_W,gap_X,DC_X,DC_Y,updc_W,downdc_W,Z_surface,Z_depth,dc_L,right_points,left_points,out_length) 
% define the X\Y position of each DC segement electrodes  

en=0;  % en is the number of DC segemnt after rf, en11 is the nufid=fopen([Path,Filename],'w');
% give 6 lines on y axis 
line1= -(slot_W/2+downdc_W+downrf_W+2*gap_Y + DC_Y + out_length  );
line2= -(slot_W/2+downdc_W+downrf_W+2*gap_Y + DC_Y);
line3= -(slot_W/2+downdc_W+downrf_W+2*gap_Y);
line4= (slot_W/2 +updc_W+uprf_W+2*gap_Y);
line5= (slot_W/2 +updc_W+uprf_W+2*gap_Y+ DC_Y ) ;
line6= (slot_W/2 +updc_W+uprf_W+2*gap_Y+ DC_Y + out_length) ;

%% calculate the X position of DC segement electrode 
z=[];
if mod(num_DC_pair,2)==1  %  odd number of pair
    ban=floor(num_DC_pair/2);  % the number of half of EN 
    bz=0-ban*(DC_X+gap_X)-0.5*DC_X;   % the begin position of z
    while (en<num_DC_pair*2)
        en=en+1;
        if (mod(en,2)==1) %up dc 
            nowpair=floor(en/2);
            z(en,1)=bz+nowpair*(DC_X+gap_X);
            z(en,2)=bz+nowpair*(DC_X+gap_X)+DC_X;
        else  % down dc 
            nowpair=floor(en/2)-1;
            z(en,1)=bz+nowpair*(DC_X+gap_X);
            z(en,2)=bz+nowpair*(DC_X+gap_X)+DC_X; 
        end 
    end 
  else   % even number of pari
    ban=num_DC_pair/2;
    bz=-ban*(DC_X+gap_X)+0.5*gap_X;
    while (en<num_DC_pair*2)
        en=en+1;
        if (mod(en,2)==1) %up dc 
            nowpair=floor(en/2);
            z(en,1)=bz+nowpair*(DC_X+gap_X);
            z(en,2)=bz+nowpair*(DC_X+gap_X)+DC_X;
        else  % down dc 
            nowpair=floor(en/2)-1;
            z(en,1)=bz+nowpair*(DC_X+gap_X);
            z(en,2)=bz+nowpair*(DC_X+gap_X)+DC_X; 
        end 
    end   
end
en_all=en; % en_all is the number of all DC segements built (maybe some no use)
%%  build position matrix of each DC segement electrode
DC_xpos=zeros(en_all,6); DC_ypos=zeros(en_all,6); 
for j=1:en_all
    nu_pair=floor((j+1)/2); 
    if (mod(j,2)==1) % in down half zone 
        DC_xpos(j,1)=z(j,1); DC_ypos(j,1)=line3; 
        DC_xpos(j,2)=z(j,2); DC_ypos(j,2)=line3; 
        DC_xpos(j,3)=z(j,2); DC_ypos(j,3)=line2;  
        DC_xpos(j,4)=right_points(nu_pair); DC_ypos(j,4)=line1;   
        DC_xpos(j,5)=left_points(nu_pair);  DC_ypos(j,5)=line1; 
        DC_xpos(j,6)=z(j,1); DC_ypos(j,6)=line2; 
    else % DC electrodes in up half zone 
        DC_xpos(j,1)=z(j,1); DC_ypos(j,1)=line4; 
        DC_xpos(j,2)=z(j,2); DC_ypos(j,2)=line4; 
        DC_xpos(j,3)=z(j,2); DC_ypos(j,3)=line5;  
        DC_xpos(j,4)=right_points(nu_pair); DC_ypos(j,4)=line6;   
        DC_xpos(j,5)=left_points(nu_pair);  DC_ypos(j,5)=line6; 
        DC_xpos(j,6)=z(j,1); DC_ypos(j,6)=line5; 
    end  
end

%% save useful DC segement electrodes 
N_pair_use=size(use_pair,2); 
en=2*N_pair_use; 
DC_x=zeros(en,6); DC_y=zeros(en,6); 
for j=1:N_pair_use
    now_pair= use_pair(j); 
    now_en= 1+(now_pair-1)*2;     now_j=(j-1)*2+1;
    DC_x(now_j,:)= DC_xpos(now_en,:); DC_y(now_j,:)= DC_ypos(now_en,:);
    now_en= now_pair*2;  now_j=j*2; 
    DC_x(now_j,:)= DC_xpos(now_en,:); DC_y(now_j,:)= DC_ypos(now_en,:);
end 

%% downdc 
en=en+1; en_all=en_all+1; 
DC_x(en,1)=-(rf_L/2); DC_y(en,1)=-(slot_W/2 + downdc_W);  
DC_x(en,2)=0;         DC_y(en,2)=-(slot_W/2 + downdc_W);  
DC_x(en,3)=(rf_L/2);  DC_y(en,3)=-(slot_W/2 + downdc_W);  
DC_x(en,4)=(rf_L/2);  DC_y(en,4)=-(slot_W/2);  
DC_x(en,5)=0;         DC_y(en,5)=-(slot_W/2);  
DC_x(en,6)=-(rf_L/2); DC_y(en,6)=-(slot_W/2);  
DC_xpos(en_all,:)= DC_x(en,:);  DC_ypos(en_all,:)= DC_y(en,:); 


%% updc 
en=en+1; en_all=en_all+1; 
DC_x(en,1)=-(rf_L/2); DC_y(en,1)=(slot_W/2);  
DC_x(en,2)=0;         DC_y(en,2)=(slot_W/2);  
DC_x(en,3)=(rf_L/2);  DC_y(en,3)=(slot_W/2);  
DC_x(en,4)=(rf_L/2);  DC_y(en,4)=(slot_W/2+updc_W);  
DC_x(en,5)=0;         DC_y(en,5)=(slot_W/2+updc_W);  
DC_x(en,6)=-(rf_L/2); DC_y(en,6)=(slot_W/2+updc_W);  
DC_xpos(en_all,:)= DC_x(en,:);  DC_ypos(en_all,:)= DC_y(en,:); 

% % plot figure check 
% figure
% for j=1:en_all
%     fill_x=DC_xpos(j,:);
%     fill_y=DC_ypos(j,:);
%     fill(fill_x,fill_y,'b');
%     hold on; 
% end 
% figure
% for j=1:en
%     fill_x=DC_x(j,:);
%     fill_y=DC_y(j,:);
%     fill(fill_x,fill_y,'b');
%     hold on; 
% end 


end