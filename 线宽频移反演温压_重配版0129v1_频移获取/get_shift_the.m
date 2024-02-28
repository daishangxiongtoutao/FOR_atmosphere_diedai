clc;clear;
%%
kk=1;
%%
for hh=4.8:0.03:9.3
    tp=get_t_p(hh)
    T=tp(1,1);
    P=tp(1,2);

    kb                  = 1.38e-23;                              % Boltzmann constant, in J/K
    tem                 = T;                                     % temperature, in K
    p_bar               = P;
    p_pa                = p_bar*1e5;                             % pressure, in Pa
    V0                  = 22.4;                                  % Volume of gas per mole , in L/mol
    lambda              = 532e-9;                                % The wavelength of the laser, in m
    scattering_angle    = 180;                                   % scattering angle
    angle               = scattering_angle*(pi/180);             % scattering angle in radians
    M                   = 28.970;                                % Relative molecular weight, dimensionless unit
    heat_capacity_ratio = 1.4;                                   % heat capacity ratio
    R                   = 8.314472;                              % molar gas constant,J/(mol·K)
    n                   = 1;                                     % 
    Gruneisen           = 0.066;                                 % Translational heat capacity, J/(mol·K)
    m_m                 = M*1.66e-27;                            % molecular weight,in kg
%% 
    bri_shift(kk)          = 2*n/lambda*sqrt(heat_capacity_ratio*kb*tem/m_m)*exp(-Gruneisen*R*tem/(V0*p_pa))*sin(angle/2);   
    kk =kk+ 1;
end
%%
%%
bri_shift_new=bri_shift(1,1:151)';
save bri_shift_new bri_shift_new
%%
function tp=get_t_p(r)
T_SL=288.15;%海平面温度，单位：K
P_SL=101325;%海平面气压，单位：Pa（ N/m2）
Re=6356.766;%地球半径，单位：km
z=r;%几何高度，单位：km
H=[];
W=[];
T=[];
P=[];
a=length(z);
for i=1:a
    if z(i)<=11.0191
    H1=z(i)/(1+z(i)/Re);
    H=[H;H1];
    W1=1-H1/44.3308;
    W=[W;W1];
    T1=288.15*W1;
    T=[T;T1];
    P1=P_SL*W1^5.2559;
    P=[P;P1];
    end
    
    if 11.0191<z(i) & z(i)<=20.0631
    H2=z(i)/(1+z(i)/Re);
     H=[H;H2];
    W2=exp((14.9647-H2)/6.3416);
    W=[W;W2];
    T2=216.650;
    T=[T;T2];
    P2=P_SL*0.11953*W2;
    P=[P;P2];
    end
    
    if 20.0631<z(i) & z(i)<=32.1619
    H3=z(i)/(1+z(i)/Re);
    H=[H;H3];
    W3=1+(H3-24.9021)/221.552;
    W=[W;W3];
    T3=221.552*W3;
    T=[T;T3];
    P3=P_SL*0.025158*W3^-34.162;
    P=[P;P3];
    end
    
    if 32.1619<z(i) & z(i)<=47.3501
        H4=z(i)/(1+z(i)/Re);
        H=[H;H4];
        W4=1+(H4-39.7499)/89.4107;
        W=[W;W4];
        T4=250.350*W4;
        T=[T;T4];
        P4=P_SL*2.8338e-3*W4^-12.2011;
        P=[P;P4];
    end
    
    if 47.3501<z(i) & z(i)<=51.4125
        H5=z(i)/(1+z(i)/Re);
        H=[H;H5];
        W5=exp((48.6252-H5)/7.9223);
        W=[W;W5];
        T5=270.650;
        T=[T;T5];
        P5=P_SL*8.9155e-4*W5;
        P=[P;P5];
        
    end
end
P=P/1e5;
TP(:,1)=T;
TP(:,2)=P;
tp=TP;
end

