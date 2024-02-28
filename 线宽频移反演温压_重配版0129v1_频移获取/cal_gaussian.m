%% 该程序是信赖域算法和类福克托算法里面用于计算误差的程序
function l = cal_gaussian(fitted_value1)
global v Intensity freq Airy freq1 Airy1 i% 调用全局变量频率v和归一化强度Intensity
Brillouin_shift = fitted_value1(:,1);% 布里渊频移
Rayleigh_linewidth = fitted_value1(:,2);% 瑞利线宽
Brillouin_linewidth = fitted_value1(:,3);% 布里渊线宽
Rayleigh_intensity = fitted_value1(:,4);% 瑞利强度
% load s6_fitted.mat
% scale_factor = fitted_value(2);
% offset = fitted_value(3);
% mie_intensity = fitted_value(4);
% base = fitted_value(5);
% save(strcat('C:\Users\16534\Desktop\温压反演\实验数据\k=0\scale_factor1\',num2str(i)),'scale_factor');
% save(strcat('C:\Users\16534\Desktop\温压反演\实验数据\k=0\mie_intensity1\',num2str(i)),'mie_intensity');
% save(strcat('C:\Users\16534\Desktop\温压反演\实验数据\k=0\base1\',num2str(i)),'base');
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

[peak,loc] = findpeaks(RBS1,'minpeakheight',0.05);
y_half = 0.5*peak;
lower_index = loc;
upper_index = loc;
while RBS1(lower_index) > y_half
  lower_index = lower_index-1;
%      lower_index = lower_index;
end
while RBS1(upper_index) > y_half
    upper_index = upper_index+1;
    
end
l = freq(upper_index)- freq(lower_index+1);
end