function dif=dif(c1,c2)
% ���ȡ�ắ���Ĵ��ۻ���һ���������������
%c1 ���� c2 Ŀ�귽��
n = 72; % ������Ŀ
%dif = min([abs(c1-c2), abs(c1-c2-n), abs(c1-c2+n)]);
dif=abs(c1-c2);