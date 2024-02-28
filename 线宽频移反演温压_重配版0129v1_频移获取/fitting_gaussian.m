%% 程序采用三高斯函数和信赖域算法对大气布里渊数据进行拟合
function [] = fitting_gaussian()
% 输出的参数分别为initial_value为y因子的初值，拟合值和不确定度，其中fitted_value中，
% 第一为布里渊频移，第二为瑞利线宽，第三为布里渊线宽，第四为瑞利强度
% 设置初始值范围
global fit_value
value_min_initial = [0.4 0.85];% 设置待拟合参数的初始值下限
value_max_initial = [0.5 0.95];% 设置待拟合参数的初始值上限
initial_value1 = initial_value_assignment(value_min_initial,value_max_initial,2);% 多种初始值测试
initial_value(:,3:4) = initial_value1(:,1:2);% 设置布里渊线宽和瑞利强度
% initial_value(:,1) = 1;% 设置布里渊频移
% initial_value(:,2) = 1;% 设置瑞利线

value_min_initial = [0.95 0.95];% 设置待拟合参数的初始值下限
value_max_initial = [1.05 1.05];% 设置待拟合参数的初始值上限
initial_value1 = initial_value_assignment(value_min_initial,value_max_initial,2);% 多种初始值测试
initial_value(:,1:2) = initial_value1(:,1:2);% 设置布里渊频移和瑞利线宽
initial_value(:,5) = 1; % Mie intensity
initial_value(:,6) = 0;% offset
initial_value(:,7) = 1;% mie
initial_value(:,8) = 1;% base

% initial_value = [1.08267	1.03476	0.38661	0.8783];

%% 设置算法
options = optimset('lsqnonlin');% 设置拟合为非线性拟合
options = optimset(options,'Algorithm','trust-region-reflective');% 设置拟合算法为信赖域算法并设置算法中的初始阻尼系数
%options = optimset(options,'Algorithm','Levenberg-Marquardt');% 设置拟合算法为L-M算法
ptions = optimset(options,'TolFun',1e-20);% 规定最小误差变化量
options = optimset(options,'TolX',1e-20);% 规定最小迭代步长变化量
% options = optimset(options,'TolFun',1e-25);% 规定最小误差变化量
% options = optimset(options,'TolX',1e-25);% 规定最小迭代步长变化量
 iteration_num=2.5e4;
% iteration_num=2.5e6;
options = optimset(options,'MaxIter',iteration_num);
options = optimset(options,'MaxFunEvals',iteration_num);

% value_min = [0.5 0.35 0.01 0.25 0.1 -1.5 0 0];% 设置待拟合参数的变化范围下限
% value_max = [2   2    1    1    10   1.5 10 10];% 设置待拟合参数的变化范围上限
% value_min = [0.95 0.95 0.4 0.85];% 设置待拟合参数的变化范围下限
% value_max = [1.05 1.05 0.5 0.95];% 设置待拟合参数的变化范围上限
%%111111
value_min = [fit_value(1) 0.95 0.4 0.85];% 设置待拟合参数的变化范围下限
value_max = [fit_value(2) 1.05 0.5 0.95];% 设置待拟合参数的变化范围上限
%%222222222
% value_min = [fit_value(1) 0.85 0.4 0.85];% 设置待拟合参数的变化范围下限
% value_max = [fit_value(2) 1.05 0.5 0.95];% 设置待拟合参数的变化范围上限
for i  = 1:1:length(initial_value(:,1))% 多次测量结果
    i
    [fitted_value(i,:),~,residual,~,~,~] = ...
         lsqnonlin(@error_gaussian,initial_value(i,:),value_min,value_max,options); 
       % 曲线拟合
    RMSE(i,:) = norm(residual,2)./sqrt(length(residual));
    save gauss_fitted.mat fitted_value RMSE
end
end