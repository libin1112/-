function cost=howmanys(c1,c2,c3,c4,a,b,c,d)
% ����VFH*�㷨ͶӰ�ڵ�ķ����ж����ۺ���
% c1:��ѡ���� c2:Ŀ�귽�� c3:��ǰ�˶����� c4:��һ��ѡ���� a:��ѡ����ļ��ϰ����ܶ� b:��ѡ���ܶ� c:��ѡ���ܶ� d:ͶӰ���
n = 72; % ������Ŀ
lmd=0.8;% ����ϵ��
u1=5;% ϵ������Ŀ�귽��Ĳ��
u2=1;% ϵ�����뵱ǰ�˶�����Ĳ��
u3=1;% ϵ��������һ��ѡ��ķ���Ĳ��
u4=1;% ϵ�����Ľ����ۺ�������ѡ�����������������ļ��ϰ����ܶ�
dirt1 = min([abs(c1-c2), abs(c1-c2-n), abs(c1-c2+n)]);
dirt2 = min([abs(c1-c3), abs(c1-c3-n), abs(c1-c3+n)]);
dirt3 = min([abs(c1-c4), abs(c1-c4-n), abs(c1-c4+n)]);
if b~=inf
   if c~=inf 
   cost = lmd^d*(u1*dirt1+u2*dirt2+u3*dirt3+u4*[a+b+c]/3*(dirt1+dirt2+dirt3));
   else
   cost = lmd^d*(u1*dirt1+u2*dirt2+u3*dirt3+u4*[a+b]/2*(dirt1+dirt2+dirt3));    
   end
else
   cost = lmd^d*(u1*dirt1+u2*dirt2+u3*dirt3+u4*[a+c]/2*(dirt1+dirt2+dirt3)); 
end