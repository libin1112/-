function [ valueij ] = Iij(d)
%UNTITLED3 ���Ԫ��Iijֵ
%   ʹ����VFH*TDT����ģ��ʽ
rsafe=0.6; %����������0.3 ����
dmax=1.8;
    if (d<=rsafe)
        valueij=1;
    else if (rsafe<d<=dmax)
        valueij=(dmax^2-d^2)/(dmax^2-rsafe^2); 
    else   
        valueij=0;
    end
end

