% A=ainc2adj(x);% 邻接表生成邻接矩阵

p=0:0.01:0.80;

u=0.5;
sn1=zeros(1,81);
for i=1:length(p)
sn1(i)=load_redistribution(A,u,p(i));  
end

u=1.0;
sn2=zeros(1,81);
for i=1:length(p)
sn2(i)=load_redistribution(A,u,p(i));  
end

u=1.5;
sn3=zeros(1,81);
for i=1:length(p)
sn3(i)=load_redistribution(A,u,p(i));  
end

u=2.0;
sn4=zeros(1,81);
for i=1:length(p)
sn4(i)=load_redistribution(A,u,p(i));  
end
figure;
plot(p,sn1 ,'-sr');hold on;
plot(p,sn2 ,'-ob');hold on;
plot(p,sn3 ,'-^g');hold on;
plot(p,sn4 ,'-vk');hold on;
axis([0 0.8 0 1.0]);
xlabel('p');set(gca,'xtick',0:0.1:0.80);
ylabel('SN');set(gca,'ytick',0:0.1:1.0);
legend('u=0.5','u=1.0','u=1.5','u=2.0');