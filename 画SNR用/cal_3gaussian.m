%% 该程序是信赖域算法和类福克托算法里面用于计算误差的程序
function l = cal_3gaussian(fitted_value1)
%% 调用谱线并对相关参数赋值
Brillouin_shift = fitted_value1(:,1);% 布里渊频移
Rayleigh_linewidth = fitted_value1(:,2);% 瑞利线宽
Brillouin_linewidth = fitted_value1(:,3);% 布里渊线宽
Rayleigh_intensity = fitted_value1(:,4);% 瑞利强度
scale_factor = fitted_value1(:,5); % scale_factor
offset = fitted_value1(:,6);
%% 计算瑞利峰谱线，采用较密的数据进行计算
f = (-15:0.001:15)';
%% 计算瑞利布里渊谱线，采用较密的数据进行计算
Rayleigh1 =  1./(sqrt(2.*pi).*Rayleigh_linewidth).*exp(-1/2.*(f./Rayleigh_linewidth).^2);
Brillouin1 = 1./(2.*sqrt(2.*pi).*Brillouin_linewidth).*exp(-1/2.*((f+Brillouin_shift)./Brillouin_linewidth).^2)...
+1./(2.*sqrt(2.*pi).*Brillouin_linewidth).*exp(-1/2.*((f-Brillouin_shift)./ Brillouin_linewidth).^2);% 计算瑞利布里渊散射谱线
%% 与器件函数卷积
% Rayleigh1 = interp1(f,Rayleigh1,freq1);
% Rayleigh_convoluted = conv(Rayleigh1,Airy1,'same');% 卷积函数器件展宽后的瑞利谱线
% Rayleigh_convoluted = Rayleigh_convoluted./polyarea([min(freq1) freq1' max(freq1)],[0 Rayleigh_convoluted' 0]);
% Brillouin1 = interp1(f,Brillouin1,freq1);
% Brillouin_convoluted = conv(Brillouin1,Airy1,'same');% 卷积函数器件展宽后的布里渊谱线
% Brillouin_convoluted = Brillouin_convoluted./polyarea([min(freq1) freq1' max(freq1)],[0 Brillouin_convoluted' 0]);
Rayleigh = Rayleigh1.*Rayleigh_intensity;% 乘上瑞利峰的强度，最后得到RBS谱中瑞利成分
Brillouin = Brillouin1.*(1-Rayleigh_intensity);% 乘上布里渊峰的强度，最后得到RBS谱中布里渊成分
RBS = Rayleigh+Brillouin;
load v1.mat
load f_mol.mat
RBS1 = interp1(f,RBS,v1-offset);
RBS1 = scale_factor.*RBS1;

figure
plot(v1,RBS1,'r--',v1,f_mol,'b')
% legend('RBS-g3','Rayleigh','Brillouin','RBS-s6')
% saveas(gcf,['C:/Users/16534/Desktop/温压反演/实验数据/k=1/拟合效果图/',num2str(i),'_2.fig']);

% figure
% plot(v22,S22,'.r',v22,RBS1,'b')
% legend('散射光谱','g3拟合谱线')
% saveas(gcf,['C:/Users/16534/Desktop/温压反演/实验数据/dataRayleigh_ave/k=29/拟合效果图/',num2str(i+149),'.fig']);

[peak,loc] = findpeaks(RBS,'minpeakheight',0.05);
y_half = 0.5*peak;
lower_index = loc;
upper_index = loc;
while RBS(lower_index) > y_half
    lower_index = lower_index-1;
end
while RBS(upper_index) > y_half
    upper_index = upper_index+1;
end
l = freq1(upper_index)- freq1(lower_index);
l=l(2);
end