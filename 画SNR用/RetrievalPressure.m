function [ pressure ] = RetrievalPressure( x1, x2 )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
a = 1.33262471754984;
b = 247446.203513542;
c = -1.16621124554099;
d = 12287872044.4308;
e = 0.338851136764152;
f = -220384.810110151;
g = 1.06083628602241e16;
h = -3.26751933811818e-2;
i = 97583.483792004;
j = -23933996741.8353;


pressure = a+b.*x1+c.*x2+d.*x1.^2+e.*x2.^2+f.*x1.*x2+g.*x1.^3+h.*x2.^3+i.*x1.*x2.^2+j.*x1.^2.*x2;


end