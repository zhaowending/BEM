function [charge_basis,T_num_before,T_total,num_total_electrode,T_array]=load_chargebasis_json(Path,Filename)
% load a  exisited mesh data and take the information out of it.
fname=strcat(Path,Filename); 
Mdata=loadjson(fname);

charge_basis=Mdata.charge_basis;
T_num_before=Mdata.T_num_before;
T_total=Mdata.T_total;
num_total_electrode=Mdata.num_total_electrode;
T_array=[];
for j=1:3
    T_array(j,:,:)=cell2mat(Mdata.T_array(j));
end 

end

