function Mdata=save_mesh_json(Path,Filename,T_array,node_array,T_num_electrode,T_total,T_pos1,T_pos2)
%After mesh a new  surface trap you have to store the array of mesh as the
% josn-form 
% The data stored in the filename ,in the path given 
Mdata.T_array=T_array;
Mdata.node_array=node_array; 
Mdata.T_num_electrode=T_num_electrode;
Mdata.T_total=T_total;
Mdata.T_pos1=T_pos1;
Mdata.T_pos2=T_pos2; 
json_data=jsonencode(Mdata); 
fid=fopen([Path,Filename],'w');
fprintf(fid,json_data);
fclose(fid);
end

