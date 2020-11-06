function [charge_basis,T_num_before,T_total,num_total_electrode,T_array]=load_chargebasis_mat(Path,Filename)
% load a  exisited mesh data and take the information out of it.
fname=strcat(Path,Filename); 
Mdata=load(fname);
Mdata=Mdata.Mdata; 

charge_basis=Mdata.charge_basis;
T_num_before=Mdata.T_num_before;
T_total=Mdata.T_total;
num_total_electrode=Mdata.num_total_electrode;
T_array=Mdata.T_array;

end

