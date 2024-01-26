%%赵修改
clc;clear;close all;
%%
load d_B_shift3.mat;

load shift_r.mat
load smr.mat
load shift_kr.mat
%%
% shimei_pinyi=shift_r(151:300,:);  %初始频移点
shimei_pinyi=d_B_shift3;  %初始频移点
biaozhun_pinyi=shift(151:300,:);  %标准频移
% figure(1);
% plot(biaozhun_pinyi,'k','linewidth',2);
% hold on
% plot(k3,'r-o','linewidth',2);
% hold on
% for i=1:80
%     plot(shimei_pinyi(:,i));
% end
%% 选取最接近标准值的值做最后一个值
for i=1:320
    weizhicha(i)=shimei_pinyi(150,i)-biaozhun_pinyi(150);
end
weizhicha=abs(weizhicha);
[weizhicha_M,weizhicha_I] = min(weizhicha);
weizhi_xuan=shimei_pinyi(150,weizhicha_I);
%% 选取最接近标准值的值做倒数第二个值
for i=1:320
    weizhicha_1(i)=shimei_pinyi(149,i)-biaozhun_pinyi(149);
end
weizhicha_1=abs(weizhicha_1);
[weizhicha_1_M,weizhicha_1_I] = min(weizhicha_1);
weizhi_xuan_1=shimei_pinyi(149,weizhicha_1_I);

X=zeros(1,150);%jieguo
X(150)=weizhi_xuan;
X(149)=weizhi_xuan_1;
%% 计算标准频移的斜率矩阵
for i=1:149
    xielv_biaozhun(i)=biaozhun_pinyi(151-i)-biaozhun_pinyi(150-i); %%理论值算出来全是负数，做了绝对值
end
xielv_biaozhun=abs(xielv_biaozhun);  
% figure(2);
% plot(xielv_biaozhun,'k','linewidth',2);
mibu=2.6*max(xielv_biaozhun);
%% 迭代算法第一步
%%
% for i=1:320
% diedai1(i)=shimei_pinyi(148,i)-X(149);
%         diedai2(i)=shimei_pinyi(148,i)-X(150);
% end
%%
% dieshu=148;
%  for i=1:320
% %         diedai1=abs(X(dieshu+1)-shimei_pinyi(dieshu,i));
% %         diedai2=abs(X(dieshu+2)-shimei_pinyi(dieshu,i));
%         diedai1(i)=shimei_pinyi(dieshu,i)-X(dieshu+1);
%         diedai2(i)=shimei_pinyi(dieshu,i)-X(dieshu+2);
%     end
%     for i=1:320
% %         if (diedai1(i)>=0.2*min(xielv_biaozhun)) && (diedai1(i)<=5*max(xielv_biaozhun))&&(diedai2(i)>=0.5*0.2*min(xielv_biaozhun)) && (diedai2(i)<=2*5*max(xielv_biaozhun))
%        if (diedai1(i)>=0.2*min(xielv_biaozhun) )&& (diedai1(i)<=10*max(xielv_biaozhun))  &&(diedai2(i)>=0.5*0.2*min(xielv_biaozhun))
%             beixuan(i)=shimei_pinyi(dieshu,i); 
%             i
%         end
%     end
%%
dieshu=148;
while dieshu>0
    for i=1:320
%         diedai1=abs(X(dieshu+1)-shimei_pinyi(dieshu,i));
%         diedai2=abs(X(dieshu+2)-shimei_pinyi(dieshu,i));
        diedai1(i)=shimei_pinyi(dieshu,i)-X(dieshu+1);
        diedai2(i)=shimei_pinyi(dieshu,i)-X(dieshu+2);
    end
    for i=1:320
%         if (diedai1(i)>=0.2*min(xielv_biaozhun)) && (diedai1(i)<=5*max(xielv_biaozhun))&&(diedai2(i)>=0.5*0.2*min(xielv_biaozhun)) && (diedai2(i)<=2*5*max(xielv_biaozhun))
   if (diedai1(i)>=0.2*min(xielv_biaozhun)) && (diedai1(i)<=15*max(xielv_biaozhun))
            beixuan(i)=shimei_pinyi(dieshu,i); 
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
        for i=1:320%%
%             diedai1=abs(X(dieshu+1)-shimei_pinyi(dieshu,i));
%             diedai2=abs(X(dieshu+2)-shimei_pinyi(dieshu,i));
            diedai1=shimei_pinyi(dieshu,i)-X(dieshu+1);
            diedai2=shimei_pinyi(dieshu,i)-X(dieshu+2);
            if (diedai1>=0.25*min(xielv_biaozhun)) && (diedai1<=4*max(xielv_biaozhun))&&(diedai2>=0.5*0.25*min(xielv_biaozhun)) && (diedai2<=2*4*max(xielv_biaozhun))
                beixuan(i)=shimei_pinyi(dieshu,i); 
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
            for i=1:320%%
%                 diedai1=abs(X(dieshu+1)-shimei_pinyi(dieshu,i));
%                 diedai2=abs(X(dieshu+2)-shimei_pinyi(dieshu,i));
            diedai1=shimei_pinyi(dieshu,i)-X(dieshu+1);
            diedai2=shimei_pinyi(dieshu,i)-X(dieshu+2);
                if (diedai1>=0.3*min(xielv_biaozhun)) && (diedai1<=3*max(xielv_biaozhun))&&(diedai2>=0.5*0.3*min(xielv_biaozhun)) && (diedai2<=2*3*max(xielv_biaozhun))
                    beixuan(i)=shimei_pinyi(dieshu,i); 
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
                for i=1:320%%
%                     diedai1=abs(X(dieshu+1)-shimei_pinyi(dieshu,i));
%                     diedai2=abs(X(dieshu+2)-shimei_pinyi(dieshu,i));
               diedai1=shimei_pinyi(dieshu,i)-X(dieshu+1);
              diedai2=shimei_pinyi(dieshu,i)-X(dieshu+2);
                    if (diedai1>=0.5*min(xielv_biaozhun)) && (diedai1<=2*max(xielv_biaozhun))&&(diedai2>=0.5*0.5*min(xielv_biaozhun)) && (diedai2<=2*2*max(xielv_biaozhun))
                        beixuan(i)=shimei_pinyi(dieshu,i); 
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
                    for i=1:320%%
%                         diedai1=abs(X(dieshu+1)-shimei_pinyi(dieshu,i));
%                         diedai2=abs(X(dieshu+2)-shimei_pinyi(dieshu,i));
                     diedai1=shimei_pinyi(dieshu,i)-X(dieshu+1);
                    diedai2=shimei_pinyi(dieshu,i)-X(dieshu+2);
                        if (diedai1>=min(xielv_biaozhun)) && (diedai1<=max(xielv_biaozhun))&&(diedai2>=0.5*min(xielv_biaozhun)) && (diedai2<=2*max(xielv_biaozhun))
                            beixuan(i)=shimei_pinyi(dieshu,i); 
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
    disp(['已完成' num2str(dieshu)])
end
%%
figure(3);
plot(biaozhun_pinyi,'k','linewidth',2);
hold on
plot(k3,'r-o','linewidth',1);
hold on
plot(X,'b-o','linewidth',1);
hold on
for i=1:80
    plot(shimei_pinyi(:,i));
end
%% 求误差对比
for i=1:150
    error1(i)=abs(k3(i)-biaozhun_pinyi(i));
    error2(i)=abs(X(i)-biaozhun_pinyi(i));
end
figure(4);
plot(error1.*1000,'k','linewidth',2);
hold on
plot(error2.*1000,'r','linewidth',2);
legend('手工','自动')
