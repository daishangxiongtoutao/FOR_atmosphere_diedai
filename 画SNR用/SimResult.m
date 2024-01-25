clc,clear, close all;
% % Simulation
% Sim_width = load("d_width.mat").d_W(:);       % Simulate linewidth
% Sim_betam = load("beta_m.mat").beta_1;        % Simulation energy
% 
% %Temperature and pressure
% tem = 220:10:340;
% tem_plus = ones(10,1)*tem;
% Sim_t = tem_plus(:);
% press = 0.1:0.1:1;
% press_plus = ones(13,1)*press;
% press_plus = press_plus';
% Sim_p = press_plus(:);
% 
% clear tem tem_plus press press_plus
% % simulate retrieval
% [ SRet_p ] = SimulatePressure( Sim_betam, Sim_width );
% [ SRet_t ] = SimulateTemperature( Sim_betam, Sim_width );
% 
% Sim_dt = SRet_t - Sim_t;
% Sim_dp = ( SRet_p - Sim_p ) ./ Sim_p .* 100;


% Use USA-76 to Caculate Simulation Standard Value
Sim_h = ( 0.12:0.03:9.99 )'; % 探测距离区间，m
[ SimA_t, SimA_p ] = USA76( Sim_h ); %压强:bar, 温度:K
% load USA76L.txt; load USA76beta_m.mat;
[ USA76b ] = GenerateBetaM( SimA_t, SimA_p );
%%
[ USA76L ] = GenerateWidth( SimA_t, SimA_p );
%%
[ CRO_t, CRO_p ] = OADSMethord( USA76L, USA76b );
%%
[ CRH_t, CRH_p ] = LBetaMethords( USA76b, USA76L );
%%
% results
COD_t = CRO_t - SimA_t;
COD_p = ( CRO_p - SimA_p ) ./ SimA_p .* 100;
CHD_t = CRH_t - SimA_t;
CHD_p = ( CRH_p - SimA_p ) ./ SimA_p .* 100;

figure('Name','Compare of Two methords Temperature')
set(gcf,'Position',[200 100 1000 600]);% 设置绘图的大小，，图的大小是7cm
set(gca,'Position',[.13 .17 .80 .74]);
pos1 = [0.1 0.2 0.6 0.7];
subplot('Position',pos1)
plot( CRO_t, Sim_h, 'b-', 'linewidth', 1.5, 'markerfacecolor', 'b','markersize', 5);
hold on;
plot( CRH_t, Sim_h, 'r-', 'linewidth', 1.5, 'markerfacecolor', 'r', 'markersize', 5);
hold on
plot( SimA_t, Sim_h, 'k--', 'linewidth', 1.5, 'markerfacecolor', 'k', 'markersize', 5);
ylabel('Altitude(km)','Fontsize',15,'FontWeight','bold','FontName','Time New Roman'); 
xlabel('Temperature(K)','Fontsize',15,'FontWeight','bold','FontName','Time New Roman');
box on
axis([220 290 0.12 9.99])
set(gca,'FontName','Time New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
legend('OADS','L-{\beta}','Theoretical Temperature')
grid on
hold on
%温度误差线
pos2 = [0.8 0.2 0.15 0.7];
subplot('Position',pos2)
% h=errorbar(t_error_mean,rr,t_dev_mean,'horizontal','color',rgb,'linestyle','-','marker','o','linewidth',1.5,'markerfacecolor',rgb,'markersize',5);
% hold on
plot( COD_t, Sim_h,'color','b','linestyle','-','linewidth',1.5,'markerfacecolor','b','markersize',5);
hold on;
plot( CHD_t, Sim_h,'color','r','linestyle','-','linewidth',1.5,'markerfacecolor','r','markersize',5);
hold on
xlabel('{\Delta}Temperature(K)','Fontsize',15,'fontname','Times','fontweight','bold')
box on
axis([-2.5 2.5 0.12 9.99])
set(gca,'FontName','Time New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
grid on
hold on
line([0 0],[0 11],'color','k','linestyle','--','linewidth',2.5)
legend('OADS-error', 'L-{\beta}-error')

figure('Name','Compare of Two methords Pressure')
set(gcf,'Position',[200 100 1000 600]);% 设置绘图的大小，，图的大小是7cm
set(gca,'Position',[.13 .17 .80 .74]);
pos1 = [0.1 0.2 0.6 0.7];
subplot('Position',pos1)
plot( CRO_p, Sim_h, 'b-', 'linewidth', 1.5, 'markerfacecolor', 'b','markersize', 5);
hold on;
plot( CRH_p, Sim_h, 'r-', 'linewidth', 1.5, 'markerfacecolor', 'r', 'markersize', 5);
hold on
plot( SimA_p, Sim_h, 'k--', 'linewidth', 1.5, 'markerfacecolor', 'k', 'markersize', 5);
ylabel('Altitude(km)','Fontsize',15,'FontWeight','bold','FontName','Time New Roman'); 
xlabel('Pressure(bar)','Fontsize',15,'FontWeight','bold','FontName','Time New Roman');
box on
axis([0.2 1.1 0.12 9.99])
set(gca,'FontName','Time New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
legend('OADS','L-{\beta}','Theoretical Pressure')
grid on
hold on
%误差线
pos2 = [0.8 0.2 0.15 0.7];
subplot('Position',pos2)
% h=errorbar(t_error_mean,rr,t_dev_mean,'horizontal','color',rgb,'linestyle','-','marker','o','linewidth',1.5,'markerfacecolor',rgb,'markersize',5);
% hold on
plot( COD_p, Sim_h,'color','b','linestyle','-','linewidth',1.5,'markerfacecolor','b','markersize',5);
hold on;
plot( CHD_p, Sim_h,'color','r','linestyle','-','linewidth',1.5,'markerfacecolor','r','markersize',5);
hold on
xlabel('{\Delta}Pressure(%)','Fontsize',15,'fontname','Times','fontweight','bold')
box on
axis([-10 10 0.12 9.99])
set(gca,'FontName','Time New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
grid on
hold on
line([0 0],[0 11],'color','k','linestyle','--','linewidth',2.5)
legend('OADS-error', 'L-{\beta}-error')


clear pos1 pos2