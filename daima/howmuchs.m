function cost=howmuchs(c1,c2,c3,c4,c5) 
% �����ж�һ����ѷ������ֵ���ۺ���
% c1:��ǰ��ֵ���� c2:�����ֵ���� c3:���鱸ѡ����ĸ��� c4:һ�鱸ѡ���� c5:Ŀ�귽��
omaga=10;
sum=0;
for i=1:c3
    sum=sum+abs(c4(i)-c5);
end 
cost=omaga*(c2-c1)+sum;