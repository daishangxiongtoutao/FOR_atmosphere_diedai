function [ Temperature ] = RetrievalTemperature( x1, x2 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

c1 = 921.760477841773;
c2 = 60026588.0759165;
c3 = -817.8333022530141;
c4 = -1820227264111.25;
c5 = 254.38378078007;
c6 = -36102814.3432035;
c7 = -1.21527565837046e-18;
c8 = -20.2849860328111;
c9 = 2255411.27685923;
c10 = 3299039260118.92;

Temperature = c1+c2.*x1+c3.*x2+c4.*x1.^2+c5.*x2.^2+c6.*x1.*x2+c7.*x1.^3+c8.*x2.^3+c9.*x1.*x2.^2+c10.*x1.^2.*x2;

end