function b=ainc2adj(x)% 邻接表生成邻接矩阵
%x为邻接表，2列n行，第一列为起始点，第二列为终止点
if min(x(:))==0;
x=x+1;
end
d=length(x);
a=max(max(x));
b=zeros(a,a);
for i=1:d
    if x(i,1)==x(i,2)
        b(x(i,1),x(i,2))=0;
    else
        b(x(i,1),x(i,2))=1;
         b(x(i,2),x(i,1))=1;
    end
end