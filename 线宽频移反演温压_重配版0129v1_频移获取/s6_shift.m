function [bri_shift] = s6_shift(T,P)
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
    bri_shift           = 2*n/lambda*sqrt(heat_capacity_ratio*kb*tem/m_m)*exp(-Gruneisen*R*tem/(V0*p_pa))*sin(angle/2);    
end