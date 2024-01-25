function [ beta_f ] = GenerateBetaM( Tem, Pre )
%UNTITLED2 Summary of this function goes here

for ii=1:1:length(Tem)
    
T=Tem(ii);
p=Pre(ii);
Sm = 8*pi/3;        % 大气分子消光后向散射比
delt_z = 30;        % 距离分辨率，m  (150m)
lambda = 532;       % 发射激光波长，nm
M = 28.959; %大气分子量
R = 8.314; %普适气体常数
P=p.*1e5;
for i=1:length(P)
    for j=1:length(T)
        density(i,j) = (P(i)*296)./(1.013e5*T(j))*2.479e25; %密度  
    end
end
beta_test_zhao=(0.55e-6)^4*5.45e-32/((532e-9)^4);
beta_m=beta_test_zhao*density;
%%
beta_1=beta_m(:);
beta_f(ii,1) =  beta_1;
end




end