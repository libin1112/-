function cost=heu(a,b,c,d)
% ����VFH*�㷨ͶӰ�ڵ������ֵ����
% a:Ŀ�귽�� b:��ǰ�˶����� c:�ϴ�ѡ���� d:ͶӰ���
n = 72; % ������Ŀ
lmd=0.8;% ����ϵ��
u2=1;% ϵ�����뵱ǰ�˶�����Ĳ��
u3=1;% ϵ��������һ��ѡ��ķ���Ĳ��
dirt2 = min([abs(a-b), abs(a-b-n), abs(a-b+n)]);
dirt3 = min([abs(a-c), abs(a-c-n), abs(a-c+n)]);
cost = lmd^d*(u2*dirt2+u3*dirt3);