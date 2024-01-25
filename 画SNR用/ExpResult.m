% The code for manuscript
%Compare OADS and OUR

clc, clear, close all;

% Experiment
Exp_h = load("h.txt");          % helight 
Exp_t = load("T_radio.txt");    % Standard temperature
Exp_p = load("p_radio.txt");    % Standard pressure
Exp_width = load("实验线宽.txt");    % Measure linewidth
Exp_betam = load("beta_r.mat").beta_m1';      % Measure energy


 Exp_width1 = Exp_width+0.1;
% Experiment OADS
[ ERef_t, ERef_p ] = OADSMethord( Exp_width1, Exp_betam );

% Eeperiment retrieval
[ ERet_p ] = RetrievalPressure( Exp_betam, Exp_width );
[ ERet_t ] = RetrievalTemperature( Exp_betam, Exp_width );
% Deviation
Exp_dt = ERet_t - Exp_t;
Exp_dp = ( ERet_p - Exp_p ) ./ Exp_p .* 100;
Exp_ft = ERef_t - Exp_t;
Exp_fp = ( ERef_p - Exp_p ) ./ Exp_p .* 100;


% Figure
figure('Name','Experiment Temperature')
set(gcf,'Position',[200 100 1000 600]);% 设置绘图的大小，，图的大小是7cm
set(gca,'Position',[.13 .17 .80 .74]);
pos1 = [0.1 0.2 0.6 0.7];
subplot('Position',pos1)
plot( ERef_t, Exp_h, 'b-', 'linewidth', 1.5, 'markerfacecolor', 'b','markersize', 5);
hold on
plot( ERet_t, Exp_h, 'r-', 'linewidth', 1.5, 'markerfacecolor', 'r','markersize', 5);
hold on;
plot( Exp_t, Exp_h, 'k-', 'linewidth', 1.5, 'markerfacecolor', 'k', 'markersize', 5);
ylabel('Altitude(km)','Fontsize',15,'FontWeight','bold','FontName','Time New Roman'); 
xlabel('Temperature(K)','Fontsize',15,'FontWeight','bold','FontName','Time New Roman');
box on
axis([235 275 4.5 9.5])
set(gca,'FontName','Time New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
legend('OADS','L-{\beta}','Radio-Temperature')
grid on
hold on
%温度误差线
pos2 = [0.8 0.2 0.15 0.7];
subplot('Position',pos2)
% h=errorbar(t_error_mean,rr,t_dev_mean,'horizontal','color',rgb,'linestyle','-','marker','o','linewidth',1.5,'markerfacecolor',rgb,'markersize',5);
% hold on
plot( Exp_ft, Exp_h,'color','b','linestyle','-','linewidth',1.5,'markerfacecolor','b','markersize',5);
hold on;
plot( Exp_dt, Exp_h,'color','r','linestyle','-','linewidth',1.5,'markerfacecolor','r','markersize',5);
hold on;
xlabel('Temperature(K)','Fontsize',15,'fontname','Times','fontweight','bold')
box on
axis([-5 5 4.5 9.5])
set(gca,'FontName','Time New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
grid on
hold on
line([0 0],[0 11],'color','k','linestyle','--','linewidth',2.5)
legend('{\Delta}Temperature(K)')

figure('Name', 'Experiment Pressure')
set(gcf,'Position',[200 100 1000 600]);% 设置绘图的大小，，图的大小是7cm
set(gca,'Position',[.13 .17 .80 .74]);
pos1 = [0.1 0.2 0.6 0.7];
subplot('Position',pos1)
plot( ERef_p, Exp_h,'b-','linewidth',1.5,'markerfacecolor','b','markersize',5);
hold on;
plot( ERet_p,Exp_h,'r-','linewidth',1.5,'markerfacecolor','r','markersize',5);
hold on
plot( Exp_p, Exp_h,'k-','linewidth',1.5,'markerfacecolor','k','markersize',5);
hold on;
ylabel('高度（km）','Fontsize',15,'FontWeight','bold','FontName','Time New Roman'); 
xlabel('压强（bar）','Fontsize',15,'FontWeight','bold','FontName','Time New Roman');
box on
axis([0.25 0.6 4.5 9.5])
set(gca,'FontName','Time New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
legend('OADS','L-{\beta}', 'Radio-Pressure')
grid on
hold on
%压强误差线
pos2 = [0.8 0.2 0.15 0.7];
subplot('Position',pos2)
plot( Exp_fp, Exp_h,'color','b','linestyle','-','linewidth',1.5,'markerfacecolor','b','markersize',5);
hold on;
plot( Exp_dp, Exp_h,'color','r','linestyle','-','linewidth',1.5,'markerfacecolor','r','markersize',5);
hold on;
xlabel('{\Delta}Pressure(%)','Fontsize',15,'fontname','Times','fontweight','bold')
box on
axis([-10 10 4.5 9.5])
set(gca,'FontName','Time New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
grid on
hold on
line([0 0],[0 11],'color','k','linestyle','--','linewidth',2.5)
legend('OADS', 'L-{\beta}')