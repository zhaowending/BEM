function [fillx,filly] = draw_electrode(x1,z1,c,w)
fillx=[x1,x1,x1+c,x1+c];
filly=[z1,z1+w,z1+w,z1];
end

