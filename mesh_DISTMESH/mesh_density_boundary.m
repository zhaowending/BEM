function d = mesh_density_boundary(p,x1,x2,y1,y2,size)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
length=abs(x2-x1);
width=abs(y2-y2);
d1=abs(p(:,1)-x1);
d2=abs(p(:,1)-x2);
d3=abs(p(:,2)-y1);
d4=abs(p(:,2)-y2);
ll=min((width/15),(length/15));
if ((d1<(length/15))|(d2<(length/15)))&(d3>(width/15))&( d4>(width/15))
    dis=min(d1,d2);
    d=(size/3)*(((length/15)-dis+(ll))/(length/15));
else
    if (d1>(length/15))&(d2>(length/15))&((d3<(width/15))|( d4<(width/15)))
        dis=min(d3,d4);
        d=(size/3)*(((width/15)-dis+(ll))/(width/15));
    else
        if ((d3<(width/15))|( d4<(width/15)))& ((d1<(length/15))|(d2<(length/15)))
            dis=min(min(min(d1,d2),d3),d4);          
            d=(size/3)*((2*ll-dis)/ll);
        else 
            d=0;
        end 
    end
    
end

