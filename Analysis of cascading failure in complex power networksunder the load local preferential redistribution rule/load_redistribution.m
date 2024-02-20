function SN=load_redistribution(A,u,p)
%A是网络的邻接矩阵
%每次攻击网络的一个节点，发生负载重分配级联失效稳定后，计算相应的故障节点总数Si
%计算攻击所有的节点后级联失效所产生的的SN
k=sum(A,2);            %按行相加得到一个列矩阵,求a1网络的每一个节点的内部度
Lj=k.^u;       %初始负荷Lj的函数定义，并求各个节点的初始负荷
Cj=(1+p)*Lj;           %节点处理负荷的能力Cj1，它与Lj1成正比，p>0,p为自变量

ksum = zeros(length(k),1);
for ii=1:length(k)            
    ksum(ii) = sum(Lj(A(ii,:)'==1));%ksum(ii)表示与第ii个节点相连的所有节点的初始负荷的和
end
ksum(ksum==0)=-1;%将ksum数组中为0的元素设为-1
Lij = Lj*Lj'.*A./repmat(ksum,1,length(k));%%左侧的表达式为计算级联失效后分配给邻居节点的额外负荷△Lij的计算公式
                                          %%表示每个节点崩溃后，其所对应的其余邻居节点所收到的额外负荷，Lij(i,j)表示i节点失效后，所对应得邻居节点j获得的额外负荷
                                          %%repmat(ksum,1,length(k))表示所得数组的每一列相同，且列中的每个元素为每个节点所有邻居节点的负荷之和
                                          %%注意:Lj*Lj'.*A表示节点i的负荷，乘以其所对应的邻居节点j的负荷之积 
                                          %%Lj'.*A./repmat(ksum,1,length(k))表示择优概率(故障节点将其上负载按该式子所示比例传递给节点j)
Ljtemp = Lj;%对中间变量初始化，Lj节点负荷的值是随着攻击变化的
Si = zeros(length(k),1);      %对CF进行初始化
for temp = 1:length(k)   %需要攻击网络的每一个节点，所以循环k次    
    init_node = zeros(length(k),1); %对中间值进行初始化
    init_node(temp) = 1;%指定所需要攻击的节点，attacknode(temp)表示攻击指定节点的ID,即下标
    Nattack = init_node;%初始化中间值，该中间值为失效节点
   Atemp=A;
   I=0;
   while(sum(init_node)>0) %当大于0时表示有需要继续攻击的节点，继续循环
       attact_node=init_node;
       ksum = zeros(length(k),1);
       for ii=1:length(k)
           ksum(ii) = sum(Lj(Atemp(ii,:)'==1));%ksum(ii)表示与第ii个节点相连的所有节点的初始负荷的和
       end
       ksum(ksum==0)=-1;%将ksum数组中为0的元素设为-1
       Lij = Ljtemp*Lj'.*Atemp./repmat(ksum,1,length(k));
       Ljtemp = Ljtemp+sum( Lij.*repmat(init_node,1,length(k)) ,1)';%崩溃指定节点上的负荷重新分配到它的邻居节点上，之后所形成的临时节点负荷
       %Lij.*repmat(init_node,1,length(k))表示init_node数组中指定的失效节点，失效后对应的各个邻居节点所得额外负荷
       %sum(Lij.*repmat(init_node,1,length(k)),1)'表示所有指定失效节点失效后，各个节点所获的额外负荷
       init_node = ((Ljtemp>Cj)-Nattack)>0;   %（Ljtemp>Cj)表示节点负荷大于节点处理负荷的能力Cj的点，即删除指定节点导致级联失效的节点，
       %（(Ljtemp>Cj)-Nattack)>0表示init_node中只有删除指定节点后导致级联失效的节点，不包括要删除的指定节点
       Nattack = Nattack + init_node;%表示删除指定节点后经过，之前的失效节点累加这一次级联失效迭代后的节点总数
       I=I+1;
       Atemp(find(attact_node==1),:)=0;
       Atemp(:,find(attact_node==1))=0;
   end
   Si(temp) = sum(Nattack);%表示攻击指定节点后所导致的，反复级联失效迭代后的总失效节点的数量
    Ljtemp = Lj;%重新赋值临时节点负荷。每次攻击一个节点后，进行初始化，再攻击下一个节点
end
SN=sum(Si)/(length(k)*(length(k)-1));