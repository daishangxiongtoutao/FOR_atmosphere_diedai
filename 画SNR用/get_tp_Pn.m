%% 0421该程序用于反演温压参数及画图(确定版)
clc;clear
%% 加载实验线宽、后向散射系数、温度压强
z=load("h.txt");  
T_1=load("T_radio.txt");
P_1=load("p_radio.txt");
L_r=load("实验线宽.txt");
beta_r=load("beta_r.mat");
beta_r=beta_r.beta_m1;
%% 加载仿真线宽、后向散射系数、温度压强
width=load("d_width.mat");
width=width.d_W;
width_new=width(:);%仿真线宽
beta_m=load("beta_m.mat");
beta_m=beta_m.beta_1;%仿真系数
tem=220:10:340;
tem_plus=ones(10,1)*tem;
tem_plus=tem_plus(:);
press=0.1:0.1:1;
press_plus=ones(13,1)*press;
press_plus=press_plus';
press_plus=press_plus(:);
%% 反演压强
a=1.33262471754984;b=247446.203513542;c=-1.16621124554099;d=12287872044.4308;e=0.338851136764152;
f=-220384.810110151;g=1.06083628602241e16;h=-3.26751933811818e-2;i=97583.483792004;j=-23933996741.8353;
%90个数据的反演参数
% a=-0.124269345347001;b=0.130347339658258;c=2.04384987317738e-2;d=-0.046370297165068;e=-1.46408216969334e-4;
% f=-1.77710548062045e-2;g=5.5562502848551e-3;h=8.40898970490969e-6;i=-1.32070308707281e-4;j=8.59310189656512e-3;
% a=-2.36688485799383;b=2.23078633915238;c=-5.78275857086553e-2;d=-0.700227563549282;e=-7.25072766542618e-4;
% f=2.91480709914713e-2;g=7.32089510657127e-2;h=8.88661687523787e-6;i=2.080225531119956e-5;j=1.59311228312266e-3;
% x1=beta_m; %仿真系数
% x2=width_new;%仿真线宽
% P_fit = a+b.*x1+c.*x2+d.*x1.^2+e.*x2.^2+f.*x1.*x2+g.*x1.^3+h.*x2.^3+i.*x1.*x2.^2+j.*x1.^2.*x2;
%  E_P_m=P_fit-press_plus;
%  E_P_m_max=max(abs(E_P_m)./press_plus).*100
%  E_P_m_mean=mean(abs(E_P_m)./press_plus).*100

x1=beta_r'; %系数
x2=L_r;%仿真线宽
P_fit = a+b.*x1+c.*x2+d.*x1.^2+e.*x2.^2+f.*x1.*x2+g.*x1.^3+h.*x2.^3+i.*x1.*x2.^2+j.*x1.^2.*x2;

%  误差
E_P=P_fit-P_1;
E_P_r=E_P./P_1.*100;
E_P_r_max=max(abs(E_P_r));% 13.4142%
E_P_r_mean=mean(abs(E_P_r));% 7.8934

%% 反演温度
c1=921.760477841773;c2=60026588.0759165;c3=-817.8333022530141;c4=-1820227264111.25;c5=254.38378078007;
c6=-36102814.3432035;c7=-1.21527565837046e-18;c8=-20.2849860328111;c9=2255411.27685923;c10=3299039260118.92;
% %理论仿真
% % x1=beta_m; %仿真系数
% % x2=width_new;%仿真线宽
% T_fit = c1+c2.*x1+c3.*x2+c4.*x1.^2+c5.*x2.^2+c6.*x1.*x2+c7.*x1.^3+c8.*x2.^3+c9.*x1.*x2.^2+c10.*x1.^2.*x2;
% %  理论误差
%  E_T_m=T_fit-tem_plus;
%  E_T_m_max=max(abs(E_T_m))
%  E_T_m_mean=mean(abs(E_T_m))

%实验验证
x1=beta_r'; 
x2=L_r;%
T_fit = c1+c2.*x1+c3.*x2+c4.*x1.^2+c5.*x2.^2+c6.*x1.*x2+c7.*x1.^3+c8.*x2.^3+c9.*x1.*x2.^2+c10.*x1.^2.*x2;

%实验误差
E_T_r=T_fit-T_1;
E_T_r_max=max(abs(E_T_r));%4.419639509765148
E_T_r_mean=mean(abs(E_T_r));%1.496439671335802


%% 画温度反演图
%两温度线
figure
set(gcf,'Position',[200 100 1000 600]);% 设置绘图的大小，，图的大小是7cm
set(gca,'Position',[.13 .17 .80 .74]);
pos1 = [0.1 0.2 0.6 0.7];
subplot('Position',pos1)
% h=errorbar(t_mean,rr,t_dev_mean,'horizontal','r-o','linewidth',1.5,'markerfacecolor','r','markersize',5);hold on
f1=plot(T_1,z,'b-','linewidth',1.5,'markerfacecolor','b','markersize',5);hold on;
f2=plot(T_fit,z,'r-','linewidth',1.5,'markerfacecolor','r','markersize',5);
ylabel('高度（km）','Fontsize',15,'FontWeight','bold','FontName','黑体'); 
xlabel('温度（K）','Fontsize',15,'FontWeight','bold','FontName','黑体');
box on
axis([235 275 4.5 9.5])
set(gca,'FontName','黑体','FontSize',12,'fontweight','bold','linewidth',1.2)
legend('探空温度','反演温度')
grid on
hold on
%温度误差线
pos2 = [0.8 0.2 0.15 0.7];
subplot('Position',pos2)
% h=errorbar(t_error_mean,rr,t_dev_mean,'horizontal','color',rgb,'linestyle','-','marker','o','linewidth',1.5,'markerfacecolor',rgb,'markersize',5);
% hold on
f1=plot(E_T_r,z,'color','r','linestyle','-','linewidth',1.5,'markerfacecolor','b','markersize',5);hold on;
xlabel('温度误差（K）','Fontsize',15,'fontname','Times','fontweight','bold')
box on
axis([-5 5 4.5 9.5])
set(gca,'FontName','黑体','FontSize',12,'fontweight','bold','linewidth',1.2)
grid on
hold on
line([0 0],[0 11],'color','k','linestyle','--','linewidth',2.5)
legend('温度误差')

%%
%% 画压强反演图
figure
set(gcf,'Position',[200 100 1000 600]);% 设置绘图的大小，，图的大小是7cm
set(gca,'Position',[.13 .17 .80 .74]);
pos1 = [0.1 0.2 0.6 0.7];
subplot('Position',pos1)
% h=errorbar(t_mean,rr,t_dev_mean,'horizontal','r-o','linewidth',1.5,'markerfacecolor','r','markersize',5);hold on
f1=plot(P_1,z,'b-','linewidth',1.5,'markerfacecolor','b','markersize',5);hold on;
f2=plot(P_fit,z,'r-','linewidth',1.5,'markerfacecolor','r','markersize',5);
ylabel('高度（km）','Fontsize',15,'FontWeight','bold','FontName','黑体'); 
xlabel('压强（bar）','Fontsize',15,'FontWeight','bold','FontName','黑体');
box on
axis([0.25 0.6 4.5 9.5])
set(gca,'FontName','黑体','FontSize',12,'fontweight','bold','linewidth',1.2)
legend('探空温度','反演温度')
grid on
hold on
%压强误差线
pos2 = [0.8 0.2 0.15 0.7];
subplot('Position',pos2)
% h=errorbar(t_error_mean,rr,t_dev_mean,'horizontal','color',rgb,'linestyle','-','marker','o','linewidth',1.5,'markerfacecolor',rgb,'markersize',5);
% hold on
f1=plot(E_P_r,z,'color','r','linestyle','-','linewidth',1.5,'markerfacecolor','b','markersize',5);hold on;
xlabel('压强相对误差（%）','Fontsize',15,'fontname','Times','fontweight','bold')
box on
axis([-10 10 4.5 9.5])
set(gca,'FontName','黑体','FontSize',12,'fontweight','bold','linewidth',1.2)
grid on
hold on
line([0 0],[0 11],'color','k','linestyle','--','linewidth',2.5)
legend('压强误差')

save T_rfit T_fit
save P_rfit P_fit