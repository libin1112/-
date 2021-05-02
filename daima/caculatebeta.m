%����Ƕ�
%�õ��ĽǶ�(������) ����360�����ڵ����Ƕ�
function beta = caculatebeta(s,e)
dy = e(2) - s(2);
dx = e(1) - s(1);
if dx==0
    beta=pi/2;
else
    beta = atan(dy/dx); 
    if(dx < 0)
        if(dy > 0)
            beta = pi - abs(beta);
        else
            beta = pi + abs(beta);
        end
    else
        if(dy < 0)
            beta = 2*pi- abs(beta);
        end
    end
end


