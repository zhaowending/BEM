function [potential_basis,points,P_num_total,xr,yr,zr,num_total_electrode]=load_potentialbasis_mat(Path,Filename)
% load a  exisited mesh data and take the information out of it.
fname=strcat(Path,Filename); 
M=load(fname);
Mdata=M.Mdata;

P_num_total=Mdata.P_num_total;
num_total_electrode=Mdata.num_total_electrode;
xr=Mdata.xr; yr=Mdata.yr; zr=Mdata.zr; 
points=Mdata.points;
potential_basis=Mdata.potential_basis;


end
