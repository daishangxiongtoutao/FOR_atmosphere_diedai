%% 该程序是信赖域算法和类福克托算法里面用于计算误差的程序
function E = error_gaussian(initial_value)
%% 调用谱线并对相关参数赋值
global v Intensity freq Airy% 调用全局变量频率v和归一化强度Intensity
Brillouin_shift = initial_value(:,1);% 布里渊频移
Rayleigh_linewidth = initial_value(:,2);% 瑞利线宽
Brillouin_linewidth = initial_value(:,3);% 布里渊线宽
Rayleigh_intensity = initial_value(:,4);% 瑞利强度
% load s6_fitted.mat
% scale_factor = fitted_value(2);
% offset = fitted_value(3);
% mie_intensity = fitted_value(4);
% base = fitted_value(5);
scale_factor = initial_value(:,5); % scale_factor
offset = initial_value(:,6);
mie_intensity = initial_value(:,7);
base = initial_value(:,8);
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


% RBS1 = scale_factor.*RBS1;
% figure
% plot(v,Intensity,'.r',v,RBS1,'b')
% legend('Experiment data','G3 fit spectrum')
%% 求取误差
E = RBS1-Intensity;% 谱线相减求取
end