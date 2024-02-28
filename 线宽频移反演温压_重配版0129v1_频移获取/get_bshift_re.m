clc;clear;close all;
%%
% load bshift_wn.mat
% load d_B_shift5.mat;
% load d_B_shift4.mat;
% 
% load shift_r.mat
% load smr.mat
% 
% load shift_kr.mat
load b_wn.mat  %% 2.6频移数据 
load bri_shift_new.mat % 理论数据
biaozhun_pinyi=bri_shift_new./1e9;  %标准理论频移

kk=352;

for k_snr =20:1:50
% k_snr=34;
% k_snr=20;
bt=b_wn(:,k_snr,:); % 取第snr组
for iz=1:151
    for jz=1:kk
all_pinyi(iz,jz)=bt(iz,:,jz);
    end 
end


%%

% shimei_pinyi=shift_r(151:300,:);  %初始频移点
% all_pinyi=d_B_shift4;  %原始频移点
% all_pinyi=bt(2:151,:,:);  %原始频移点
% for iz=1:150
%     for jz=1:80
% all_pinyi(iz,jz)=bt(iz+1,:,jz)
%     end 
% 
% end
%%


% %% 画图
% figure(1);
% x=4.8:0.03:9.27;
% for i=1:kk  % 只取了前80组数据
%     plot(x,all_pinyi(:,i));
%     
%     hold on
% end
% y=1.1:0.1:1.4;
% 
% xlim([4.8,9.3]);
% set(gca,'XTick',4.8:0.9:9.3)
% ylim=([1,1.4]);
% legend('original data')
% xlabel('height(km)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
% ylabel('Brillouin shift(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
%%
% subplot(3,1,1)
% plot(all_pinyi(1,:));
% xlabel('data','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
% ylabel('shift(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
% title("9.3km,m=150")
% 
% subplot(3,1,2)
% plot(all_pinyi(70,:));
% xlabel('data','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
% ylabel('shift(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
% title("7.2km,m=70")
% 
% subplot(3,1,3)
% plot(all_pinyi(150,:));
% xlabel('data','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
% ylabel('shift(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% title("4.8km,m=1")
% set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
%%
% for j= 2:1:151
% use_shift(j,:) = all_pinyi(j,1:kk);
% end
% for j= 1:1:150
% mean_or(j,1) = mean(use_shift(j,:));%每个高度下的均值
% std_or= std(use_shift,1,2); %每个高度下的标准差
% end
%%
% for i=1:1:150
%     for j=1:1:kk
%         mean_e(i,j)=all_pinyi(i,j)-mean_or(i,1);
%     end
% end
% figure(2)
% subplot(2,1,1)
% % for i=1:kk  % 只取了前80组数据
% %     plot(x,mean_e(:,i));
% %     
% %     hold on
% % end
% plot(x,mean_or','b','linewidth',2);
% xlim([4.8,9.3]);
% set(gca,'XTick',4.8:0.9:9.3)
% ylim=([1,1.5]);
% ylabel('shift mean(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% xlabel('height(km)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
% % ylabel('mean error(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
% %
% subplot(2,1,2)
% plot(x,std_or,'r','linewidth',2);   
% xlim([4.8,9.3]);
% set(gca,'XTick',4.8:0.9:9.3)
% 
% xlabel('height(km)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
% ylabel('standard deviation(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
% 
% 
% %%
% plot(biaozhun_pinyi,'k','linewidth',2);
% hold on
% plot(k3,'r-o','linewidth',2);
% hold on
% for i=1:kk
%     plot(all_pinyi(:,i));
% end
%% 选取最接近标准值的值做最后一个值
for i=1:kk
    weizhicha(i)=all_pinyi(151,i)-biaozhun_pinyi(151);
end
weizhicha=abs(weizhicha);
[weizhicha_M,weizhicha_I] = min(weizhicha);
weizhi_xuan=all_pinyi(151,weizhicha_I);
%% 选取最接近标准值的值做倒数第二个值
for i=1:kk
    weizhicha_1(i)=all_pinyi(150,i)-biaozhun_pinyi(150);
end
weizhicha_1=abs(weizhicha_1);
[weizhicha_1_M,weizhicha_1_I] = min(weizhicha_1);
weizhi_xuan_1=all_pinyi(150,weizhicha_1_I);

X=zeros(1,151);%jieguo
X(151)=weizhi_xuan;
X(150)=weizhi_xuan_1;
%% 计算标准频移的斜率矩阵
for i=1:150
    xielv_biaozhun(i)=biaozhun_pinyi(152-i)-biaozhun_pinyi(151-i);
end
xielv_biaozhun=abs(xielv_biaozhun);  %%可修改
figure(2);
plot(xielv_biaozhun,'k','linewidth',2);
% mibu=2.6*max(xielv_biaozhun);
mibu=mean(abs(xielv_biaozhun));
%% 图1_原始频移数据图
% figure
% plot(biaozhun_pinyi,'k')
% hold on
% for ic=1:kk
% 
% plot(all_pinyi(:,ic),'o-');
% hold on
% 
% end



%% 迭代算法第一步

dieshu=149;
while dieshu>0
    for i=1:kk
%         diedai1=abs(X(dieshu+1)-shimei_pinyi(dieshu,i));
%         diedai2=abs(X(dieshu+2)-shimei_pinyi(dieshu,i));
        diedai1=all_pinyi(dieshu,i)-X(dieshu+1);
        diedai2=all_pinyi(dieshu,i)-X(dieshu+2);
        if (diedai1>=0.1*min(xielv_biaozhun)) && (diedai1<=1.2*max(xielv_biaozhun))&&(diedai2>=0.8*0.1*min(xielv_biaozhun)) && (diedai2<=3*1.2*max(xielv_biaozhun))
            beixuan(i)=all_pinyi(dieshu,i); 
        end
    end
    [beixuan_row,beixuan_col,beixuan_v] = find(beixuan);
    [q,e]=size(beixuan_row);
    if e==1
        X(dieshu)=beixuan(beixuan_col);
        beixuan=zeros(1,150);
        dieshu=dieshu-1;
        continue
    elseif e==0
        X(dieshu)=X(dieshu+1)+mibu;
        beixuan=zeros(1,150);
        dieshu=dieshu-1;
        continue        
    else
        beixuan=zeros(1,150);
        for i=1:kk
            diedai1=abs(X(dieshu+1)-all_pinyi(dieshu,i));
            diedai2=abs(X(dieshu+2)-all_pinyi(dieshu,i));
            if (diedai1>=0.05*min(xielv_biaozhun)) && (diedai1<=1.1*max(xielv_biaozhun))&&(diedai2>=0.5*0.1*min(xielv_biaozhun)) && (diedai2<=2*1.2*max(xielv_biaozhun))
                beixuan(i)=all_pinyi(dieshu,i); 
            end
        end
        [beixuan_row,beixuan_col,beixuan_v] = find(beixuan);
        [q,e]=size(beixuan_row);
        if e==1
            X(dieshu)=beixuan(beixuan_col);
            beixuan=zeros(1,150);
            dieshu=dieshu-1;
            continue
        else
            beixuan=zeros(1,150);
            for i=1:kk
                diedai1=abs(X(dieshu+1)-all_pinyi(dieshu,i));
                diedai2=abs(X(dieshu+2)-all_pinyi(dieshu,i));
                if (diedai1>=0.03*min(xielv_biaozhun)) && (diedai1<=1.05*max(xielv_biaozhun))&&(diedai2>=0.4*0.1*min(xielv_biaozhun)) && (diedai2<=1*1.2*max(xielv_biaozhun))
                    beixuan(i)=all_pinyi(dieshu,i); 
                end
            end
            [beixuan_row,beixuan_col,beixuan_v] = find(beixuan);
            [q,e]=size(beixuan_row);
            if e==1
                X(dieshu)=beixuan(beixuan_col);
                beixuan=zeros(1,150);
                dieshu=dieshu-1;
                continue
            else
                beixuan=zeros(1,150);
                for i=1:kk
                    diedai1=abs(X(dieshu+1)-all_pinyi(dieshu,i));
                    diedai2=abs(X(dieshu+2)-all_pinyi(dieshu,i));
                    if (diedai1>=0.5*min(xielv_biaozhun)) && (diedai1<=2*max(xielv_biaozhun))&&(diedai2>=0.5*0.5*min(xielv_biaozhun)) && (diedai2<=2*2*max(xielv_biaozhun))
                        beixuan(i)=all_pinyi(dieshu,i); 
                    end
                end
                [beixuan_row,beixuan_col,beixuan_v] = find(beixuan);
                [q,e]=size(beixuan_row);
                if e==1
                    X(dieshu)=beixuan(beixuan_col);
                    beixuan=zeros(1,150);
                    dieshu=dieshu-1;
                    continue
                else
                    beixuan=zeros(1,150);
                    for i=1:kk
                        diedai1=abs(X(dieshu+1)-all_pinyi(dieshu,i));
                        diedai2=abs(X(dieshu+2)-all_pinyi(dieshu,i));
                        if (diedai1>=min(xielv_biaozhun)) && (diedai1<=max(xielv_biaozhun))&&(diedai2>=0.5*min(xielv_biaozhun)) && (diedai2<=2*max(xielv_biaozhun))
                            beixuan(i)=all_pinyi(dieshu,i); 
                        end
                    end
                    [beixuan_row,beixuan_col,beixuan_v] = find(beixuan);
                    [q,e]=size(beixuan_row);
                    if e==1
                        X(dieshu)=beixuan(beixuan_col);
                        beixuan=zeros(1,150);
                        dieshu=dieshu-1;
                        continue
                    else
                        X(dieshu)=X(dieshu+1)+mibu;
                        beixuan=zeros(1,150);
                        dieshu=dieshu-1;
                    end             
                end        
            end    
        end
    end
%     disp(['已完成' num2str(dieshu)])
end
disp(['已完成' num2str(k_snr)])
%%
Bshift_wn(k_snr,:)=X;
%%

 end
%%

bshift_wn=Bshift_wn(20:50,:);
save bshift_wn.mat bshift_wn;

%%
% %% 图2_挑选频移结果图
x=4.8:0.03:9.3;
figure(3);
plot(x,biaozhun_pinyi,'k','linewidth',2);
hold on
for k_snr=20:1:50
plot(x,Bshift_wn(k_snr,:),'linewidth',1);
% set(gca,'ydir','reverse')
hold on
end
k_snr=20:1:50;
legend(num2str(k_snr(:,1)),num2str(k_snr(:,2)),num2str(k_snr(:,3)),num2str(k_snr(:,4)),num2str(k_snr(:,5)),num2str(k_snr(:,6)),num2str(k_snr(:,7)),...
       num2str(k_snr(:,8)),num2str(k_snr(:,9)),num2str(k_snr(:,10)),num2str(k_snr(:,11)),num2str(k_snr(:,12)),num2str(k_snr(:,13)),num2str(k_snr(:,14)), ...
       num2str(k_snr(:,15)),num2str(k_snr(:,16)),num2str(k_snr(:,17)),num2str(k_snr(:,18)),num2str(k_snr(:,19)),num2str(k_snr(:,20)),num2str(k_snr(:,21)), ...
       num2str(k_snr(:,22)),num2str(k_snr(:,23)),num2str(k_snr(:,24)),num2str(k_snr(:,25)),num2str(k_snr(:,26)),num2str(k_snr(:,27)),num2str(k_snr(:,28)), ...
       num2str(k_snr(:,29)),num2str(k_snr(:,30)),num2str(k_snr(:,31)))


% legend('theory')
xlim([4.8,9.3]);
xlabel('height(km)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
ylabel('Brillouin shift(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
%%
% %% 图3_所有频移数据
% % x=4.8:0.03:9.27;
% figure(3);
% for i=1:kk
%     plot(x,all_pinyi(:,i));
%     hold on
% end
% plot(x,biaozhun_pinyi,'k','linewidth',2);
% hold on
% % plot(x,k3,'r','linewidth',2);
% % hold on
% plot(x,X,'r','linewidth',2);
% hold on
% 
% xlim([4.8,9.3]);
% legend('theory','model')
% 
% % set(gca,'ydir','reverse')
% xlabel('height(km)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
% ylabel('Brillouin shift(GHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
% %% 图4_误差
% figure(4)
% for i=1:151
% %     error1(i)=k3(i)-biaozhun_pinyi(i);
%     error2(i)=X(i)-biaozhun_pinyi(i);
% end
% figure(4);
% % plot(x,error1.*1000,'k','linewidth',2);
% % hold on
% plot(x,error2.*1000,'r','linewidth',2);
% title('频移误差/M')
% xlim([4.8,9.3]);
% % legend('manual','model')
% xlabel('height(km)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');  
% ylabel('Brillouin shift error(MHz)','Fontsize',14,'FontWeight','bold','FontName','Times New Roman');
% set(gca,'FontName','Times New Roman','FontSize',12,'fontweight','bold','linewidth',1.2)
%%
