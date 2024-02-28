%% 该程序用于仿真高度 4.8-9.3 高度下 带噪 仿真信号 的布里渊频移
clc;
clear;
close all
%%
global freq Airy v Intensity freq1 Airy1 fit_value
load freq_array.txt
freq = freq_array./1e9;  
load dataCirrusFine.txt
Airy = dataCirrusFine;  %仪器函数
load sptsig_wn;
sptsig_wn=sptsig_wn;
v1=freq;
v=v1(91:189,:);
rr=linspace(4.8,9.3,151);

%%
for is=1:1:50
    for ih=1:length(rr)
%%

f_mol=sptsig_wn(ih,:,is);
% f_mol=sptsig_convoluted;  %%%[91,189]
Intensity=f_mol';
Intensity_1=Intensity;
   Intensity = Intensity./polyarea([min(v) v' max(v)],[0 Intensity' 0]);
%    figure
%    plot(v,Intensity);
%    hold on
kmm=1;
  for k1 =1.0:0.02:1.2
      for k2= 1.25:0.02:1.4
  fit_value(1)=k1;
  fit_value(2)=k2;
    fitting_gaussian()
    load gauss_fitted.mat
    B_shift_k(kmm,:)=fitted_value(:,1)';

    kmm=kmm+1;
      end
  end
%%
 [~,loc] = max(fitted_value(:,7));
        fitted_value1=fitted_value(loc,:);
%% 还原谱线——测线宽
% Brillouin_shift = fitted_value1(:,1);% 布里渊频移
% Rayleigh_linewidth = fitted_value1(:,2);% 瑞利线宽
% Brillouin_linewidth = fitted_value1(:,3);% 布里渊线宽
% Rayleigh_intensity = fitted_value1(:,4);% 瑞利强度
% 
% scale_factor = fitted_value1(:,5); % scale_factor
% offset = fitted_value1(:,6);
% % save(strcat('C:\Users\ZY\Desktop\新建文件夹 (2)',num2str(i)),'offset');
% mie_intensity = fitted_value1(:,7);
% base = fitted_value1(:,8);
% % load(strcat('C:\Users\16534\Desktop\温压反演\实验数据\mie_intensity\',num2str(18)),'mie_intensity');
% %% 计算瑞利峰谱线，采用较密的数据进行计算
% f = (-15:0.01:15)';
% %% 计算瑞利布里渊谱线，采用较密的数据进行计算
% Rayleigh1 =  1./(sqrt(2.*pi).*Rayleigh_linewidth).*exp(-1/2.*(f./Rayleigh_linewidth).^2);
% Brillouin1 = 1./(2.*sqrt(2.*pi).*Brillouin_linewidth).*exp(-1/2.*((f+Brillouin_shift)./Brillouin_linewidth).^2)...
% +1./(2.*sqrt(2.*pi).*Brillouin_linewidth).*exp(-1/2.*((f-Brillouin_shift)./ Brillouin_linewidth).^2);% 计算瑞利布里渊散射谱线
% %% 与器件函数卷积
% Rayleigh1 = interp1(f,Rayleigh1,freq);
% Rayleigh_convoluted = conv(Rayleigh1,Airy,'same');% 卷积函数器件展宽后的瑞利谱线
% vNew = v-offset;
% Rayleigh_convoluted = interp1(freq,Rayleigh_convoluted,v-offset);
% Rayleigh_convoluted = Rayleigh_convoluted./polyarea([min(vNew) vNew' max(vNew)],[0 Rayleigh_convoluted' 0]);
% 
% Brillouin1 = interp1(f,Brillouin1,freq);
% Brillouin_convoluted = conv(Brillouin1,Airy,'same');% 卷积函数器件展宽后的布里渊谱线
% Brillouin_convoluted = interp1(freq,Brillouin_convoluted,vNew);
% Brillouin_convoluted = Brillouin_convoluted./polyarea([min(vNew) vNew' max(vNew)],[0 Brillouin_convoluted' 0]);
% 
% Mie = interp1(freq,Airy,vNew);
% Mie = Mie./polyarea([min(vNew) vNew' max(vNew)],[0 Mie' 0]);
% 
% Rayleigh = Rayleigh_convoluted.*Rayleigh_intensity;% 乘上瑞利峰的强度，最后得到RBS谱中瑞利成分
% Brillouin = Brillouin_convoluted.*(1-Rayleigh_intensity-mie_intensity);% 乘上布里渊峰的强度，最后得到RBS谱中布里渊成分
% mie = mie_intensity.*Mie; 
% 
% RBS1 = Rayleigh+Brillouin+mie+base; % 加上米散射
% 
% RBS1Area = polyarea([min(v-offset) (v-offset)' max(v-offset)],[0 RBS1' 0]);
% RBS1 =RBS1./RBS1Area;
% 
% plot(v-offset,RBS1,'-',LineWidth=2,Marker='o')
% 
% RBS_1=RBS1;  %拟合后的含噪谱线
% % RBS_l=sptsig_convoluted; %原始理论谱线
% 
% [peak,loc] = findpeaks(RBS_1,'minpeakheight',0.05);
% y_half = 0.5*peak;
% lower_index = loc;
% upper_index = loc;
% while RBS_1(lower_index) > y_half
%   lower_index = lower_index-1;
% %      lower_index = lower_index;
% end
% while RBS_1(upper_index) > y_half
%     upper_index = upper_index+1;
%     
% end
% l = freq(upper_index)- freq(lower_index+1);
    
B_shift=B_shift_k(:);
b_wn(ih,is,:)=B_shift;


    end
end

 %%

 save b_wn b_wn