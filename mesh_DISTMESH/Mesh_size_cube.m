function x=Mesh_size_cube(x1,x2,y1,y2)
%calculate the mesh_size in the end 
dx=abs(x1-x2);
dy=abs(y1-y2);
mind=min(dx,dy); maxd=max(dx,dy);
x=0; 
if (mind*22<maxd)
    x=mind*0.8;
else 
if (10*mind<maxd) & (20*mind>maxd)
    x=mind/2.0;
else 
    if (5*mind<maxd)
        x=mind/4;
    else
        if (3*mind<maxd)
            x=mind/8;
        else
            x=mind/14;
        end 
    end 
end 
end 
end

