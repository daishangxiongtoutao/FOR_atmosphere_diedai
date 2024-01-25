%% 该程序用于仿真温度T:220~340、压强P:0.1~1下的S6散射谱线并读取线宽
clc;
clear;
close all
%%
rr=linspace(4.8,9.3,151);
sptsig_convoluted1=zeros(151,301);
for gaodu=1:length(rr)
    tp=get_t_p(rr(gaodu));
    
    T=tp(:,1);
    P=tp(:,2);
    % T=220;
    % P=0.3;
    %%
    global freq Airy v Intensity freq1 Airy1 fit_value
    
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
    p_bar = P;
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
    sptsig_convoluted1(gaodu,:)=sptsig_convoluted;
end
figure;
plot(freq,sptsig_convoluted1(2,:));%瑞利布里渊散射谱\
%% 单脉冲回波光子
load zhaoyu.mat R Pn_ode
%% 加上可能的实际的回波光子数
sptsig_withnoise1=zeros(151,301,50);
for gaodu=1:length(rr)
    SNR=[];
    SNR_noise1=[];
    Ns=Pn_ode(gaodu);%5km处单脉冲回波光子数
    cps=3000;%光子计数率
    t=100e-9;%采集卡采集时间
    Nd=cps*t;%PMT暗计数
    NSF=1.3598; % 噪声比例因子
    M=linspace(1,20000,50);
    snr=Ns*sqrt(M)./(NSF*sqrt((Ns+Nd)));% 每一个点的信噪比；sqrt((Ns+Nd).*RBS1)：每一个点的噪声
    SNR=[SNR;snr];
    RBS2=(Ns+Nd)*sptsig_convoluted1(gaodu,:);%这是只考虑夜间观测
%     figure;
%     plot(freq,RBS2);%瑞利布里渊散射谱配固定噪声
    
    for i = 1:length(M)
        [ sptsig_withnoise, SNR_noise ]=AddNoiseNondB(RBS2,SNR(i));
        sptsig_withnoise1(gaodu,:,i)=sptsig_withnoise';%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%这是带噪谱
        SNR_noise1=[SNR_noise1;SNR_noise];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%这是对应信噪比
    end
end
figure;
plot(freq,sptsig_withnoise1(2,:,20)); %瑞利布里渊散射谱_含噪声
%%
%
v1=freq;
f_mol=sptsig_withnoise;
% f_mol=sptsig_convoluted;  %%%[91,189]
Intensity=f_mol(91:189,:);
v=v1(91:189,:);

%%
% Intensity=sptsig_convoluted;
    Intensity_1=Intensity;
    Intensity = Intensity./polyarea([min(v) v' max(v)],[0 Intensity' 0]);
   figure
   plot(v,Intensity);
   hold on
   %%
    fitting_gaussian()
    load gauss_fitted.mat

%%
 [~,loc] = max(fitted_value(:,7));
        fitted_value1=fitted_value(loc,:);
%% 还原谱线——测线宽
Brillouin_shift = fitted_value1(:,1);% 布里渊频移
Rayleigh_linewidth = fitted_value1(:,2);% 瑞利线宽
Brillouin_linewidth = fitted_value1(:,3);% 布里渊线宽
Rayleigh_intensity = fitted_value1(:,4);% 瑞利强度

scale_factor = fitted_value1(:,5); % scale_factor
offset = fitted_value1(:,6);
% save(strcat('C:\Users\ZY\Desktop\新建文件夹 (2)',num2str(i)),'offset');
mie_intensity = fitted_value1(:,7);
base = fitted_value1(:,8);
% load(strcat('C:\Users\16534\Desktop\温压反演\实验数据\mie_intensity\',num2str(18)),'mie_intensity');
%% 计算瑞利峰谱线，采用较密的数据进行计算
f = (-15:0.01:15)';
%% 计算瑞利布里渊谱线，采用较密的数据进行计算
Rayleigh1 =  1./(sqrt(2.*pi).*Rayleigh_linewidth).*exp(-1/2.*(f./Rayleigh_linewidth).^2);
Brillouin1 = 1./(2.*sqrt(2.*pi).*Brillouin_linewidth).*exp(-1/2.*((f+Brillouin_shift)./Brillouin_linewidth).^2)...
+1./(2.*sqrt(2.*pi).*Brillouin_linewidth).*exp(-1/2.*((f-Brillouin_shift)./ Brillouin_linewidth).^2);% 计算瑞利布里渊散射谱线
%% 与器件函数卷积
Rayleigh1 = interp1(f,Rayleigh1,freq);
Rayleigh_convoluted = conv(Rayleigh1,Airy,'same');% 卷积函数器件展宽后的瑞利谱线
vNew = v-offset;
Rayleigh_convoluted = interp1(freq,Rayleigh_convoluted,v-offset);
Rayleigh_convoluted = Rayleigh_convoluted./polyarea([min(vNew) vNew' max(vNew)],[0 Rayleigh_convoluted' 0]);

Brillouin1 = interp1(f,Brillouin1,freq);
Brillouin_convoluted = conv(Brillouin1,Airy,'same');% 卷积函数器件展宽后的布里渊谱线
Brillouin_convoluted = interp1(freq,Brillouin_convoluted,vNew);
Brillouin_convoluted = Brillouin_convoluted./polyarea([min(vNew) vNew' max(vNew)],[0 Brillouin_convoluted' 0]);

Mie = interp1(freq,Airy,vNew);
Mie = Mie./polyarea([min(vNew) vNew' max(vNew)],[0 Mie' 0]);

Rayleigh = Rayleigh_convoluted.*Rayleigh_intensity;% 乘上瑞利峰的强度，最后得到RBS谱中瑞利成分
Brillouin = Brillouin_convoluted.*(1-Rayleigh_intensity-mie_intensity);% 乘上布里渊峰的强度，最后得到RBS谱中布里渊成分
mie = mie_intensity.*Mie; 

RBS1 = Rayleigh+Brillouin+mie+base; % 加上米散射

RBS1Area = polyarea([min(v-offset) (v-offset)' max(v-offset)],[0 RBS1' 0]);
RBS1 =RBS1./RBS1Area;

plot(v-offset,RBS1,'-',LineWidth=2,Marker='o')

RBS_1=RBS1;  %拟合后的含噪谱线
% RBS_l=sptsig_convoluted; %原始理论谱线

[peak,loc] = findpeaks(RBS_1,'minpeakheight',0.05);
y_half = 0.5*peak;
lower_index = loc;
upper_index = loc;
while RBS_1(lower_index) > y_half
  lower_index = lower_index-1;
%      lower_index = lower_index;
end
while RBS_1(upper_index) > y_half
    upper_index = upper_index+1;
    
end
l = freq(upper_index)- freq(lower_index+1);

 %%
function [ Iv_Noised, SNR_cal ]=AddNoiseNondB(Iv,SNR)

Iv_poisson = poissrnd(Iv); %加噪
Noise_pre = Iv_poisson-Iv; %预噪声信号
Noise_pre_power = sum(Noise_pre.^2)/length(Noise_pre); %预噪声信号功率
Iv_power = sum(Iv.^2)/length(Iv); %干涉谱功率
SNR_pre = Iv_power/Noise_pre_power; %功率比
scale=sqrt(SNR_pre/SNR); %缩放因子
% Noise = abs(Noise_pre.*scale); %噪声信号
Noise = Noise_pre.*scale; %噪声信号
Noise_power = sum(Noise.^2)/length(Noise);
SNR_cal = Iv_power/Noise_power;
Iv_Noised = Iv+Noise; %加噪


end