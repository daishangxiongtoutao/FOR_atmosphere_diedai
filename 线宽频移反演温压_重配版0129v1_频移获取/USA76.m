function [ T, P ] = USA76( z )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%z几何高度，单位：km

P_SL=101325;%海平面气压，单位：Pa（ N/m2）
Re=6356.766;%地球半径，单位：km

len = length(z);

H = [];
W = [];
T = [];
P = [];

for i = 1:len
    if z(i) <= 11.0191
        H1 = z(i)/(1+z(i)/Re);
        H = [H;H1];
        W1 = 1-H1/44.3308;
        W = [W;W1];
        T1 = 288.15*W1;
        T = [T;T1];
        P1 = P_SL*W1^5.2559;
        P = [P;P1];
    end

    if 11.0191 < z(i) && z(i) <= 20.0631
        H2 = z(i)/(1+z(i)/Re);
        H = [H;H2];
        W2 = exp((14.9647-H2)/6.3416);
        W = [W;W2];
        T2 = 216.650;
        T = [T;T2];
        P2 = P_SL*0.11953*W2;
        P = [P;P2];
    end

    if 20.0631 <z(i) && z(i) <= 32.1619
        H3 = z(i)/(1+z(i)/Re);
        H = [H;H3];
        W3 = 1+(H3-24.9021)/221.552;
        W = [W;W3];
        T3 = 221.552*W3;
        T = [T;T3];
        P3 = P_SL*0.025158*W3^-34.162;
        P = [P;P3];
    end

    if 32.1619<z(i) && z(i)<=47.3501
        H4 = z(i)/(1+z(i)/Re);
        H = [H;H4];
        W4 = 1+(H4-39.7499)/89.4107;
        W = [W;W4];
        T4 = 250.350*W4;
        T = [T;T4];
        P4 = P_SL*2.8338e-3*W4^-12.2011;
        P = [P;P4];
    end

    if 47.3501<z(i) && z(i)<=51.4125
        H5 = z(i)/(1+z(i)/Re);
        H = [H;H5];
        W5 = exp((48.6252-H5)/7.9223);
        W = [W;W5];
        T5 = 270.650;
        T = [T;T5];
        P5 = P_SL*8.9155e-4*W5;
        P = [P;P5];
    end
end
P = P ./ 1e5;
end