function [T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2]=load_mesh_json(Path,Filename)
% load a  exisited mesh data and take the information out of it.
fname=strcat(Path,Filename); 
Mdata=loadjson(fname);
node_array=Mdata.node_array; 
T_num_electrode=Mdata.T_num_electrode;
T_total=Mdata.T_total; 
T_pos1=Mdata.T_pos1;
T_pos2=Mdata.T_pos2; 
T_array=[];
for j=1:3
    T_array(j,:,:)=cell2mat(Mdata.T_array(j));
end 

end

