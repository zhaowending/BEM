function [slotdc_p1,slotdc_p2,N_slotdc]=design_trapGT_slotDC(slot_L,slot_W,midDC_W,midDC_L,Z_surface,Z_depth)
%The electrodes around slot region will be divide into 4 parts, but the
%meshing triangles will be save in one array togther 
N_slotdc=4; % 

%% the third one 
j=1;
slotdc_p1(j,1)=-(midDC_L/2); slotdc_p1(j,2)=-midDC_W/2; slotdc_p1(j,3)=Z_depth;
slotdc_p2(j,1)=-(slot_L/2); slotdc_p2(j,2)=midDC_W/2; slotdc_p2(j,3)=Z_surface;
%% the fourth 
j=2;
slotdc_p1(j,1)=slot_L/2; slotdc_p1(j,2)=-midDC_W/2; slotdc_p1(j,3)=Z_depth;
slotdc_p2(j,1)=midDC_L/2; slotdc_p2(j,2)=midDC_W/2; slotdc_p2(j,3)=Z_surface;

%% the first DC electrode
j=3;
slotdc_p1(j,1)=-(slot_L/2); slotdc_p1(j,2)=slot_W/2; slotdc_p1(j,3)=Z_depth;
slotdc_p2(j,1)=(slot_L/2); slotdc_p2(j,2)=midDC_W/2; slotdc_p2(j,3)=Z_surface;
%% the second one 
j=4;
slotdc_p1(j,1)=-(slot_L/2); slotdc_p1(j,2)=-midDC_W/2; slotdc_p1(j,3)=Z_depth;
slotdc_p2(j,1)=(slot_L/2); slotdc_p2(j,2)=-slot_W/2; slotdc_p2(j,3)=Z_surface;
end

