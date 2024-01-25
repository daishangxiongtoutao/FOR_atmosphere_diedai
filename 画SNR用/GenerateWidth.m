function [ d_W ] = GenerateWidth( Tem, Pre )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% nRows = length( Pre );
% nCols = length( Tem );
% 
% linewidth = ones( nRows, nCols );
% 
% for i = 1:nRows
%     for j = 1:nCols
%         [ temp ] = SimulateS6( Tem(j), Pre(i) );
%         linewidth(i, j) = temp;
%     end
% end
for ii=1:1:length(Tem)
    
T=Tem(ii);
p=Pre(ii);

% ii=round(P*10)
% jj=round((T-210)/10)
load freq_array.txt
freq = freq_array./1e9;  
load dataCirrusFine.txt
Airy = dataCirrusFine;  %仪器函数
%% 
%% 注意这里的lef和rgt的取值为-10~10 （符合仪器函数）
% Basic frequency initialization
n_xi = 801; % Number of frequency points, dimensionless unit
xi_lef = -10; % Minimum frequency point, dimensionless unit
xi_rgt = 10; % Maximum frequency point, dimensionless unit
dxi = (xi_rgt-xi_lef)./(2.0.*(n_xi-floor(n_xi./2)-1)); % Calculate the frequency space
for i = 1:n_xi
    xi(i) = xi_lef+dxi.*(i-1); % Calculate the frequency points, 
          % dimensionless unit
end
kb = 1.38e-23; % Boltzmann constant, in J/K
lambda = 532e-9; % The wavelength of the laser, in m
scattering_angle = 180; % scattering angle
angle = scattering_angle/2*(pi/180); % scattering angle in radians
k = sin(angle)*4*pi/lambda; % wave number, in m^-1
% General gas characteristics
tem = T; % temperature, in K
p_bar = p;
p_pa = p_bar*1e5; % pressure, in Pa
% Gas style and gas characteristics for each gas style
M = 28.970; % Relative molecular weight, dimensionless unit
viscosity = 1.846e-5.*(tem./300).^(3/2).*((300+110.4)./(tem+110.4)); % shear viscosity, in Pa·sec
%   bulk_vis = 1.71e-7.*tem-3.1e-5; % bulk viscosity, in Pa·sec  
%  bulk_vis = 1.57e-7.*tem-3.1e-5; % bulk viscosity, in Pa·sec 
% bulk_vis = 2.11e-7.*tem-3.1e-5; % bulk viscosity, in Pa·sec  
bulk_vis = 2.87e-7.*tem-3.1e-5; % bulk viscosity, in Pa·sec  
thermal_cond = 26.24e-3.*(tem./300).^(3/2).*((300+245.4*exp(-27.6/300))./(tem+245.4*exp(-27.6/tem)));% thermal conductivity, in W/(m*K)
c_int = 1; % internal heat capacity, the unit is not found
heat_capacity_ratio = 1.4;% heat capacity ratio

m_m = M*1.66e-27; % Molecular weight, kg
v0 = sqrt(2*kb*tem/m_m); % Heat speed，m/sec
n0 = p_pa/(tem*kb); % Numerical density,in 1/m^3
y = n0*kb*tem/(k*v0*viscosity); % Ratio of mean free path and laser 
            % wavelength, demensionless unit
vs = sqrt(heat_capacity_ratio.*kb.*tem/m_m); % Sound speed, m/sec
vb = 2.*vs./lambda.*sin(angle); % Frequency, Hz
c_tr = 3/2; % Translational heat capacity, J/(mol·K)
gamma_int = c_int/(c_tr+c_int); % Internal heat capacity ratio, 
                                % dimensionless un
y6 = y;
rlx_int = 1.5*bulk_vis/(viscosity*gamma_int); % Internal relaxation
eukenf = m_m*thermal_cond/(viscosity*kb*(c_tr+c_int)); % Euken factor
v1 = xi.*k.*v0./(2.*pi);% The relative frequency, in Hz
% The spectrum calculation from WCU equation
cpxunit = 1i; % Unit imaginary part of complex
one = 1; % One
zero = 0; % Zero

% Calculate j
j020 = -y;
j100 = -gamma_int*y/rlx_int;
j001 = j100*c_tr/c_int;
j100001 = j100*sqrt(c_tr/c_int);
j110 = j100*5/6+j020*2/3;
j011110 = j100*sqrt(5/(8*c_int));

j_nu = 0.4*(1.5+c_int)+(3+c_int)/(2*rlx_int)+9*eukenf/(16*rlx_int^2);
j_de = -1+(4/15)*eukenf*(1.5+c_int)+(c_int/3)*eukenf/rlx_int;
j_co = -y*(2*gamma_int/3);
j011 = j_co*j_nu/j_de;

% Initialization for the area of spontaneous RBS spectrum and coherent RBS
% spectrum
sptarea = 0; % Area of spontaneous RBS spectrum
coharea = 0; % Area of coherent RBS spectrum

% calculate the matrix equation Ax = B. The x here is the target variable.
for i = 1:n_xi
    % Calculate w
    z = xi(i)+cpxunit.*y6;
    F = @(x)exp(-x.^2)./(z-x);
    w0 = quad(F,-20,20);
    
    w1 = -sqrt(pi)+z.*w0;
    w2 = z.*w1;
    w3 = -0.5.*sqrt(pi)+z.*w2;
    w4 = z.*w3;
    w5 = -3.*sqrt(pi)./4+z.*w4;
    w6 = z.*w5;
    
    % Calculate i
    i0000 = w0./(sqrt(pi));
    i0100 = (z.*w0-sqrt(pi)).*sqrt(2./pi);
    i0001 = i0100;
    i0010 = (2.*w2-w0)./(sqrt(6.*pi));
    i1000 = i0010;
    i0011 = (2.*w3-3.*w1)./(sqrt(5.*pi));
    i1100 = i0011;
    i0101 = 2.*w2./sqrt(pi);
    i0110 = (-w1+2*w3)./sqrt(3.*pi);
    i1001 = i0110;
    i0111 = (-3.*w2+2.*w4).*sqrt(2./(5.*pi));
    i1101 = i0111;
    i1111 = (13.*w2-12.*w4+4.*w6)./(5.*sqrt(pi));
    i0002 = (-w0+2.*w2)./sqrt(3.*pi);
    i0200 = i0002;
    i0211 = (-w1+8.*w3-4.*w5)/sqrt(15.*pi);
    i1102 = i0211;
    i0202 = 2.*(w0-2.*w2+2.*w4)./(3.*sqrt(pi));
    i0210 = (w0+4.*w2-4.*w4)./(3.*sqrt(2.*pi));
    i1002 = i0210;
    i0102 = (-w1+2.*w3).*sqrt(2./(3.*pi));
    i0201 = i0102;
    i1010 = (5.*w0-4.*w2+4.*w4)./(6.*sqrt(pi));
    i1110 = (7.*w1-8.*w3+4.*w5)./sqrt(30.*pi);
    i1011 = i1110;
    
    % Calculate matrix A
    a_factor = one;
    a(1,1) = -j020.*i0000+cpxunit;
    a(2,1) = -j020.*i0001;
    a(3,1) = -j020.*i0011;
    a(4,1) = -j020.*i0010;
    a(5,1) = zero;
    a(6,1) = zero;
    
    a(1,2) = -j020.*i0100;
    a(2,2) = -j020.*i0101+cpxunit;
    a(3,2) = -j020.*i0111;
    a(4,2) = -j020.*i0110;
    a(5,2) = zero;
    a(6,2) = zero;
    
    a(1,3) = (j020-j110).*i1100;
    a(2,3) = (j020-j110).*i1101;
    a(3,3) = (j020-j110).*i1111-cpxunit;
    a(4,3) = (j020-j110).*i1110;
    a(5,3) = -j011110.*i0100;
    a(6,3) = -j011110.*i0101;
    
    a(1,4) = (j020-j100).*i1000;
    a(2,4) = (j020-j100).*i1001;
    a(3,4) = (j020-j100).*i1011;
    a(4,4) = (j020-j100).*i1010-cpxunit;
    a(5,4) = -j100001.*i0000;
    a(6,4) = -j100001.*i0001;
    
    a(1,5) = j100001.*i1000;
    a(2,5) = j100001.*i1001;
    a(3,5) = j100001.*i1011;
    a(4,5) = j100001.*i1010;
    a(5,5) = (j001-j020).*i0000+cpxunit;
    a(6,5) = (j001-j020).*i0001;
    
    a(1,6) = j011110.*i1100;
    a(2,6) = j011110.*i1101;
    a(3,6) = j011110.*i1111;
    a(4,6) = j011110.*i1110;
    a(5,6) = (j011-j020).*i0100;
    a(6,6) = (j011-j020).*i0101+cpxunit;
    
    % calculate matrix B
    % For coherent RBS
    b(1,1) = -i0100;
    b(2,1) = -i0101;
    b(3,1) = -i0111;
    b(4,1) = -i0110;
    b(5,1) = zero;
    b(6,1) = zero;
    
    % For spontaneous RBS
    b(1,2) = -i0000;
    b(2,2) = -i0001;
    b(3,2) = -i0011;
    b(4,2) = -i0010;
    b(5,2) = zero;
    b(6,2) = zero;
    
    % solve the equation for x
    X=a\b;
    cohsig(i) = X(1,1).*conj(X(1,1));
    sptsig(i) = 2.*real(X(1,2));
    coharea = coharea+cohsig(i);
    sptarea = sptarea+sptsig(i);
end
% Normalize the spectra named "cohsig" and "sptsig"
for i=1:n_xi
    sptsig(i) = sptsig(i).*(2.*(n_xi-floor(n_xi./2)-1))./...
             (sptarea.*(xi(n_xi)-xi(1)));
end
sptsig = sptsig';
v1 = v1'./1e9;

%与仪器函数卷积


sptsig=interp1(v1,sptsig,freq);
sptsig_convoluted = conv(sptsig,Airy,'same'); % Spontaneous RBS spectrum after 
sptsig_convoluted = sptsig_convoluted./polyarea([min(freq) freq' max(freq)],[0 sptsig_convoluted' 0]); % 面积归一化
% figure;
% plot(freq,sptsig_convoluted);%瑞利布里渊散射谱

% save v1.mat v1
% save f_mol.mat f_mol
%%读线宽
v1=freq;f_mol=sptsig_convoluted;
v11=min(v1):0.0001:max(v1);
f_mol=interp1(v1,f_mol,v11);
[peak,loc] = findpeaks(f_mol,'minpeakheight',0.05);
y_half = 0.5*peak;
lower_index = loc;
upper_index = loc;
while f_mol(lower_index) > y_half
    lower_index = lower_index-1;
end
while f_mol(upper_index) > y_half
    upper_index = upper_index+1;
end
l = v11(upper_index)- v11(lower_index);
l=l(2);
d_W(ii,1)=l;

 end
end