function y0 =find_y_sawtooth(mesh_size,x0,x,y)
%find the y index of point in the front or backside surface of loading electrode
ntmp=size(x); nx=ntmp(2); % number of point in the sawtooth line 
ntmp=size(y); ny=ntmp(2); 
cutoff=mesh_size*10^(-3); % the cutoff of mesh position, == is <cutoff
fool=1;
if (nx==ny)
    for j=1:nx-1
        if (abs(x(j)-x0)<cutoff)
            y0=y(j);            fool=0;
            break
        else 
            if ((x(j)<x0)&(x(j+1)>x0))|((x(j)>x0)&(x(j+1)<x0))
                k=(y(j+1)-y(j))/(x(j+1)-x(j));
                b=(y(j)*x(j+1)-y(j+1)*x(j))/(x(j+1)-x(j));
                y0=k*x0+b; fool=0;
                break
            end 
        end 
    end 
    if (fool==1)
         if (abs(x(nx)-x0)<cutoff)
             y0=y(nx);
         else 
             fprintf('Wrong in finding point at sawtooth line !!!');
             fprintf('abs(x(nx)-x0');
             abs(x(nx)-x0)
             return 
         end 
    end 
else 
    fprintf('Wrong in the sawtooth line !!!') 
end 
end

