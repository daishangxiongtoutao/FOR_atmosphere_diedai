function [ T, P] = OADSMethord( x1, x2 )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% Retrieval Temperature
% x1 : Linewidth

T = 22.0813.*x1.^2;  

lambda = 532;
M = 28.959;    %大气分子量
R = 8.314;     %普适气体常数
A0 = 6.023e23; %阿伏伽德罗常数
density0 = 1.225e3; %海平面处的大气密度,g/mol
density1 = (x2.*(lambda*1e-9)^4*A0*density0^2)./(8.597e-8*(4*pi^2*M));
P0 = density1.*R.*T/M; %拟合温度对应的压强

P = P0./1e5;


end