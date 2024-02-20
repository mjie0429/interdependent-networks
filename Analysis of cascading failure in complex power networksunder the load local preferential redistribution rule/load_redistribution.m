function SN=load_redistribution(A,u,p)
%A��������ڽӾ���
%ÿ�ι��������һ���ڵ㣬���������ط��伶��ʧЧ�ȶ��󣬼�����Ӧ�Ĺ��Ͻڵ�����Si
%���㹥�����еĽڵ����ʧЧ�������ĵ�SN
k=sum(A,2);            %������ӵõ�һ���о���,��a1�����ÿһ���ڵ���ڲ���
Lj=k.^u;       %��ʼ����Lj�ĺ������壬��������ڵ�ĳ�ʼ����
Cj=(1+p)*Lj;           %�ڵ㴦���ɵ�����Cj1������Lj1�����ȣ�p>0,pΪ�Ա���

ksum = zeros(length(k),1);
for ii=1:length(k)            
    ksum(ii) = sum(Lj(A(ii,:)'==1));%ksum(ii)��ʾ���ii���ڵ����������нڵ�ĳ�ʼ���ɵĺ�
end
ksum(ksum==0)=-1;%��ksum������Ϊ0��Ԫ����Ϊ-1
Lij = Lj*Lj'.*A./repmat(ksum,1,length(k));%%���ı��ʽΪ���㼶��ʧЧ�������ھӽڵ�Ķ��⸺�ɡ�Lij�ļ��㹫ʽ
                                          %%��ʾÿ���ڵ������������Ӧ�������ھӽڵ����յ��Ķ��⸺�ɣ�Lij(i,j)��ʾi�ڵ�ʧЧ������Ӧ���ھӽڵ�j��õĶ��⸺��
                                          %%repmat(ksum,1,length(k))��ʾ���������ÿһ����ͬ�������е�ÿ��Ԫ��Ϊÿ���ڵ������ھӽڵ�ĸ���֮��
                                          %%ע��:Lj*Lj'.*A��ʾ�ڵ�i�ĸ��ɣ�����������Ӧ���ھӽڵ�j�ĸ���֮�� 
                                          %%Lj'.*A./repmat(ksum,1,length(k))��ʾ���Ÿ���(���Ͻڵ㽫���ϸ��ذ���ʽ����ʾ�������ݸ��ڵ�j)
Ljtemp = Lj;%���м������ʼ����Lj�ڵ㸺�ɵ�ֵ�����Ź����仯��
Si = zeros(length(k),1);      %��CF���г�ʼ��
for temp = 1:length(k)   %��Ҫ���������ÿһ���ڵ㣬����ѭ��k��    
    init_node = zeros(length(k),1); %���м�ֵ���г�ʼ��
    init_node(temp) = 1;%ָ������Ҫ�����Ľڵ㣬attacknode(temp)��ʾ����ָ���ڵ��ID,���±�
    Nattack = init_node;%��ʼ���м�ֵ�����м�ֵΪʧЧ�ڵ�
   Atemp=A;
   I=0;
   while(sum(init_node)>0) %������0ʱ��ʾ����Ҫ���������Ľڵ㣬����ѭ��
       attact_node=init_node;
       ksum = zeros(length(k),1);
       for ii=1:length(k)
           ksum(ii) = sum(Lj(Atemp(ii,:)'==1));%ksum(ii)��ʾ���ii���ڵ����������нڵ�ĳ�ʼ���ɵĺ�
       end
       ksum(ksum==0)=-1;%��ksum������Ϊ0��Ԫ����Ϊ-1
       Lij = Ljtemp*Lj'.*Atemp./repmat(ksum,1,length(k));
       Ljtemp = Ljtemp+sum( Lij.*repmat(init_node,1,length(k)) ,1)';%����ָ���ڵ��ϵĸ������·��䵽�����ھӽڵ��ϣ�֮�����γɵ���ʱ�ڵ㸺��
       %Lij.*repmat(init_node,1,length(k))��ʾinit_node������ָ����ʧЧ�ڵ㣬ʧЧ���Ӧ�ĸ����ھӽڵ����ö��⸺��
       %sum(Lij.*repmat(init_node,1,length(k)),1)'��ʾ����ָ��ʧЧ�ڵ�ʧЧ�󣬸����ڵ�����Ķ��⸺��
       init_node = ((Ljtemp>Cj)-Nattack)>0;   %��Ljtemp>Cj)��ʾ�ڵ㸺�ɴ��ڽڵ㴦���ɵ�����Cj�ĵ㣬��ɾ��ָ���ڵ㵼�¼���ʧЧ�Ľڵ㣬
       %��(Ljtemp>Cj)-Nattack)>0��ʾinit_node��ֻ��ɾ��ָ���ڵ���¼���ʧЧ�Ľڵ㣬������Ҫɾ����ָ���ڵ�
       Nattack = Nattack + init_node;%��ʾɾ��ָ���ڵ�󾭹���֮ǰ��ʧЧ�ڵ��ۼ���һ�μ���ʧЧ������Ľڵ�����
       I=I+1;
       Atemp(find(attact_node==1),:)=0;
       Atemp(:,find(attact_node==1))=0;
   end
   Si(temp) = sum(Nattack);%��ʾ����ָ���ڵ�������µģ���������ʧЧ���������ʧЧ�ڵ������
    Ljtemp = Lj;%���¸�ֵ��ʱ�ڵ㸺�ɡ�ÿ�ι���һ���ڵ�󣬽��г�ʼ�����ٹ�����һ���ڵ�
end
SN=sum(Si)/(length(k)*(length(k)-1));