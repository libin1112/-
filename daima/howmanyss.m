function dif=howmanyss(c1,c2)
% �������VFH+�㷨�ó��˶���1����ѷ����ʱ�� ���õ�ȡ�ắ��
n = 72; % ������Ŀ
dif = min([abs(c1-c2), abs(c1-c2-n), abs(c1-c2+n)]);
%dif=abs(c1-c2);