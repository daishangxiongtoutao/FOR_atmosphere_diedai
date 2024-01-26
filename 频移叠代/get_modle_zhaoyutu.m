%% 本程序为利用线宽和布里渊频移反演大气温压
clc;clear;
%%    单参数模型(他是150长的)
T_fitr2_dan=load("T_76_r.mat");
T_r_dan=load("t_T_radio.txt");
T2_dan=T_fitr2_dan.T_fit_76;
E2_dan=T2_dan-T_r_dan;
T2_dan=T2_dan(1:120);
E2_dan=E2_dan(1:120);

P1_dan=load("P_fitr.mat");
P_r_dan=load('t_p_radio.txt');
P1_dan=P1_dan.P_fitr;
E1_dan=(P1_dan-P_r_dan);
%E1_dan=(P1_dan-P_r_dan)./P_r_dan.*100;
% P1_dan=P1_dan(1:120);
% E1_dan=E1_dan(1:120);
%%    太子模型(他是150长的)
T_fitr2_tai=load("taizi.mat");
T2_tai=T_fitr2_tai.ERet_t;
E2_tai=T_fitr2_tai.Exp_dt;
T2_tai=T2_tai(1:120);
E2_tai=E2_tai(1:120);


P1_tai=T_fitr2_tai.ERet_p;
P_r_tai=T_fitr2_tai.Exp_dp1;
%E1_tai=(P1_tai-P_r_tai)./P_r_tai.*100;
E1_tai=P_r_tai;
%% 240107画图
% %%
% load d_width.mat
%  w_modle=d_W;%仿真线宽 220-340，0.1-1；每一列温度相同
%  w_m=w_modle(:); %每十个变一次温度
% %
% for T=220:10:340
%     for P=0.1:0.1:1
% ii=round(P*10)
% jj=round((T-210)/10)
%  shift(ii,jj)=s6_shift(T,P);
%     end
% end
% shift_m=shift./1e9;
% T=220:10:340;
% P=0.1:0.1:1;
% 
% %%
% figure(1)
% [xm,ym]=meshgrid(T,P);
% surf(xm,ym,shift_m,'FaceColor','interp',...
%    'EdgeColor','none',...
%    'FaceLighting','phong');
% xlabel('T(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
% ylabel('P(bar)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% zlabel('Brillouin Shift(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
% 
% 
% figure(2)
% [xm,ym]=meshgrid(T,P);
% surf(xm,ym,w_modle,'FaceColor','interp',...
%    'EdgeColor','none',...
%    'FaceLighting','phong');
% xlabel('T(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
% ylabel('P(bar)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% zlabel('Overall linewidth(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
%% 240107画图结束
%%
% shift_m=shift(:)./1e9;
% %
% for T=220:10:340
%     for P=0.1:0.1:1
%    ii=round(P*10);
%    jj=round((T-210)/10);
%    tt(ii,jj)=T;
%    pp(ii,jj)=P;
%     end
% end
% T_m=tt(:);
% p_m=pp(:);


%%
% load shift_kr.mat
% shift_r=k3;
% load d_L_r.mat
% w_r=L;
load t_T_radio.txt;
T_r=t_T_radio;
load t_p_radio.txt;
p_r=t_p_radio;
h=load("t_h.txt");
z=h;
%%
% % load w_rm;
% % w_rm=w_rm';
% load d_L_r.mat
% w_r=L;
%%
% plot(w_rm,LineWidth=1.5);
% hold on;
% plot(w_r,LineWidth=1.5);
% l2=legend("理论线宽值","实际线宽值");
%%
load X;
X=X';
load wr_k;
w_r=k_width;
%%
% x1线宽，x2频移
% load k_mean.mat
%% 温度反演
a=41.0844102923224;b=-230.588056627951;c=547.364549159805;d=350.473505752583;e=1976.15948463226;
f=-1596.17421479092;g=-162.363644225841;h=1774.72211467052;i=-2409.87107048159;j=1086.25620553135;

x1= w_r; %线宽
x2=X;%频移
% x2=shift_m;
T_fit = a+b.*x1+c.*x2+d.*x1.^2+e.*x2.^2+f.*x1.*x2+g.*x1.^3+h.*x2.^3+i.*x1.*x2.^2+j.*x1.^2.*x2;
%  误差
 E_T=T_fit-T_r;
%%
% %% 压强反演  模型的误差主要依赖线宽
%  a1=-10.6943716004068;b1=81.2377797575397;c1=-196.036280060873;d1=-100.719733812367;e1=-420.832990801593;
%  f1=420.919678739869;g1=42.3136344885692;h1=-393.287798187595;i1=554.760365714989;j1=-265.014515217489;
% % 
% x1= w_r; %线宽
% x2=X;%频移
% % x2=k_mean;
%  P1 = a1+b1.*x1+c1.*x2+d1.*x1.^2+e1.*x2.^2+f1.*x1.*x2+g1.*x1.^3+h1.*x2.^3+i1.*x1.*x2.^2+j1.*x1.^2.*x2;
% % 
% % %  误差
%  E1=(P1-p_r)./p_r.*100;
 
 %% 压强反演
 a11=-889.566191692863;b11=939.992753966374;c11=-2468.30557239844;d11=-331.797840489051;e11=-2190.83220039963;
 f11=1728.8606256016;g11=39.1308945885444;h11=-641.812783922014;i11=765.3011256711;j11=-303.498502814097;
% 
x1= w_r; %仿真线宽
x2=X;
 P2 = a11+b11.*x1+c11.*log(x2)+d11.*x1.^2+e11.*log(x2).^2+f11.*x1.*log(x2)+g11.*x1.^3+h11.*log(x2).^3+i11.*x1.*log(x2).^2+j11.*x1.^2.*log(x2);
% %  误差
%  E2=(P2-p_r)./p_r.*100;
E2=P2-p_r;

%%
T_fit1=T_fit(1:120,:);
T_r1=T_r(1:120,:);
z1=z(1:120,:);
E_T1=E_T(1:120,:);

%%
figure
set(gcf,'Position',[200 100 1000 600]);% 设置绘图的大小，图的大小是7cm
set(gca,'Position',[.13 .17 .80 .74]);
pos1 = [0.1 0.2 0.6 0.7];
subplot('Position',pos1)
% h=errorbar(t_mean,rr,t_dev_mean,'horizontal','r-o','linewidth',1.5,'markerfacecolor','r','markersize',5);hold on
f1=plot(T_fit1,z1,'b-','linewidth',2,'Color',"r",'markersize',5);hold on;
% f2=plot(T2_tai,z1,'linewidth',2,'markersize',5);hold on;
f3=plot(T2_dan,z1,'linewidth',2,'markersize',5);hold on;
f4=plot(T_r1,z1,'r-','linewidth',2,'Color',"b",'markersize',5);
ylabel('Height(km)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman'); 
xlabel('Temperature(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
box on
axis([235 275 4.5 8.5])
set(gca,'FontName','Times New Roman','FontSize',15,'fontweight','bold','linewidth',1.2)
legend('Model1 inversion results','Model2 inversion results','Sonde sounding data','Box','off','FontSize',12)

grid on
hold on
%温度误差线
pos2 = [0.8 0.2 0.15 0.7];
subplot('Position',pos2)
% h=errorbar(t_error_mean,rr,t_dev_mean,'horizontal','color',rgb,'linestyle','-','marker','o','linewidth',1.5,'markerfacecolor',rgb,'markersize',5);
% hold on
f1=plot(E_T1,z1,'Color',"r",'linestyle','-','linewidth',2,'markerfacecolor','b','markersize',5);hold on;
% f2=plot(E2_tai,z1,'linestyle','-','linewidth',2,'markersize',5);hold on;
f3=plot(E2_dan,z1,'linestyle','-','linewidth',2,'markersize',5);hold on;
xlabel('Temperature Error(K)','Fontsize',14,'fontname','Times','fontweight','bold')
box on
axis([-4.5 4.5 4.5 8.5])
set(gca,'FontName','黑体','FontSize',14,'fontweight','bold','linewidth',1.2)
grid on
hold on
line([0 0],[0 11],'Color',"b",'linestyle','--','linewidth',2.5)
% legend('温度误差')
%%
figure
set(gcf,'Position',[200 100 1000 600]);% 设置绘图的大小，，图的大小是7cm
set(gca,'Position',[.13 .17 .80 .74]);
pos1 = [0.1 0.2 0.6 0.7];
subplot('Position',pos1)
% h=errorbar(t_mean,rr,t_dev_mean,'horizontal','r-o','linewidth',1.5,'markerfacecolor','r','markersize',5);hold on
% f1=plot(P1,z,'b-','linewidth',2,'Color',rgbTriplet{5}(1, :),'markersize',5);hold on;
f2=plot(P2,z,'b-','linewidth',2,'Color',"r",'markersize',5);hold on;
% f1=plot(P1_tai,z,'linewidth',2,'markersize',5);hold on;
%f4=plot(P1_dan,z,'linewidth',2,'markersize',5);hold on;
f3=plot(p_r,z,'r-','linewidth',2,'Color',"b",'markersize',5);
ylabel('Height(km)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman'); 
xlabel('Pressure(bar)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
box on
axis([0.25 0.55 4.5 9.5])
set(gca,'FontName','Times New Roman','FontSize',14,'fontweight','bold','linewidth',1.2)
legend('Model1 inversion results','Sonde sounding data','box','off','FontSize',12)
grid on
hold on

%压强误差线
pos2 = [0.8 0.2 0.15 0.7];
subplot('Position',pos2)
% h=errorbar(t_error_mean,rr,t_dev_mean,'horizontal','color',rgb,'linestyle','-','marker','o','linewidth',1.5,'markerfacecolor',rgb,'markersize',5);
% hold on
% f1=plot(E1,z,'Color',rgbTriplet{5}(1, :),'linestyle','-','linewidth',2,'markerfacecolor','b','markersize',5);hold on;
f1=plot(E2,z,'Color',"r",'linestyle','-','linewidth',2,'markerfacecolor','b','markersize',5);hold on;
% f2=plot(E1_tai,z,'linestyle','-','linewidth',2,'markersize',5);hold on;
% f3=plot(E1_dan,z,'linestyle','-','linewidth',2,'markersize',5);hold on;

xlabel('Pressure Error(bar)','Fontsize',14,'fontname','Times','fontweight','bold')
box on
% axis([-25 25 4.5 9.5])
axis([-0.125 0.125 4.5 9.5])
%  xtickformat('percentage')
set(gca,'FontName','Times New Roman','FontSize',14,'fontweight','bold','linewidth',1.2)
grid on
hold on
line([0 0],[0 11],'Color',"b",'linestyle','--','linewidth',2.5)
