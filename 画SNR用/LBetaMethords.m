function [ T, P ] = LBetaMethords( x1, x2 )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

[ P ] = SimulatePressure( x1, x2 );
[ T ] = SimulateTemperature( x1, x2 );

end