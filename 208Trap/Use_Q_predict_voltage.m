%% physics constant 
pf=10^(-12);
mhz=10^6; 
%% define the value (excatly right)
f0=34.7385*mhz;
omega0=f0*(2*pi);
Q=100; 

%% define the value of components (predict) (dp=define by prediction )
C_dp=13*pf; 

%% calculte the value of components by equation (predict) (cp=predict by calculation)
L_cp=1/(omega0^2 * C_dp); 
fprintf('The prediction value of L is %f (uH)\n', L_cp/(10^(-6))); 
R_cp=(1/Q)*sqrt(L_cp/C_dp); 
fprintf('The prediction value of R is %f (Ome)\n', R_cp); 
kappa_cp=(L_cp/C_dp)^(1/4); 
fprintf('The prediction value of kappar is %f\n',kappa_cp); 

%% record the experiment data 
Data_Ex=[ % Control DC , power input , V_pp, V_Reflect 
2.0, 0.011, 0.52, 0.18; 
2.5, 0.029, 0.84, 0.268;
3.0, 0.052, 1.12, 0.39;
3.5, 0.077, 1.42, 0.43;
4.0, 0.106, 1.58, 0.49;
4.5, 0.136, 1.88, 0.57;
5.0, 0.168, 2.00, 0.60; 
5.5, 0.203, 2.2,  0.64;
6.0, 0.241, 2.36, 0.72; 
6.5, 0.281, 2.58, 0.768; 
7.0, 0.328, 2.78, 0.828; 
7.5, 0.378, 3.00, 0.89; 
8.0, 0.436, 3.24, 0.94; 
8.5, 0.501, 3.36, 1.0; 
9.0, 0.575, 3.62, 1.06; 
9.5, 0.656, 3.74, 1.12;
10,  0.748, 3.94, 1.16;
10.5,0.844, 4.18, 1.22;
11,  0.91,  4.32, 1.29; 
];
n=size(Data_Ex,1);
%% 
V_predict=zeros(n,1); 
for j=1:n
    V_predict(j)=kappa_cp*sqrt(2*Data_Ex(j,2)*Q); 
    % V_{peak}=k*sqrt(2PQ)
end 
Data_Ex(:,5)=V_predict; 
% Control DC , power input , V_pp, V_Reflect , V_predict_real, 
%% plot 
figure 
plot(sqrt(Data_Ex(:,2)),Data_Ex(:,3));
xlabel('Sqrt(Q)'); ylabel('V_pp'); 
title('See the relation of V_{pp} and sqrt(P_{input} is linear or not '); 

