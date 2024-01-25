%% 试验 正向计算回波光子数，并反算后向散射系数 的对比测试
% 实验温压正向计算后向散射系数，和利用实验能量反向求解后向散射系数的对比 
% 实验温压计算的光子数 与实验光子数对比
clear all
clc
T = load("T_radio.txt");
p = load("p_radio.txt"); 
z=load("h.txt");
z=z.*1e3;
Pn_r=load("N1.txt")./(1e41).*z;

%% 气溶胶和分子的消光系数

Sm = 8*pi/3;        % 大气分子消光后向散射比
delt_z = 30;        % 距离分辨率，m  (150m)
lambda = 532;       % 发射激光波长，nm
P=p.*1e5;
for num=1:length(T)
        density(num) = (P(num)*296)./(1.013e5*T(num))*2.479e25; %密度  
end
beta_test_zhao=(0.55e-6)^4*5.45e-32/((532e-9)^4);
beta_m=beta_test_zhao*density;
%% 仿真实验温压条件下的光子数进一步计算光子数
alpha_m = Sm.*beta_m;   %大气分子消光系数
alpha_a = 0; %气溶胶消光系数
alpha_total = alpha_a + alpha_m; % 总的消光系数=气溶胶消光系数加上分子消光系数
%积分项
intalpha = zeros(1,length(alpha_total));
int_1 = 0;
for count = 1:length(alpha_total)
     int_1= int_1 + alpha_total(count)*delt_z;
      intalpha(count) = int_1;
end

%单脉冲回波光子 （反算参数）
c = 3e8;                 % 光速m/s
t = 10e-9;               % 激光脉宽
fib_ita = 0.2;           % 光纤耦合效率
fil_ita = 0.8;           % 滤光片透过率
fp_ita = 0.9;            % FP峰值透过率
op_ita = fib_ita*fil_ita*fp_ita; % 光学效率
pc_ita = 0.1;            % PMT量子效率
ita = op_ita * pc_ita;   % 系统效率
S_energy = 0.12;         % 单脉冲激光能量 J
Pt = S_energy/t;         % 激光峰值功率 W
r = 0.32;                % 接收望远镜半径m
% Oc_rate = 0.92;          % 接收望远镜遮挡率8%
A = pi*r^2;              % 望远镜接收面积 *Oc_rate
h = 6.6262*10^(-34);     % 普朗克常量
freq = 100;              % 重复频率 hz
sys_const = (S_energy*h*c)*A* ita*delt_z/(lambda*1e-9);
sys_const=sys_const.*1.044;
for i =1:length(z)
%     Pn_m1(i) = sys_const*beta_m(i)/(z(i)^3);
 Pn_m1(i) = sys_const*beta_m(i)/(z(i)^2);
    Pn_m2(i) = exp(-2*intalpha(i));
    Pn_m(i) = Pn_m1(i)*Pn_m2(i);
end
Pn_a = 0;
Pn = (Pn_m + Pn_a);
Pn = Pn';%实验温压下的仿真光子数

%%
Pn_r=load("N1.txt")./(1e41).*z; %实验光子数
%%实验光子数反算后向散射系数
Pn_1=Pn_r;
syms beta1
beta_m1 = zeros(1,length(z));
ep1=(sys_const*beta1/z(1)^2)*exp(-160*pi*beta1)==Pn_1(1);
beta_m1(1)=vpasolve(ep1,beta1);
intbeta=beta_m1(1);

for i=2:length(z)
    syms beta
    intbeta=beta+intbeta;
    ep=(sys_const*beta/z(i)^2)*exp(-160*pi*intbeta)==Pn_1(i);
    beta_m1(i)=vpasolve(ep,beta);
end
%%
E_new=beta_m1./beta_m; %%反射系数对比