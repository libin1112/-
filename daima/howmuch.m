function cost=howmuch(c1,c2,c3,c4)
% ���Ǽ�����ֵ�������ŷ�����ۺ�ֵ�ĺ���
omaga=10;
dirt=abs(c2-c3);
cost=omaga*(c4-c1)+dirt;