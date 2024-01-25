%% �ó������������㷨���ร�����㷨�������ڼ������ĳ���
function l = cal_3gaussian(fitted_value1)
%% �������߲�����ز�����ֵ
Brillouin_shift = fitted_value1(:,1);% ����ԨƵ��
Rayleigh_linewidth = fitted_value1(:,2);% �����߿�
Brillouin_linewidth = fitted_value1(:,3);% ����Ԩ�߿�
Rayleigh_intensity = fitted_value1(:,4);% ����ǿ��
scale_factor = fitted_value1(:,5); % scale_factor
offset = fitted_value1(:,6);
%% �������������ߣ����ý��ܵ����ݽ��м���
f = (-15:0.001:15)';
%% ������������Ԩ���ߣ����ý��ܵ����ݽ��м���
Rayleigh1 =  1./(sqrt(2.*pi).*Rayleigh_linewidth).*exp(-1/2.*(f./Rayleigh_linewidth).^2);
Brillouin1 = 1./(2.*sqrt(2.*pi).*Brillouin_linewidth).*exp(-1/2.*((f+Brillouin_shift)./Brillouin_linewidth).^2)...
+1./(2.*sqrt(2.*pi).*Brillouin_linewidth).*exp(-1/2.*((f-Brillouin_shift)./ Brillouin_linewidth).^2);% ������������Ԩɢ������
%% �������������
% Rayleigh1 = interp1(f,Rayleigh1,freq1);
% Rayleigh_convoluted = conv(Rayleigh1,Airy1,'same');% �����������չ������������
% Rayleigh_convoluted = Rayleigh_convoluted./polyarea([min(freq1) freq1' max(freq1)],[0 Rayleigh_convoluted' 0]);
% Brillouin1 = interp1(f,Brillouin1,freq1);
% Brillouin_convoluted = conv(Brillouin1,Airy1,'same');% �����������չ���Ĳ���Ԩ����
% Brillouin_convoluted = Brillouin_convoluted./polyarea([min(freq1) freq1' max(freq1)],[0 Brillouin_convoluted' 0]);
Rayleigh = Rayleigh1.*Rayleigh_intensity;% �����������ǿ�ȣ����õ�RBS���������ɷ�
Brillouin = Brillouin1.*(1-Rayleigh_intensity);% ���ϲ���Ԩ���ǿ�ȣ����õ�RBS���в���Ԩ�ɷ�
RBS = Rayleigh+Brillouin;
load v1.mat
load f_mol.mat
RBS1 = interp1(f,RBS,v1-offset);
RBS1 = scale_factor.*RBS1;

figure
plot(v1,RBS1,'r--',v1,f_mol,'b')
% legend('RBS-g3','Rayleigh','Brillouin','RBS-s6')
% saveas(gcf,['C:/Users/16534/Desktop/��ѹ����/ʵ������/k=1/���Ч��ͼ/',num2str(i),'_2.fig']);

% figure
% plot(v22,S22,'.r',v22,RBS1,'b')
% legend('ɢ�����','g3�������')
% saveas(gcf,['C:/Users/16534/Desktop/��ѹ����/ʵ������/dataRayleigh_ave/k=29/���Ч��ͼ/',num2str(i+149),'.fig']);

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