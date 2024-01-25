%% 该程序用于对不同算法的变量初始值进行赋值，其中初始值被分成不同情况进行赋值
function initial_value = initial_value_assignment(value_min,value_max,fitting_style)
% 输入参数为待拟合参数的初始值的上下限

switch fitting_style
    case 0
    n = 4;% n为对分段数

    %% 对初始值进行分段赋值
    initial_value_space = (value_max-value_min)./(n-1);% 计算分段间隔
% 均匀分布的初值
% for i = 1:n
%     initial_value(i,:) = value_min+initial_value_space.*(i-1);% 对初始值进行分段赋值
% end


% 遍历分布的初值，福克托
for i = 1:n
    for j = 1:n
        for k = 1:n
            for l = 1:n
                initial_value((i-1).*n.^3+(j-1).*n.^2+(k-1).*n+l,1) = value_min(1,1)+initial_value_space(1,1).*(i-1);
                initial_value((i-1).*n.^3+(j-1).*n.^2+(k-1).*n+l,2) = value_min(1,2)+initial_value_space(1,2).*(j-1);
                initial_value((i-1).*n.^3+(j-1).*n.^2+(k-1).*n+l,3) = value_min(1,3)+initial_value_space(1,3).*(k-1);
                initial_value((i-1).*n.^3+(j-1).*n.^2+(k-1).*n+l,4) = value_min(1,4)+initial_value_space(1,4).*(l-1);
            end
        end
    end
end

    case 1
        %遍历pseudo_voigt 的初始值
    % 输入的参数分别为拟合次数、类福克托线型的各项输入参数及其最大值和最小值，initial_value第一个参数为布里渊频移，第二个
    % 为瑞利的洛伦兹比重，第三个为瑞利高斯线宽，第四个为瑞利洛伦兹线宽，第五个为瑞利成分强度，第六个为布里渊洛伦兹比重，第
    % 七个为布里渊高斯线宽，第八个为布里渊洛伦兹线宽。value_min为参数下限，value_max为参数上限。
    n = 5;
    initial_value_space = (value_max-value_min)./(n-1);% 计算分段间隔
    
    for i = 1:n
        for j = 1:n
            for k = 1:n
                for l = 1:n
                    initial_value((i-1).*n.^3+(j-1).*n.^2+(k-1).*n+l,1) = value_min(1,1)+initial_value_space(1,1).*(i-1);
                    initial_value((i-1).*n.^3+(j-1).*n.^2+(k-1).*n+l,2) = value_min(1,2)+initial_value_space(1,2).*(j-1);
                    initial_value((i-1).*n.^3+(j-1).*n.^2+(k-1).*n+l,3) = value_min(1,3)+initial_value_space(1,3).*(k-1);
                    initial_value((i-1).*n.^3+(j-1).*n.^2+(k-1).*n+l,4) = value_min(1,4)+initial_value_space(1,4).*(l-1);
                end
            end
        end
    end
    
    case 2
%     n = 2;% n为对分段数
n =2;% n为对分段数
%% 对初始值进行分段赋值
    initial_value_space = (value_max-value_min)./(n-1);% 计算分段间隔
        % 遍历分布的初值，高斯
            for k = 1:n
                for l = 1:n
                    initial_value((k-1).*n+l,1) = value_min(1,1)+initial_value_space(1,1).*(k-1);
                    initial_value((k-1).*n+l,2) = value_min(1,2)+initial_value_space(1,2).*(l-1);
                end
            end
        
end