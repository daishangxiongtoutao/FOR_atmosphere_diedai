%% 画图程序_240108_Zoe
clc;clear;close all;


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

%% 导入仿真数据
load d_width.mat ;%仿真线宽 
load bshift_wn.mat; %带噪频移

H=4.8:0.03:9.3;
for H_n=1:1:length(H)
   [T,P]=USA76(H(H_n));
   T_m(H_n,:)=T;
   P_m(H_n,:)=P;
end
%% 仿真
x_w= d_W; %线宽
x_b= bshift_wn;%频移

for k_snr=1:1:31  %20:50
x1=x_w(:);
x2=x_b(k_snr,:)';
% 温度反演
a=41.0844102923224;b=-230.588056627951;c=547.364549159805;d=350.473505752583;e=1976.15948463226;
f=-1596.17421479092;g=-162.363644225841;h=1774.72211467052;i=-2409.87107048159;j=1086.25620553135;

T_fit = a+b.*x1+c.*x2+d.*x1.^2+e.*x2.^2+f.*x1.*x2+g.*x1.^3+h.*x2.^3+i.*x1.*x2.^2+j.*x1.^2.*x2;
%  误差
 E_T1=T_fit-T_m;
 E_T(k_snr,:)=E_T1';
 % 压强反演
 a11=-889.566191692863;b11=939.992753966374;c11=-2468.30557239844;d11=-331.797840489051;e11=-2190.83220039963;
 f11=1728.8606256016;g11=39.1308945885444;h11=-641.812783922014;i11=765.3011256711;j11=-303.498502814097;

 P2 = a11+b11.*x1+c11.*log(x2)+d11.*x1.^2+e11.*log(x2).^2+f11.*x1.*log(x2)+g11.*x1.^3+h11.*log(x2).^3+i11.*x1.*log(x2).^2+j11.*x1.^2.*log(x2);
% %  误差
%  E2=(P2-p_r)./p_r.*100;
% E2=P2-P_m;
E_P1=(P2-P_m)./P_m.*100;
E_P(k_snr,:)=E_P1';
end
%%
E_T_abs=abs(E_T);
E_P_abs=abs(E_P);

%%
E_T_m=reshape(E_T,10,13);
E_P_m=reshape(E_P,10,13);
%%
% max(E_T)  0.0561
% mean(E_T) -5.4126e-04
% max(E_P)   5.9670%
% mean(E_P)  0.5705%
%% 图1 温度误差三维图
T=220:10:340;
P=0.1:0.1:1;
figure(1)
[xm,ym]=meshgrid(T,P);
surf(xm,ym,E_T_m,'FaceColor','interp',...
   'EdgeColor','none',...
   'FaceLighting','phong');
xlabel('T(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
ylabel('P(bar)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
zlabel('Temperature Error(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
%% 图2 压强误差三维图
figure(2)
[xm,ym]=meshgrid(T,P);
surf(xm,ym,E_P_m,'FaceColor','interp',...
   'EdgeColor','none',...
   'FaceLighting','phong');
xlabel('T(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
ylabel('P(bar)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
zlabel('Relative Error of Pressure','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
ztickformat('percentage')
set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)

%%

% %% 
%% 模型计算
 % 温度
a=41.0844102923224;b=-230.588056627951;c=547.364549159805;d=350.473505752583;e=1976.15948463226;
f=-1596.17421479092;g=-162.363644225841;h=1774.72211467052;i=-2409.87107048159;j=1086.25620553135;

% 压强
 c1=-889.566191692863;c2=939.992753966374;c3=-2468.30557239844;c4=-331.797840489051;c5=-2190.83220039963;
 c6=1728.8606256016;c7=39.1308945885444;c8=-641.812783922014;c9=765.3011256711;c10=-303.498502814097;
%
wi=3.06:0.06:3.6;
% be=1.3e-07:2e-07:2.13e-06;
% be=1.1:0.03:1.4;
be=1.14:0.01:1.24;
%  行变线宽变 列变频移变
for i1=1:1:length(wi)
    x1 = wi(1,i1)
    for j1=1:1:length(be)
        x2 = be(1,j1)
T_fitm(i1,j1) = a+b.*x1+c.*x2+d.*x1.^2+e.*x2.^2+f.*x1.*x2+g.*x1.^3+h.*x2.^3+i.*x1.*x2.^2+j.*x1.^2.*x2;
P_fitm(i1,j1) = c1+c2.*x1+c3.*x2+c4.*x1.^2+c5.*x2.^2+c6.*x1.*x2+c7.*x1.^3+c8.*x2.^3+c9.*x1.*x2.^2+c10.*x1.^2.*x2;
    % 温度关于线宽（x1）
     T_xm(i1,j1) = b+2.*d.*x1++f.*x2+3.*g.*x1.^2+i.*x2.^2+2.*j.*x1.*x2;
    % 温度关于频移（x2）
      T_bm(i1,j1)= c+2.*e.*x2+f.*x1+3.*h.*x2.^2+2*i.*x1.*x2+j.*x1.^2; 
      % 压强关于线宽（x1）
        P_xm(i1,j1) = c2+2.*c4.*x1++c6.*x2+3.*c7.*x1.^2+c9.*x2.^2+2.*c10.*x1.*x2;
       % 压强关于频移（x2）
     P_bm(i1,j1)= c3+2.*c5.*x2+c6.*x1+3.*c8.*x2.^2+2*c9.*x1.*x2+c10.*x1.^2;
    end
end
%% 温度关于线宽（x1）
%  max :345.0045 
% min:0.0370 
% mean :63.4824
% 温度关于频移（x2）
%  1.2608e+03   
% 387.1704 
% 581.5323

%%
% 压强关于线宽（x1）
% 1.3767e+03 
% 361.2562 
% 803.6109
% 压强关于频移（x2）
% -3.4929e+03  
% 925.2889   
% 2.0434e+03

% mean(P_xm(:))
%%  图3.1.1/3.1.2 纵温度_横线宽_频移线
figure(6);

% x_w=3.0:0.1:3.9;
x_w=3.06:0.06:3.6;
plot(x_w,T_fitm(:,1),'LineWidth',2,'Color',rgbTriplet{1}(1, :));hold on ;
plot(x_w,T_fitm(:,2),'LineWidth',2,'Color',rgbTriplet{1}(2, :));hold on ;
plot(x_w,T_fitm(:,3),'LineWidth',2,'Color',rgbTriplet{1}(3, :));hold on ;
plot(x_w,T_fitm(:,4),'LineWidth',2,'Color',rgbTriplet{1}(4, :));hold on ;
plot(x_w,T_fitm(:,5),'LineWidth',2,'Color',rgbTriplet{1}(5, :));hold on ;
plot(x_w,T_fitm(:,6),'LineWidth',2,'Color',rgbTriplet{2}(1, :));hold on ;
plot(x_w,T_fitm(:,7),'LineWidth',2,'Color',rgbTriplet{2}(2, :));hold on ;
plot(x_w,T_fitm(:,8),'LineWidth',2,'Color',rgbTriplet{2}(3, :));hold on ;
plot(x_w,T_fitm(:,9),'LineWidth',2,'Color',rgbTriplet{2}(4, :));hold on ;
plot(x_w,T_fitm(:,10),'LineWidth',2,'Color',rgbTriplet{2}(5, :));hold on ;
plot(x_w,T_fitm(:,11),'LineWidth',2,'Color',rgbTriplet{3}(5, :));hold on ;

set(gca,'FontSize',15,'LineWidth',1.2,'FontName','Times New Roman');
xlabel('Overall linewidth(GHz)','fontsize',15,'FontName','Times New Roman');ylabel('T(K)','fontsize',15,'FontName','Times New Roman');
% legend({['\beta=',num2str(be(1,1)),' GHz'],['\beta=',num2str(be(1,2)),' GHz'],['\beta=',num2str(be(1,3)),' GHz'], ...
%     ['\beta=',num2str(be(1,4)),' GHz'],['\beta=',num2str(be(1,5)),' GHz'],['\beta=',num2str(be(1,6)),' GHz'], ...
%     ['\beta=',num2str(be(1,7)),' GHz'],['\beta=',num2str(be(1,8)),' GHz'],['\beta=',num2str(be(1,9)),' GHz'], ...
%     ['\beta=',num2str(be(1,10)),' GHz'],['\beta=',num2str(be(1,11)),' GHz']},'Orientation','vertical');
% set(legend,'Location','NorthEastOutside','FontSize',10,'Box','off','FontName','Times New Roman');

xlim([3.06,3.6]);
% xticks(3.06:0.3:3.6);
ylim([220,290]);
% yticks(220:20:280);

grid on
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperSize',[28,11.4])
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition',[0,0,28,11.4]);
set(gcf,'Renderer','painters');
%%
%% 图3.2.1/3.2.2_纵温度_横系数_线宽线
figure(7);

x_b=1.14:0.01:1.24;

plot(x_b,T_fitm(1,:),'LineWidth',2,'Color',rgbTriplet{1}(1, :));hold on ;
plot(x_b,T_fitm(2,:),'LineWidth',2,'Color',rgbTriplet{1}(2, :));hold on ;
plot(x_b,T_fitm(3,:),'LineWidth',2,'Color',rgbTriplet{1}(3, :));hold on ;
plot(x_b,T_fitm(4,:),'LineWidth',2,'Color',rgbTriplet{1}(4, :));hold on ;
plot(x_b,T_fitm(5,:),'LineWidth',2,'Color',rgbTriplet{1}(5, :));hold on ;
plot(x_b,T_fitm(6,:),'LineWidth',2,'Color',rgbTriplet{2}(1, :));hold on ;
plot(x_b,T_fitm(7,:),'LineWidth',2,'Color',rgbTriplet{2}(2, :));hold on ;
plot(x_b,T_fitm(8,:),'LineWidth',2,'Color',rgbTriplet{2}(3, :));hold on ;
plot(x_b,T_fitm(9,:),'LineWidth',2,'Color',rgbTriplet{2}(4, :));hold on ;
plot(x_b,T_fitm(10,:),'LineWidth',2,'Color',rgbTriplet{2}(5, :));hold on ;


set(gca,'FontSize',15,'LineWidth',1.2,'FontName','Times New Roman');
xlabel('Brillouin Shift(GHz))','fontsize',15,'FontName','Times New Roman');ylabel('T(K)','fontsize',15,'FontName','Times New Roman');
% 
% legend({'\itl=3.06 GHz',['\itl=',num2str(wi(1,2)),' GHz'],['\itl=',num2str(wi(1,3)),' GHz'],['\itl=',num2str(wi(1,4)),' GHz'],['\itl=',num2str(wi(1,5)),' GHz'], ...
%     ['\itl=',num2str(wi(1,6)),' GHz'],['\itl=',num2str(wi(1,7)),' GHz'],['\itl=',num2str(wi(1,8)),' GHz'],['\itl=',num2str(wi(1,9)),' GHz'], ...
%     ['\itl=',num2str(wi(1,10)),' GHz']},'Orientation','vertical');
% set(legend,'Location','NorthEastOutside','FontSize',10,'Box','off','FontName','Times New Roman');


xlim([1.14,1.24]);
% % xticks(1.1:0.05:1.4);
% yticks(160:40:440);

grid on
%设置输出的图的大小
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperSize',[28,11.4])
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition',[0,0,28,11.4]);
set(gcf,'Renderer','painters');

%%
%% 图3.3.1/3.3.2_纵压强_横线宽_频移线
figure(8);

x_w=3.06:0.06:3.6;
%需要画的线；'LineWidth'设置线宽,'Color'设置颜色（QQ的截图功能可以当取色器用）;'LineStyle'更改线型
plot(x_w,P_fitm(:,1),'LineWidth',2,'Color',rgbTriplet{1}(1, :));hold on ;
plot(x_w,P_fitm(:,2),'LineWidth',2,'Color',rgbTriplet{1}(2, :));hold on ;
plot(x_w,P_fitm(:,3),'LineWidth',2,'Color',rgbTriplet{1}(3, :));hold on ;
plot(x_w,P_fitm(:,4),'LineWidth',2,'Color',rgbTriplet{1}(4, :));hold on ;
plot(x_w,P_fitm(:,5),'LineWidth',2,'Color',rgbTriplet{1}(5, :));hold on ;
plot(x_w,P_fitm(:,6),'LineWidth',2,'Color',rgbTriplet{2}(1, :));hold on ;
plot(x_w,P_fitm(:,7),'LineWidth',2,'Color',rgbTriplet{2}(2, :));hold on ;
plot(x_w,P_fitm(:,8),'LineWidth',2,'Color',rgbTriplet{2}(3, :));hold on ;
plot(x_w,P_fitm(:,9),'LineWidth',2,'Color',rgbTriplet{2}(4, :));hold on ;
plot(x_w,P_fitm(:,10),'LineWidth',2,'Color',rgbTriplet{2}(5, :));hold on ;
plot(x_w,P_fitm(:,11),'LineWidth',2,'Color',rgbTriplet{3}(5, :));hold on ;


set(gca,'FontSize',15,'LineWidth',1.2,'FontName','黑体');

xlabel('Overall linewidth(GHz)','fontsize',15,'FontName','Times New Roman');ylabel('P(bar)','fontsize',15,'FontName','Times New Roman');
% ztickformat("percentage")
% legend({['\beta=',num2str(be(1,1)),' GHz'],['\beta=',num2str(be(1,2)),' GHz'],['\beta=',num2str(be(1,3)),' GHz'], ...
%     ['\beta=',num2str(be(1,4)),' GHz'],['\beta=',num2str(be(1,5)),' GHz'],['\beta=',num2str(be(1,6)),' GHz'],...
%     ['\beta=',num2str(be(1,7)),' GHz'],['\beta=',num2str(be(1,8)),' GHz'],['\beta=',num2str(be(1,9)),' GHz'], ...
%     ['\beta=',num2str(be(1,10)),' GHz'],['\beta=',num2str(be(1,11)),' GHz']},'Orientation','vertical');
% set(legend,'Location','NorthEastOutside','FontSize',10,'Box','off','FontName','黑体');
xlim([3.06,3.6]);
% xticks(3.0:0.3:3.9);
% ylim([-1100,-200]);
% % yticks(-500:-100:-1000);

grid on
%设置输出的图的大小
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperSize',[28,11.4])
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition',[0,0,28,11.4]);
set(gcf,'Renderer','painters');
%%
%% 图3.4.1/3.4.2_纵压强_横系数_线宽线

figure(9);

x_b=1.14:0.01:1.24;
%需要画的线；'LineWidth'设置线宽,'Color'设置颜色（QQ的截图功能可以当取色器用）;'LineStyle'更改线型
plot(x_b,P_fitm(1,:),'LineWidth',2,'Color',rgbTriplet{1}(1, :));hold on ;
plot(x_b,P_fitm(2,:),'LineWidth',2,'Color',rgbTriplet{1}(2, :));hold on ;
plot(x_b,P_fitm(3,:),'LineWidth',2,'Color',rgbTriplet{1}(3, :));hold on ;
plot(x_b,P_fitm(4,:),'LineWidth',2,'Color',rgbTriplet{1}(4, :));hold on ;
plot(x_b,P_fitm(5,:),'LineWidth',2,'Color',rgbTriplet{1}(5, :));hold on ;
plot(x_b,P_fitm(6,:),'LineWidth',2,'Color',rgbTriplet{2}(1, :));hold on ;
plot(x_b,P_fitm(7,:),'LineWidth',2,'Color',rgbTriplet{2}(2, :));hold on ;
plot(x_b,P_fitm(8,:),'LineWidth',2,'Color',rgbTriplet{2}(3, :));hold on ;
plot(x_b,P_fitm(9,:),'LineWidth',2,'Color',rgbTriplet{2}(4, :));hold on ;
plot(x_b,P_fitm(10,:),'LineWidth',2,'Color',rgbTriplet{2}(5, :));hold on ;

set(gca,'FontSize',15,'LineWidth',1.2,'FontName','Times New Roman');
xlabel('Brillouin Shift(GHz))','fontsize',15,'FontName','Times New Roman');ylabel('P(bar)','fontsize',15,'FontName','Times New Roman');

% legend({'\itl=3.0 GHz',['\itl=',num2str(wi(1,2)),' GHz'],['\itl=',num2str(wi(1,3)),' GHz'],['\itl=',num2str(wi(1,4)),' GHz'],['\itl=',num2str(wi(1,5)),' GHz'], ...
%     ['\itl=',num2str(wi(1,6)),' GHz'],['\itl=',num2str(wi(1,7)),' GHz'],['\itl=',num2str(wi(1,8)),' GHz'],['\itl=',num2str(wi(1,9)),' GHz'], ...
%     ['\itl=',num2str(wi(1,10)),' GHz']},'Orientation','vertical');
% set(legend,'Location','NorthEastOutside','FontSize',10,'Box','off','FontName','Times New Roman');

xlim([1.14,1.24]);
% ylim([-1600,-200]);

grid on
%设置输出的图的大小
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperSize',[28,11.4])
set(gcf,'PaperPositionMode','manual')
set(gcf,'PaperPosition',[0,0,28,11.4]);
set(gcf,'Renderer','painters');
%%
% t=220:10:340;
% p=0.1:0.1:1;
% 
% load d_width.mat
% w_modle=d_W;%仿真线宽 220-340，0.1-1；每一列温度相同
% %  w_m=w_modle(:); %每十个变一次温度

for T=220:10:340
    for P=0.1:0.1:1
ii=round(P*10)
jj=round((T-210)/10)
 x2=shift(ii,jj)./1e9;
x1=w_modle(ii,jj);
 % 温度关于线宽（x1）
     T_xm1(ii,jj) = b+2.*d.*x1++f.*x2+3.*g.*x1.^2+i.*x2.^2+2.*j.*x1.*x2;
    % 温度关于频移 （x2）
      T_bm1(ii,jj)= c+2.*e.*x2+f.*x1+3.*h.*x2.^2+2*i.*x1.*x2+j.*x1.^2; 
      % 压强关于线宽（x1）
        P_xm1(ii,jj) = c2+2.*c4.*x1++c6.*x2+3.*c7.*x1.^2+c9.*x2.^2+2.*c10.*x1.*x2;
       % 压强关于频移 （x2）
     P_bm1(ii,jj)= c3+2.*c5.*x2+c6.*x1+3.*c8.*x2.^2+2*c9.*x1.*x2+c10.*x1.^2;
     P_xm2(ii,jj)=P_xm1(ii,jj)/P_m1(ii,jj);
      P_bm2(ii,jj)=P_bm1(ii,jj)/P_m1(ii,jj);
    end
end
%%
%%
% 线宽：0.01G 频移：0.0025G

TT = sqrt(T_xm1.^2.*0.0001+T_bm1.^2.*6.2500e-06);
PP = sqrt(P_xm2.^2.*0.0001+P_bm2.^2.*6.2500e-06);
%%

T=220:10:340;
P=0.5:0.1:1;
figure(1)
[xm,ym]=meshgrid(T,P);
surf(xm,ym,TT(5:10,:),'FaceColor','interp',...
   'EdgeColor','none',...
   'FaceLighting','phong');
xlabel('T(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
ylabel('P(bar)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
zlabel('Temperature Uncertainty(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
%%
T=220:10:340;
P=0.5:0.1:1;
figure(2)
[xm,ym]=meshgrid(T,P);
surf(xm,ym,PP(5:10,:),'FaceColor','interp',...
   'EdgeColor','none',...
   'FaceLighting','phong');
xlabel('T(K)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
ylabel('P(bar)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
zlabel('Pressure Uncertainty','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
ztickformat("percentage")
set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
%%
PP1=PP(5:10,:);
TT1=TT(5:10,:);
%%
max(PP1(:))  
min(PP1(:))  
mean(PP1(:)) 
%%
max(TT1(:))    
min(TT1(:))  
mean(TT1(:))  