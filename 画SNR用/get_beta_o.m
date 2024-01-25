%% 0421 确定版 计算实验能量数据的后向散射系数(未处理版)
clear all
clc

T = load("T_radio.txt");
p = load("p_radio.txt"); 
z=load("h.txt");
z=z.*1e3;
% Pn_r=load("N1.txt")./(1e41).*z;
 Pn_r=load("N1.txt");
%% 单脉冲回波光子 参数
delt_z = 30;        % 距离分辨率，m  (150m)
 lambda = 532;       % 发射激光波长，nm
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

%%
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
% save beta_r beta_m1;