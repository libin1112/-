function fxbest=filt(a,b)
%����ɸѡ���� a:���� b:Ŀ�귽��
geshu=length(a);
if geshu==1
    fxbest=a;
elseif geshu==2
    if a(1)==a(2)
        fxbest=a(1);
    else
        g=zeros(geshu,1);how=zeros(geshu,1);  
        for i=1:geshu
             g(i)=a(i);
             how(i)=howmanyss(g(i),b);
        end
        ft=find(how==min(how));
        fxbest=g(ft);
    end
elseif geshu==3
    if a(1)==a(2)&&a(2)==a(3) %3������һ��
        fxbest=a(1);
    elseif a(1)==a(2)&&a(2)~=a(3) %3��������2��һ��1
        g=zeros(geshu-1,1);how=zeros(geshu-1,1);
        c=[a(2),a(3)];
        for i=1:geshu-1
             g(i)=c(i);
             how(i)=howmanyss(g(i),b);
        end
        ft=find(how==min(how));
        fxbest=g(ft);
    elseif a(1)~=a(2)&&a(2)==a(3) %3��������2��һ��2
        g=zeros(geshu-1,1);how=zeros(geshu-1,1);
        c=[a(1),a(2)];
        for i=1:geshu-1
             g(i)=c(i);
             how(i)=howmanyss(g(i),b);
        end
        ft=find(how==min(how));
        fxbest=g(ft);
    elseif a(1)~=a(2)&&a(1)==a(3) %3��������2��һ��3
        g=zeros(geshu-1,1);how=zeros(geshu-1,1);
        c=[a(1),a(2)];
        for i=1:geshu-1
             g(i)=c(i);
             how(i)=howmanyss(g(i),b);
        end
        ft=find(how==min(how));
        fxbest=g(ft);
    else %3�����򶼲�һ��
        g=zeros(geshu,1);how=zeros(geshu,1);
        c=[a(1),a(2),a(3)];
        for i=1:geshu
             g(i)=c(i);
             how(i)=howmanyss(g(i),b);
        end
        ft=find(how==min(how));
        fxbest=g(ft);
    end
elseif geshu==4
    fxbest=a(1);
end
 