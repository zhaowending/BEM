function judge_label=judge_triangle_inside(M_size,list,boundary_electrode,cutdid )
%judge the triangle is in the electrodes or not
judge_label=0;
nt=size(boundary_electrode,1);
nl=size(list,1);
cutdid=cutdid*5; 
for j=1:nt
    for k=1:nl
        if (judge_label==0)
            if (list(k,1)>=boundary_electrode(j,1)-(M_size/cutdid))&(list(k,1)<=boundary_electrode(j,2)+(M_size/cutdid)) & (list(k,2)>=boundary_electrode(j,3)-(M_size/cutdid))&(list(k,2)<=boundary_electrode(j,4)+(M_size/cutdid))
                judge_label=1;
                break
            end
        end
    end
end

end

