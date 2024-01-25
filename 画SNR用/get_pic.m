%% 画图程序_231204_Zoe
clc;clear;close all;
%% 导入实验数据
z=load("h.txt");  
T_1=load("T_radio.txt");
P_1=load("p_radio.txt");
L_r=load("实验线宽.txt");
beta_r=load("beta_r.mat");
beta_r=beta_r.beta_m1;

%% 导入仿真数据
% 
t=220:10:340;
p=0.1:0.1:1;
%
Sm = 8*pi/3;        % 大气分子消光后向散射比
delt_z = 30;        % 距离分辨率，m  (150m)
lambda = 532;       % 发射激光波长，nm
M = 28.959; %大气分子量
R = 8.314; %普适气体常数
P=p.*1e5;
beta_test_zhao=(0.55e-6)^4*5.45e-32/((532e-9)^4);
for i=1:length(p)
    for j=1:length(t)
        density = (p(i)*296)./(1.013e5*t(j))*2.479e25; %密度  
        beta_m(i,j)=beta_test_zhao*density;
    end
end
%
width=load("d_width.mat");
width=width.d_W;
width(6,10)=3.6522;
%% 配色设置
rgbTriplet = cell(6, 1);
rgbTriplet{1} = 0.01*round(100*[252, 41, 30;...
    250, 200, 205;...
    219, 249, 244;...
    054, 195, 201;...
    000, 070, 222]/255);
rgbTriplet{2} = 0.01*round(100*[252, 170, 103;...
    255 255 199;...
    084 134 135;...
    071 051 053;...
    189 030 030]/255);
rgbTriplet{3} = 0.01*round(100*[092 158 173;...
    210 204 161;...
    206 190 190;...
    237 177 131;...
    239 111 108]/255);
rgbTriplet{4} = 0.01*round(100*[062 043 109;...
    240 100 073;...
    255 170 050;...
    048 151 164;...
    005 080 091]/255);
rgbTriplet{5} = 0.01*round(100*[246 083 020;...
    124 187 000;...
    000 161 241;...
    255 187 000]/255);
rgbTriplet{6} = [.00 .45 .74;...
    .85 .33 .10;...
    .93 .69 .13;...
    .49 .18 .56];
%% 图1 线宽系数与高度关系
figure(1)
subplot(1,2,1)

plot(z,L_r,'linewidth',1.5);
ylim([3.2,3.5])
xlabel('Altitude to ground(km)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
ylabel('Overall linewidth(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
% title("9.3km,m=150")

subplot(1,2,2)
plot(z,beta_r,'linewidth',1.5,'Color',[1 0 0]);
xlabel('Altitude to ground(km)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
ylabel('Backscatter coefficient(m^{-1}·sr^{-1})','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
% title("7.2km,m=70")
%% 
%% 图2.1_整体线宽与温压_实验值
figure(2)
plot3(T_1,P_1,L_r,'linewidth',2)
zlim([3.2,3.5]);
xlabel('T(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
ylabel('P(bar)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
zlabel('Overall linewidth(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2);
grid on
%% 图2.2_散射系数与温压_实验值
figure(3)
plot3(T_1,P_1,beta_r,'linewidth',2)
xlabel('T(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
ylabel('P(bar)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
zlabel('Backscatter coefficient(m^{-1}·sr^{-1})','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
grid on
%% 图2.3_线宽与温压_理论值
figure(4)
[xm,ym]=meshgrid(t,p);
surf(xm,ym,width,'FaceColor','interp',...
   'EdgeColor','none',...
   'FaceLighting','phong');
xlabel('T(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
ylabel('P(bar)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
zlabel('Overall linewidth(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)

%% 图2.4_散射系数与温压_理论值
figure(5)
[xm,ym]=meshgrid(t,p);
surf(xm,ym,beta_m,'FaceColor','interp',...
   'EdgeColor','none',...
   'FaceLighting','phong');
xlabel('T(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
ylabel('P(bar)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
zlabel('Backscatter coefficient(m^{-1}·sr^{-1})','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)

%% 
%% 模型计算
a=1.33262471754984;b=247446.203513542;c=-1.16621124554099;d=12287872044.4308;e=0.338851136764152;
f=-220384.810110151;g=1.06083628602241e16;h=-3.26751933811818e-2;i=97583.483792004;j=-23933996741.8353;
%
c1=921.760477841773;c2=60026588.0759165;c3=-817.8333022530141;c4=-1820227264111.25;c5=254.38378078007;
c6=-36102814.3432035;c7=-1.21527565837046e-18;c8=-20.2849860328111;c9=2255411.27685923;c10=3299039260118.92;
%
wi=3.0:0.1:3.9;
be=1.3e-07:2e-07:2.13e-06;
%  行变系数变 列变线宽变
for i1=1:1:length(be)
    x1 = be(1,i1)
    for j1=1:1:length(wi)
        x2 = wi(1,j1)
P_fitm(i1,j1) = a+b.*x1+c.*x2+d.*x1.^2+e.*x2.^2+f.*x1.*x2+g.*x1.^3+h.*x2.^3+i.*x1.*x2.^2+j.*x1.^2.*x2;
T_fitm(i1,j1) = c1+c2.*x1+c3.*x2+c4.*x1.^2+c5.*x2.^2+c6.*x1.*x2+c7.*x1.^3+c8.*x2.^3+c9.*x1.*x2.^2+c10.*x1.^2.*x2;
    end
end
%%

%%  图3.1.1/3.1.2 纵温度_横线宽_系数线
figure(6);

x_w=3.0:0.1:3.9;

plot(x_w,T_fitm(1,:),'LineWidth',2,'Color',rgbTriplet{1}(1, :));hold on ;
plot(x_w,T_fitm(2,:),'LineWidth',2,'Color',rgbTriplet{1}(2, :));hold on ;
plot(x_w,T_fitm(3,:),'LineWidth',2,'Color',rgbTriplet{1}(3, :));hold on ;
plot(x_w,T_fitm(4,:),'LineWidth',2,'Color',rgbTriplet{1}(4, :));hold on ;
plot(x_w,T_fitm(5,:),'LineWidth',2,'Color',rgbTriplet{1}(5, :));hold on ;
plot(x_w,T_fitm(6,:),'LineWidth',2,'Color',rgbTriplet{2}(1, :));hold on ;
plot(x_w,T_fitm(7,:),'LineWidth',2,'Color',rgbTriplet{2}(2, :));hold on ;
plot(x_w,T_fitm(8,:),'LineWidth',2,'Color',rgbTriplet{2}(3, :));hold on ;
plot(x_w,T_fitm(9,:),'LineWidth',2,'Color',rgbTriplet{2}(4, :));hold on ;
plot(x_w,T_fitm(10,:),'LineWidth',2,'Color',rgbTriplet{2}(5, :));hold on ;
plot(x_w,T_fitm(11,:),'LineWidth',2,'Color',rgbTriplet{3}(5, :));hold on ;

set(gca,'FontSize',15,'LineWidth',1.2,'FontName','Times New Roman');
xlabel('Overall linewidth(GHz)','fontsize',15,'FontName','Times New Roman');ylabel('T(K)','fontsize',15,'FontName','Times New Roman');
legend({['\beta=',num2str(be(1,1)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,2)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,3)),' m^{-1}·sr^{-1}'], ...
    ['\beta=',num2str(be(1,4)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,5)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,6)),' m^{-1}·sr^{-1}'], ...
    ['\beta=',num2str(be(1,7)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,8)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,9)),' m^{-1}·sr^{-1}'], ...
    ['\beta=',num2str(be(1,10)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,11)),' m^{-1}·sr^{-1}']},'Orientation','vertical');
set(legend,'Location','NorthEastOutside','FontSize',10,'Box','off','FontName','Times New Roman');

xlim([3.0,3.9]);
xticks(3.0:0.3:3.9);
ylim([180,400]);
yticks(180:40:400);

grid on
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperSize',[28,11.4])
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition',[0,0,28,11.4]);
set(gcf,'Renderer','painters');
%%
%% 图3.2.1/3.2.2 纵温度_横系数_线宽线
figure(7);

x_b=1.3e-01:2e-01:2.13;

plot(x_b,T_fitm(:,1),'LineWidth',2,'Color',rgbTriplet{1}(1, :));hold on ;
plot(x_b,T_fitm(:,2),'LineWidth',2,'Color',rgbTriplet{1}(2, :));hold on ;
plot(x_b,T_fitm(:,3),'LineWidth',2,'Color',rgbTriplet{1}(3, :));hold on ;
plot(x_b,T_fitm(:,4),'LineWidth',2,'Color',rgbTriplet{1}(4, :));hold on ;
plot(x_b,T_fitm(:,5),'LineWidth',2,'Color',rgbTriplet{1}(5, :));hold on ;
plot(x_b,T_fitm(:,6),'LineWidth',2,'Color',rgbTriplet{2}(1, :));hold on ;
plot(x_b,T_fitm(:,7),'LineWidth',2,'Color',rgbTriplet{2}(2, :));hold on ;
plot(x_b,T_fitm(:,8),'LineWidth',2,'Color',rgbTriplet{2}(3, :));hold on ;
plot(x_b,T_fitm(:,9),'LineWidth',2,'Color',rgbTriplet{2}(4, :));hold on ;
plot(x_b,T_fitm(:,10),'LineWidth',2,'Color',rgbTriplet{2}(5, :));hold on ;


set(gca,'FontSize',15,'LineWidth',1.2,'FontName','Times New Roman');
xlabel('Backscatter coefficient(m^{-1}·sr^{-1}x10^{-6})','fontsize',15,'FontName','Times New Roman');ylabel('P(bar)','fontsize',15,'FontName','Times New Roman');

% legend({'\itl=3.0 GHz',['\itl=',num2str(wi(1,2)),' GHz'],['\itl=',num2str(wi(1,3)),' GHz'],['\itl=',num2str(wi(1,4)),' GHz'],['\itl=',num2str(wi(1,5)),' GHz'], ...
%     ['\itl=',num2str(wi(1,6)),' GHz'],['\itl=',num2str(wi(1,7)),' GHz'],['\itl=',num2str(wi(1,8)),' GHz'],['\itl=',num2str(wi(1,9)),' GHz'], ...
%     ['\itl=',num2str(wi(1,10)),' GHz']},'Orientation','vertical');
% set(legend,'Location','NorthEastOutside','FontSize',10,'Box','off','FontName','Times New Roman');


xlim([1.1e-01,2.14]);
xticks(1.1e-01:4e-01:2.14);
yticks(160:40:400);

grid on
%设置输出的图的大小
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperSize',[28,11.4])
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition',[0,0,28,11.4]);
set(gcf,'Renderer','painters');

%%
%% 图3.3.1/3.3.2 纵压强_横线宽_系数线
figure(8);

x_w=3.0:0.1:3.9;
%需要画的线；'LineWidth'设置线宽,'Color'设置颜色（QQ的截图功能可以当取色器用）;'LineStyle'更改线型
plot(x_w,P_fitm(1,:),'LineWidth',2,'Color',rgbTriplet{1}(1, :));hold on ;
plot(x_w,P_fitm(2,:),'LineWidth',2,'Color',rgbTriplet{1}(2, :));hold on ;
plot(x_w,P_fitm(3,:),'LineWidth',2,'Color',rgbTriplet{1}(3, :));hold on ;
plot(x_w,P_fitm(4,:),'LineWidth',2,'Color',rgbTriplet{1}(4, :));hold on ;
plot(x_w,P_fitm(5,:),'LineWidth',2,'Color',rgbTriplet{1}(5, :));hold on ;
plot(x_w,P_fitm(6,:),'LineWidth',2,'Color',rgbTriplet{2}(1, :));hold on ;
plot(x_w,P_fitm(7,:),'LineWidth',2,'Color',rgbTriplet{2}(2, :));hold on ;
plot(x_w,P_fitm(8,:),'LineWidth',2,'Color',rgbTriplet{2}(3, :));hold on ;
plot(x_w,P_fitm(9,:),'LineWidth',2,'Color',rgbTriplet{2}(4, :));hold on ;
plot(x_w,P_fitm(10,:),'LineWidth',2,'Color',rgbTriplet{2}(5, :));hold on ;
plot(x_w,P_fitm(11,:),'LineWidth',2,'Color',rgbTriplet{3}(5, :));hold on ;


set(gca,'FontSize',15,'LineWidth',1.2,'FontName','黑体');

xlabel('Overall linewidth(GHz)','fontsize',15,'FontName','Times New Roman');ylabel('P(bar)','fontsize',15,'FontName','Times New Roman');

% legend({['\beta=',num2str(be(1,1)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,2)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,3)),' m^{-1}·sr^{-1}'], ...
%     ['\beta=',num2str(be(1,4)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,5)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,6)),' m^{-1}·sr^{-1}'], ...
%     ['\beta=',num2str(be(1,7)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,8)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,9)),' m^{-1}·sr^{-1}'], ...
%     ['\beta=',num2str(be(1,10)),' m^{-1}·sr^{-1}'],['\beta=',num2str(be(1,11)),' m^{-1}·sr^{-1}']},'Orientation','vertical');
% set(legend,'Location','NorthEastOutside','FontSize',10,'Box','off','FontName','黑体');

xlim([3.0,3.9]);
xticks(3.0:0.3:3.9);
ylim([0,1.6]);
yticks(0:0.4:1.6);

grid on
%设置输出的图的大小
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperSize',[28,11.4])
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition',[0,0,28,11.4]);
set(gcf,'Renderer','painters');
%%
%% 图3.4.1/3.4.2 纵压强_横系数_线宽线

figure(9);

x_b=1.3e-01:2e-01:2.13;
%需要画的线；'LineWidth'设置线宽,'Color'设置颜色（QQ的截图功能可以当取色器用）;'LineStyle'更改线型
plot(x_b,P_fitm(:,1),'LineWidth',2,'Color',rgbTriplet{1}(1, :));hold on ;
plot(x_b,P_fitm(:,2),'LineWidth',2,'Color',rgbTriplet{1}(2, :));hold on ;
plot(x_b,P_fitm(:,3),'LineWidth',2,'Color',rgbTriplet{1}(3, :));hold on ;
plot(x_b,P_fitm(:,4),'LineWidth',2,'Color',rgbTriplet{1}(4, :));hold on ;
plot(x_b,P_fitm(:,5),'LineWidth',2,'Color',rgbTriplet{1}(5, :));hold on ;
plot(x_b,P_fitm(:,6),'LineWidth',2,'Color',rgbTriplet{2}(1, :));hold on ;
plot(x_b,P_fitm(:,7),'LineWidth',2,'Color',rgbTriplet{2}(2, :));hold on ;
plot(x_b,P_fitm(:,8),'LineWidth',2,'Color',rgbTriplet{2}(3, :));hold on ;
plot(x_b,P_fitm(:,9),'LineWidth',2,'Color',rgbTriplet{2}(4, :));hold on ;
plot(x_b,P_fitm(:,10),'LineWidth',2,'Color',rgbTriplet{2}(5, :));hold on ;

set(gca,'FontSize',15,'LineWidth',1.2,'FontName','Times New Roman');
xlabel('Backscatter coefficient(m^{-1}·sr^{-1}x10^{-6})','fontsize',15,'FontName','Times New Roman');ylabel('P(bar)','fontsize',15,'FontName','Times New Roman');

% legend({'\itl=3.0 GHz',['\itl=',num2str(wi(1,2)),' GHz'],['\itl=',num2str(wi(1,3)),' GHz'],['\itl=',num2str(wi(1,4)),' GHz'],['\itl=',num2str(wi(1,5)),' GHz'], ...
%     ['\itl=',num2str(wi(1,6)),' GHz'],['\itl=',num2str(wi(1,7)),' GHz'],['\itl=',num2str(wi(1,8)),' GHz'],['\itl=',num2str(wi(1,9)),' GHz'], ...
%     ['\itl=',num2str(wi(1,10)),' GHz']},'Orientation','vertical');
% set(legend,'Location','NorthEastOutside','FontSize',10,'Box','off','FontName','Times New Roman');

xlim([1.1e-01,2.14]);
xticks(1.1e-01:4e-01:2.14);
ylim([0,1.6]);
yticks(0:0.4:1.6);

grid on
%设置输出的图的大小
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperSize',[28,11.4])
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition',[0,0,28,11.4]);
set(gcf,'Renderer','painters');