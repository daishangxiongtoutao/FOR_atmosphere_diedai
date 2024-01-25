function [  Y ] = SimulateTemperature( x1, x2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

a = 921.760477841773;
b = 60026588.0759165;
c = -817.833302530141;
d = -1820227264111.25;
e = 254.38378078007;
f = -36102814.3432035;
g = -1.21527565837046E+18;
h = -20.2849860328111;
i = 2255411.27685923;
j = 3299039260118.92;

Y = a+b.*x1+c.*x2+d.*x1.^2+e.*x2.^2+f.*x1.*x2+g.*x1.^3+h.*x2.^3+i.*x1.*x2.^2+j.*x1.^2.*x2;		


end