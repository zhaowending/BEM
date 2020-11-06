function x=Normal_mesh_size(pos1,pos2,divide)
% This code give a mesh size in common
pp=min(abs(pos1(1)-pos2(1)),abs(pos1(2)-pos2(2)));
    if (pp<0.2*abs(pos1(2)-pos2(2)) )|(pp< 0.2*abs(pos1(1)-pos2(1)) )
        pp=3*pp;
    end
    x=pp/divide;
end

