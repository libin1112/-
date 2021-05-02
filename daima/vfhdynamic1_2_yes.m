%��̬��������̬�ϰ��VFH·���滮����
%������̬�ϰ��һ��Բ
load obstacle 'obstacle';
plot(obstacle(:,1),obstacle(:,2),'.k');
hold on
x0=1; y0=2.5;  %Բ����ʼ����
r=0.15; %Բ�İ뾶
time=0.1; %ʱ����

v_car=0.5; %С���ٶȴ�С
load startpoint 'startpoint'; %������ʼ��
load endpoint 'endpoint';   %������ʼ��
plot(startpoint(1),startpoint(2),'.b');
hold on
plot(endpoint(1),endpoint(2),'.r')
hold on
title('VFH��̬·���滮');
%�������� 
%��������
f=5;                                      %�Ƿֱ���,��λ����
dmax = 1;                             %��Ұ �����뾶 ��Զ����  dmaxҲ����ȡ�ࣺܶ1.8  1.7  1.9  2.0  1.0  0.5  0.45  0.35 0.15
smax = 18;                                %����18Ϊ����
C=15;                                     %cvֵ��ԭʼֵ15
alpha = deg2rad(f);                       %�ֱ����ɽǶ�תΪ���� ��λ������
n=360/f;                                  %��Ϊ72������, n=72
rsafe=0.3;                                %����뾶�Ͱ�ȫ����0.6 �ϰ�����򻯴��� 0.3
% ��̬��ֵ�Ĳ���
D=0.125;                                  %ɲ������
lmda=1.5;                                 %��ȫ�Ŵ�ϵ��
Dthmax=0.5;                                 %�����ֵ���� ��ȡ3 2 0.5
Dthmin=round(lmda*(D+rsafe));             %��С��ֵ����
thresholdlow=C^2*Iij(Dthmin);             %��С��ֵ
dirtD=0.05;                                %��ֵ�������� ����ȡ0.2 0.1 0.05
blcs=round(Dthmax/dirtD);                 %��ֵ��������
% ��ʼ����
robot=startpoint;                         %������λ����ʼ��λ��
ref=robot;                                %�ο�λ�ã�������һ��ʼ��û��
radius=0.1;                              %��������Сת��뾶 ����ȡ0.35  0.15 0.05 0.1
%VFH*�㷨�Ĳ���
%�����������Ϊ ng=2
%ds=step;  %ͶӰ���� 
step=0.29 %��ǰ�ǲ��� ��������� �����Ѿ����ٶȡ�ʱ�������

kt=round(caculatebeta(robot,endpoint)/alpha);    %�ȶ���Ŀ�귽��
if(kt==0)
    kt=n;
end

for i=0:time:13.5
    
    if i<=4 %��һ�׶Σ�ʱ��Σ�
        v=1.2; phiv=(5/18)*pi; %�ٶȴ�С������
        %����Բ����ʼλ��
        plot(x0,y0,'.b');
        hold on
        x0=x0+v*cos(phiv)*time;  %Բ���˶�����   %Բ�ķ���
        y0=y0+v*sin(phiv)*time;  %Բ���˶�����   ����
        %����Բ��ʵʱλ��
        scatter(x0,y0,'.r');
        drawnow;
        %plot(x0,y0,'r');
        phi=2*pi/3600:2*pi/3600:2*pi; %Բ�ϵ�ȡ����
        x=x0+r*cos(phi);y=y0+r*sin(phi); %Բ�ķ���
        xy=[];
        xy=[xy;x;y];
        xy=xy'; %ת�ú� �õ�Բ�ϸ�������� 
        plot(x,y,'.g');
        hold on
        mid=xy;
        obstacle=cat(1,obstacle,mid);  %��̬�ϰ�����뾲̬�ϰ������� catΪ����ƴ�Ӻ��� 1����ƴ 2����ƴ
        
        %%% ���ڿ�ʼ����·���滮
        if(norm(robot-endpoint))>step          % ������λ�ú��յ�λ�ò�����0.1ʱ
        else
            break
        end
        %���Ƚ����ϰ���ļ�ֱ��ͼ
        i=1;mag = zeros(n,1);his=zeros(n,1);
        % ����һ�γ���õ�������360�ȷ�Χ��Ұ�ڵ��ϰ���ֲ�ֵ 72�������ļ��ϰ����ܶ�
        while (i<=length(obstacle)) 
           d = norm(obstacle(i,:) - robot); % �ϰ���դ���������֮�����
            if (d<dmax)
                beta = caculatebeta(robot,obstacle(i,:));  % �ϰ���դ�������ķ���
                rangle=asin(rsafe/d);        % ����ĽǶ�
                k = round(beta/alpha);       % ��ʱ��������k����������
                if(k == 0)
                    k = 1;
                end
                % ���º�ļ�����ֱ��ͼ��hֵ
                if((5*k>rad2deg(beta)-rad2deg(rangle))&&(5*k<rad2deg(beta)+rad2deg(rangle)))  
                    h(k)=1;
                else
                    h(k)=0;
                end
                i=i+1;
                m = C^2*Iij(d);   % �ϰ���դ���������ֵ����VFH���㷽����ͬ
                mag(k)=max(mag(k),m.*h(k));   % magΪzeros(n,1)��mag�ĵ�k��Ԫ��Ϊm
                i=i+1;
            else
                i=i+1;
            end
        end
        %����Ӧ��VFH+�㷨�������˶��뾶���� �ų����������
        i4=1;
        if  norm(robot-ref)==0
            km=kt;
        else
            km=dc;
        end
        k1=0;
        k2=0;       
        alpha;
        while (i4<=length(obstacle))
            % ����ת��뾶����
            dirtr(1)=radius*sin(km*alpha); 
            dirtr(2)=radius*cos(km*alpha);         %��ת�����Ĳ���
            centerr(1)=robot(1)+dirtr(1); centerr(2)=robot(2)+dirtr(2); %��ת����������
            dirtl(1)=-radius*sin(km*alpha);  dirtl(2)=-radius*cos(km*alpha);        %��ת�����Ĳ���
            centerl(1)=robot(1)+dirtl(1); centerl(2)=robot(2)+dirtl(2); %��ת����������
            %dor=norm(obstacle(i,:) - centerr);                          %�ϰ��ﵽ��ת�����ĵľ���
            %dor=norm(obstacle(i,:) - centerl);                          %�ϰ��ﵽ��ת�����ĵľ���
            dirtor(1)=obstacle(i4)-robot(1); dirtor(2)=obstacle(2)-robot(2); %�ϰ��ﵽ�����˵������
            disor=(dirtr(1)-dirtor(1))^2+(dirtr(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
            disol=(dirtl(1)-dirtor(1))^2+(dirtl(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
            if 0<=km&&km<36
                k1=k1+1
                phib=km+36; %��ʼ���޽Ƕ�=�˶�����ķ�����
                phil=phib;  %��ʼ���޽Ƕ�
                phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                beta = caculatebeta(robot,obstacle(i4,:));
                k = round(beta/alpha); %�ϰ������ڵ�����
                if km<=k&&k<phil  %�ϰ�������������
                    if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                        phil=k;
                        i5=phil;
                        while (phil<=i5&&i5<=phib)
                            mag(i5)=max(mag);
                            i5=i5+1;
                        end
                    end
                else
                %if (0<=k<km|phir<=k<=n) %�ϰ������Ұ������
                    if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                        phir=k;
                        if phir<=k&&k<=n
                            i6=phib;
                            while (phib<=i6&&i6<=phir)
                                mag(i6)=max(mag);
                                i6=i6+1;
                            end
                        else
                        %if 0<=k<=km
                            i7=phib;
                            while (phib<=i7&&i7<=72)
                                mag(i7)=max(mag);
                                i7=i7+1;
                            end
                            i8=1;
                            while (0<=i8&&i8<=phir)
                                mag(i8)=max(mag);
                                i8=i8+1;
                            end
                        end
                    end
                end
            elseif 36<=km&&km<=72
               k2=k2+1
               phib=km-36; %��ʼ���޽Ƕ�=�˶�����ķ����� 
               phil=phib;  %��ʼ���޽Ƕ�
               phir=phib;  %��ʼ�Ҽ��޽Ƕ�
               beta = caculatebeta(robot,obstacle(i4,:));
               k = round(beta/alpha); %�ϰ������ڵ�����
               if k~=0
               else
                   k=1;
               end
               if phir<=k&&k<km  %�ϰ������Ұ������
                  if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                     phir=k;
                     i9=phib;
                     while (phib<=i9&&i9<=phir)
                           mag(i9)=max(mag);
                           i9=i9+1;
                     end
                  end
               else
               %if (km<=k<72|0<=k<=phil) %�ϰ�������������
                   if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                      phil=k;
                        if 0<=k&&k<=phib
                            i10=phil;

                            while (phil<=i10&&i10<=phib)
                                mag(i10)=max(mag);
                                i10=i10+1;
                            end
                        else
                        %if km<=k<=72
                            i11=1;
                            while (0<=i11&&i11<=phib)
                                mag(i11)=max(mag);
                                i11=i11+1;
                            end
                            i12=1;
                            while (phil<=i12&&i12<=72)
                                mag(i12)=max(mag);
                                i12=i12+1;
                            end
                        end
                   end
               end  
            end
            i4=i4+1;
        end
        his=mag;      %���� his ��һ����72��Ԫ�ص�����--���������ϰ����ܶ�
        %������������Ӧ��ֵ��һ�鱸ѡ����һ���������ɸ���ѡ����
        i1=1; %����Ӧ��ֵ��ѭ������
        kb=cell(1,blcs);
        howth=[];
        while (i1<=blcs)   % ����Ӧ��ֵ��whileѭ��������i1 i1ȡ9��ʱ�� ����ĳһ��ͣ�� i1ȡ15��ʱ�� ��ɱ��ϣ�˵������Ӧ��ֵ��Ч������
            %kb2=zeros(9,1);
            %howth2=zeros(9,1);
            Dt=norm(robot-endpoint);
            Dth(i1)=Dthmax-i1*dirtD;
            c=[];
            if  Dth(i1)<Dt
                threshold(i1)=C^2*Iij(Dth(i1));
                j=1;q=1;
                
                while (q<=n)       
                    %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                    if(his(q)< threshold(i1))
                        kr=q;                        % �ҵ��˲��ȵ����
                        while(q<=n && his(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                            kl=q;
                            q=q+1;
                        end

                        if(kl-kr > smax)                  % ����
                            c   =  [c round(kl - smax/2)];  % �������
                            c   =  [c round(kr + smax/2)];  % �����Ҳ�
                            %j=j+1;
                            if(kt >= kr && kt <= kl)
                                c  = [c kt];                % straight at look ahead
                                %j=j+1;
                            end
                         elseif(kl-kr > smax/5)           % խ����
                            c   =  [c round((kr+kl)/2-2.5)];
                            %j=j+1;
                         end

                    else
                        q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                    end                                   % �˳�ifѡ���ٴν���while����ѭ��
                end                                       % �˳�whileѭ��
                % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                numb=length(c);
                temp2=howmuchs(Dth(i1),Dthmax,numb,c,kt);
            end 
            kb{1,i1}=c;
            howth=[howth temp2];       %�洢��ֵ�ۺϴ���    
            i1=i1+1;
        end
        ftth=find(howth==min(howth));
        kbbest=kb{1,ftth(1)};   %��ʱ�����һ�������ֵ�µ����ɱ�ѡ����
        %���ڣ�Ҫ�ж��Ƿ����VFH*�㷨����·���滮
        %�ж����鱸ѡ�����ܷ�ֳ������飺��ȷ����ǰ�˶�����
        %���һ��
        %if  (0<=km&&km<=round((ds/radius)/alpha))||(72-round((ds/radius)/alpha)<=km&&km<=72) 
        if 0<=km&&km<=round((ds/radius)/alpha)  %������
           lml=km+round((ds/radius)/alpha); %��߽�
           lmr=km-round((ds/radius)/alpha)+72; %�ұ߽�
           numb1=length(kbbest); 
           phib=km+36; %��ǰ�˶�������
           tempkl=[];
           tempkr=[];
           for j1=1:numb1
               if km<=kbbest(j1)&&kbbest(j1)<=lml  %��߷���ɴ�
                  tempkl=[tempkl kbbest(j1)];
               %end
               elseif lml<=kbbest(j1)&&kbbest(j1)<=phib %��߷��򲻿ɴ�
                  tempkl=[tempkl lml];
               %end
               elseif phib<=kbbest(j1)&&kbbest(j1)<=lmr %�ұ߷��򲻿ɴ�
                  tempkr=[tempkr lmr];
               %end
               elseif lmr<=kbbest(j1)&&kbbest(j1)<=72  %�ұ߷���ɴ� ״̬һ
                  tempkr=[tempkr kbbest(j1)];
               %end
               %if 0<=kbbest(j1)<=km  %�ұ߷���ɴ� ״̬�� 
               else
                  tempkr=[tempkr kbbest(j1)]; 
               end
           end         
        %else
        elseif 72-round((ds/radius)/alpha)<=km&&km<=72  %�۽����
           lml=km+round((ds/radius)/alpha)-72;  %��߽�
           if lml~=0
           else
              lml=1; 
           end
           lmr=km-round((ds/radius)/alpha);  %�ұ߽�
           numb1=length(kbbest);
           phib=km-36;  %��ǰ�˶�������
           tempkl=[];
           tempkr=[];
           for j2=1:numb1
               if phib<=kbbest(j2)&&kbbest(j2)<=lmr  %�ұ߷��򲻿ɴ�
                  tempkr=[tempkr lmr]; 
               %end
               elseif lmr<=kbbest(j2)&&kbbest(j2)<=km  %�ұ߷���ɴ�
                  tempkr=[tempkr kbbest(j2)]; 
               %end
               elseif km<=kbbest(j2)&&kbbest(j2)<=72  %��߷���ɴ� ״̬һ
                  tempkl=[tempkl kbbest(j2)];
               %end
               elseif 0<=kbbest(j2)&&kbbest(j2)<=lml  %��߷���ɴ� ״̬��
                  tempkl=[tempkl kbbest(j2)]; 
               %end
               else
               %if lml<=kbbest(j2)<=phib  %��߷��򲻿ɴ�
                  tempkl=[tempkl lml]; 
               end
           end
        
        %end
        %�����
        elseif  round((ds/radius)/alpha)<=km&&km<=36 
            lml=km+round((ds/radius)/alpha); %��߽�
            lmr=km-round((ds/radius)/alpha); %�ұ߽�
            numb1=length(kbbest); 
            phib=km+36; %��ǰ�˶�������
            tempkl=[];
            tempkr=[];
            for j3=1:numb1
                if km<=kbbest(j3)&&kbbest(j3)<=lml  %��߷���ɴ�
                   tempkl=[tempkl kbbest(j3)]; 
                %end
                elseif lml<=kbbest(j3)&&kbbest(j3)<=phib  %��߷��򲻿ɴ�
                   tempkl=[tempkl lml]; 
                %end
                elseif km<=kbbest(j3)&&kbbest(j3)<=lmr  %�ұ߷���ɴ�
                   tempkr=[tempkr kbbest(j3)]; 
                %end
                else
                tempkr=[tempkr lmr];  %�ұ߷��򲻿ɴ�
                end
            end 
        %end
        else
        %�����
        %if  36<=km<=72-round((ds/radius)/alpha)
            lml=km+round((ds/radius)/alpha); %��߽�
            lmr=km-round((ds/radius)/alpha); %�ұ߽�
            numb1=length(kbbest); 
            phib=km-36; %��ǰ�˶�������
            tempkl=[];
            tempkr=[];
            for j4=1:numb1
                if lmr<=kbbest(j4)&&kbbest(j4)<=km  %�ұ߷���ɴ�
                   tempkr=[tempkr kbbest(j4)]; 
                %end
                elseif phib<=kbbest(j4)&&kbbest(j4)<=lmr  %�ұ߷��򲻿ɴ�
                   tempkr=[tempkr lmr]; 
                %end
                elseif km<=kbbest(j4)&&kbbest(j4)<=lml  %��߷���ɴ�
                   tempkl=[tempkl kbbest(j4)]; 
                %end
                else
                tempkl=[tempkl lml];  %��߷��򲻿ɴ�
                end
            end
        end
        % �ж��Ƿ����VFH*�㷨 ���������ǲ��Ƕ�������һ������
        geshul=length(tempkl);
        geshur=length(tempkr);
        if  geshul>=1&&geshur>=1  %��������-��ʼ����VFH*�㷨
            refp=cell(1,6);  %δ��ͶӰλ�õ�����
            gc=cell(1,6);  %δ��ͶӰλ�õĴ���
            hc=cell(1,6);  %δ��ͶӰλ�õ�����ֵ
            fc=cell(1,6);  %δ��ͶӰλ�õ��ۺ��ж�ֵ
            pp=cell(1,6);  %δ��ͶӰλ�õĽڵ�
            pfcun=zeros(1,4);  %����ÿ���ڵ����ѷ���
            ng=1;  % ��ʼVFH* ��һ������
            %��ȷ����һ���ڵ�����ҷ���
            if  norm(robot-ref)==0
                lc=kt;
            else
            %if  norm(robot-ref)~=0
                lc=lc;
            end 
            g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
            for i14=1:geshul
                g1l(i14)=tempkl(i14);
                order1l=g1l(i14);
                ol1l=g1l(i14)-1;
                or1l=g1l(i14)+1;
                if ol1l~=0
                   if or1l~=73
                   how1l(i14,1)=howmany(g1l(i14),kt,km,lc,his(order1l),his(ol1l),his(or1l));
                   else
                   how1l(i14,1)=howmany(g1l(i14),kt,km,lc,his(order1l),his(ol1l),inf);    
                   end
                else
                   how1l(i14,1)=howmany(g1l(i14),kt,km,lc,his(order1l),inf,his(or1l)); 
                end
            end
            ft1l=find(how1l==min(how1l));
            ft1l;
            
            pf1lbest=filt(g1l(ft1l),kt);  %�ҵ������ѷ���
            g1r=zeros(geshur,1);how1r=zeros(geshur,1);  %�ұ�ǰ������
            for i15=1:geshur
                g1r(i15)=tempkr(i15);
                order1r=g1r(i15);
                ol1r=g1r(i15)-1;
                or1r=g1r(i15)+1;
                if ol1r~=0
                   if or1r~=73 
                   how1r(i15)=howmany(g1r(i15),kt,km,lc,his(order1r),his(ol1r),his(or1r));
                   else
                   how1r(i15)=howmany(g1r(i15),kt,km,lc,his(order1r),his(ol1r),inf);    
                   end
                else
                   how1r(i15)=howmany(g1r(i15),kt,km,lc,his(order1r),inf,his(or1r));
                end
            end
            ft1r=find(how1r==min(how1r));
            pf1rbest=filt(g1r(ft1r),kt);  %�ҵ��ұ���ѷ���
            %ǰ����ͶӰ��
            pp{1,1}=robot+[v_car*time*cos(pf1lbest*alpha),v_car*time*sin(pf1lbest*alpha)];
            pp{1,2}=robot+[v_car*time*cos(pf1rbest*alpha),v_car*time*sin(pf1rbest*alpha)];
            ol1l=pf1lbest-1;
            or1l=pf1lbest+1;
            order1l=pf1lbest;
            if ol1l~=0
               if or1l~=73 
               gc{1,1}=howmanys(pf1lbest,kt,km,lc,his(order1l),his(ol1l),his(or1l),ng);
               else
               gc{1,1}=howmanys(pf1lbest,kt,km,lc,his(order1l),his(ol1l),inf,ng);    
               end
            else
               gc{1,1}=howmanys(pf1lbest,kt,km,lc,his(order1l),inf,his(or1l),ng); 
            end
            ol1r=pf1rbest-1;
            or1r=pf1rbest+1;
            order1r=pf1rbest;
            if ol1r~=0
               if or1r~=73  
               gc{1,2}=howmanys(pf1rbest,kt,km,lc,his(order1r),his(ol1r),his(or1r),ng);
               else
               gc{1,2}=howmanys(pf1rbest,kt,km,lc,his(order1r),his(ol1r),inf,ng);    
               end
            else
               gc{1,2}=howmanys(pf1rbest,kt,km,lc,his(order1r),inf,his(or1r),ng); 
            end
            kt1l=round(caculatebeta(pp{1,1},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
            kt1r=round(caculatebeta(pp{1,2},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
            hc{1,1}=heu(kt1l,pf1lbest,pf1lbest,ng);
            hc{1,2}=heu(kt1r,pf1rbest,pf1rbest,ng);
            fc{1,1}=gc{1,1}+hc{1,1};
            fc{1,2}=gc{1,2}+hc{1,2};
            % ��ʼ VFH* �ڶ�������
            ng=ng+1;
            % ������һ��ͶӰ��ļ�ֱ��ͼ
            i2=1;mag1l = zeros(n,1);his1l=zeros(n,1);
            while (i2<=length(obstacle))  
            
            %%%%%%%%%%% ����һ�γ���õ�ͶӰ��һ��360�ȷ�Χ��Ұ�ڵ��ϰ���ֲ�ֵ 72�������ļ��ϰ����ܶ�  
            
                d1l = norm(obstacle(i2,:) - pp{1,1}); % �ϰ���դ���������֮�����
                if (d1l<dmax)
                    beta1l = caculatebeta(pp{1,1},obstacle(i2,:));  % �ϰ���դ�������ķ���
                    rangle1l=asin(rsafe/d1l);        % ����ĽǶ�
                    k1l = round(beta1l/alpha);       % ��ʱ��������k����������
                    if(k1l == 0)
                        k1l = 1;
                    end
                    % ���º�ļ�����ֱ��ͼ��hֵ
                    if((5*k1l>rad2deg(beta1l)-rad2deg(rangle1l))&&(5*k1l<rad2deg(beta1l)+rad2deg(rangle1l)))  
                        h1l(k1l)=1;
                    else
                        h1l(k1l)=0;
                    end
                    i2=i2+1;

                    m1l = C^2*Iij(d1l);   % �ϰ���դ���������ֵ����VFH���㷽����ͬ
                    mag1l(k1l)=max(mag1l(k1l),m1l.*h1l(k1l));   % magΪzeros(n,1)��mag�ĵ�k��Ԫ��Ϊm
                    i2=i2+1;
                else
                    i2=i2+1;
                end
            end
            % ��һ��ͶӰ�㣺��VFH+�ų�һЩ����
            i41l=1; %Ӧ��VFH+�㷨�������˶��뾶���� �ų����������
            if  norm(pp{1,1}-ref)==0
                km=kt;
            else
            %if  norm(pp{1,1}-ref)~=0
                km=pf1lbest;
            end
            while (i41l<=length(obstacle))

                %%%%%%%%%% ����ת��뾶����
                    km
                    dirtr(1)=radius*sin(km*alpha);   dirtr(2)=radius*cos(km*alpha);         %��ת�����Ĳ���
                    centerr(1)=pp{1,1}(1)+dirtr(1); centerr(2)=pp{1,1}(2)+dirtr(2); %��ת����������
                    dirtl(1)=-radius*sin(km*alpha);  dirtl(2)=-radius*cos(km*alpha);        %��ת�����Ĳ���
                    centerl(1)=pp{1,1}(1)+dirtl(1); centerl(2)=pp{1,1}(2)+dirtl(2); %��ת����������
                    %dor=norm(obstacle(i,:) - centerr);                          %�ϰ��ﵽ��ת�����ĵľ���
                    %dor=norm(obstacle(i,:) - centerl);                          %�ϰ��ﵽ��ת�����ĵľ���
                    dirtor(1)=obstacle(i41l)-pp{1,1}(1); dirtor(2)=obstacle(2)-pp{1,1}(2); %�ϰ��ﵽ�����˵������
                    disor=(dirtr(1)-dirtor(1))^2+(dirtr(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    disol=(dirtl(1)-dirtor(1))^2+(dirtl(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    if 0<=km&&km<36
                        phib=km+36; %��ʼ���޽Ƕ�=�˶�����ķ�����
                        phil=phib;  %��ʼ���޽Ƕ�
                        phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                        beta = caculatebeta(pp{1,1},obstacle(i41l,:));
                        k = round(beta/alpha); %�ϰ������ڵ�����
                        if km<=k&&km<phil  %�ϰ�������������
                            if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phil=k;
                                i5=phil;
                                while (phil<=i5&&i5<=phib)
                                    mag1l(i5)=max(mag1l);
                                    i5=i5+1;
                                end
                            end
                        else
                        %if (0<=k<km|phir<=k<=n) %�ϰ������Ұ������
                            if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phir=k;
                                if phir<=k&&k<=n
                                    i6=phib;
                                    while (phib<=i6&&i6<=phir)
                                        mag1l(i6)=max(mag1l);
                                        i6=i6+1;
                                    end
                                else
                                %if 0<=k<=km
                                    i7=phib;
                                    while (phib<=i7&&i7<=72)
                                        mag1l(i7)=max(mag1l);
                                        i7=i7+1;
                                    end
                                    i8=1;
                                    while (0<=i8&&i8<=phir)
                                        mag1l(i8)=max(mag1l);
                                        i8=i8+1;
                                    end
                                end
                            end
                        end
                    else
                    %if 36<=km<=72
                       phib=km-36; %��ʼ���޽Ƕ�=�˶�����ķ����� 
                       phil=phib;  %��ʼ���޽Ƕ�
                       phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                       beta = caculatebeta(pp{1,1},obstacle(i41l,:));
                       k = round(beta/alpha); %�ϰ������ڵ�����
                       if k~=0
                       else
                           k=1;
                       end
                       if phir<=k&&k<km  %�ϰ������Ұ������
                          if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                             phir=k;
                             i9=phib;
                             while (phib<=i9&&i9<=phir)
                                   mag1l(i9)=max(mag1l);
                                   i9=i9+1;
                             end
                          end
                       else
                       %if (km<=k<72|0<=k<=phil) %�ϰ�������������
                           if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                              phil=k;
                                if 0<=k&&k<=phib
                                    i10=phil;
                                    while (phil<=i10&&i10<=phib)
                                        mag1l(i10)=max(mag1l);
                                        i10=i10+1;
                                    end
                                else
                                %if km<=k<=72
                                    i11=1;
                                    while (0<=i11&&i11<=phib)
                                        mag1l(i11)=max(mag1l);
                                        i11=i11+1;
                                    end
                                    i12=1;
                                    while (phil<=i12&&i12<=72)
                                        mag1l(i12)=max(mag1l);
                                        i12=i12+1;
                                    end
                                end
                           end
                       end  
                    end
                    i41l=i41l+1;
            end
        
            his1l=mag1l;      %���� his ��һ����72��Ԫ�ص�����--���������ϰ����ܶ�
            % ��һ��ͶӰ�㣺ѡȡһ����ѱ�ѡ����
            i1=1; %����Ӧ��ֵ��ѭ������
            kb=cell(1,blcs);
            howth=[];
            while (i1<=blcs)   % ����Ӧ��ֵ��whileѭ��������i1 i1ȡ9��ʱ�� ����ĳһ��ͣ�� i1ȡ15��ʱ�� ��ɱ��ϣ�˵������Ӧ��ֵ��Ч������
                %kb2=zeros(9,1);
                %howth2=zeros(9,1);
                Dt=norm(pp{1,1}-endpoint);
                Dth(i1)=Dthmax-i1*dirtD;
                c=[];
                if  Dth(i1)<Dt
                    threshold(i1)=C^2*Iij(Dth(i1));
                    j=1;q=1;
                    
                    while (q<=n)       
                        %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                        if(his1l(q)< threshold(i1))
                            kr=q;                        % �ҵ��˲��ȵ����
                            while(q<=n && his1l(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                                kl=q;
                                q=q+1;
                            end

                            if(kl-kr > smax)                  % ����
                                c   = [c round(kl - smax/2)];  % �������
                                c   = [c round(kr + smax/2)];  % �����Ҳ�
                                %j=j+2;
                                if(kt1l >= kr && kt1l <= kl)
                                    c  = [c kt1l];                % straight at look ahead
                                    %j=j+1;
                                end
                             elseif(kl-kr > smax/5)           % խ����
                                c  = [c round((kr+kl)/2-2.5)];
                                %j=j+1;
                             end

                        else
                            q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                        end                                   % �˳�ifѡ���ٴν���while����ѭ��
                    end                                       % �˳�whileѭ��

                    % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                    numb=length(c);
                    temp2=howmuchs(Dth(i1),Dthmax,numb,c,kt1l);
                end 

                %temp1=howmuch(Dth(i1),fk,kt,Dthmax);   
                kb{1,i1}=c;
                howth=[howth temp2];       %�洢��ֵ�ۺϴ���    
                i1=i1+1;
            end
            ftth=find(howth==min(howth));
            kbbest1l=kb{1,ftth(1)};   %��ʱ�����һ�������ֵ�µ����ɱ�ѡ����
            %��һ��ͶӰ�㣺�ܷ������
            
            %���һ��
            %if  0<=km<=round((ds/radius)/alpha)||72-round((ds/radius)/alpha)<=km<=72 
            if 0<=km&&km<=round((ds/radius)/alpha)  %������
               lml=km+round((ds/radius)/alpha); %��߽�
               lmr=km-round((ds/radius)/alpha)+72; %�ұ߽�
               numb1=length(kbbest1l); 
               phib=km+36; %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j1=1:numb1
                   if km<=kbbest1l(j1)&&kbbest1l(j1)<=lml  %��߷���ɴ�
                      tempkl=[tempkl kbbest1l(j1)];
                   %end
                   elseif lml<=kbbest1l(j1)&&kbbest1l(j1)<=phib %��߷��򲻿ɴ�
                      tempkl=[tempkl lml];
                   %end
                   elseif phib<=kbbest1l(j1)&&kbbest1l(j1)<=lmr %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr];
                   %end
                   elseif lmr<=kbbest1l(j1)&&kbbest1l(j1)<=72  %�ұ߷���ɴ� ״̬һ
                      tempkr=[tempkr kbbest1l(j1)];
                   %end
                   else
                   %if 0<=kbbest1l(j1)<=km  %�ұ߷���ɴ� ״̬��   
                      tempkr=[tempkr kbbest1l(j1)]; 
                   end
               end         
            
            elseif 72-round((ds/radius)/alpha)<=km&&km<=72  %�۽����
               lml=km+round((ds/radius)/alpha)-72;  %��߽�
               if lml~=0
               else
                  lml=1; 
               end
               lmr=km-round((ds/radius)/alpha);  %�ұ߽�
               numb1=length(kbbest1l);
               phib=km-36;  %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j2=1:numb1
                   if phib<=kbbest1l(j2)&&kbbest1l(j2)<=lmr  %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr]; 
                   %end
                   elseif lmr<=kbbest1l(j2)&&kbbest1l(j2)<=km  %�ұ߷���ɴ�
                      tempkr=[tempkr kbbest1l(j2)]; 
                   %end
                   elseif km<=kbbest1l(j2)&&kbbest1l(j2)<=72  %��߷���ɴ� ״̬һ
                      tempkl=[tempkl kbbest1l(j2)];
                   %end
                   elseif 0<=kbbest1l(j2)&&kbbest1l(j2)<=lml  %��߷���ɴ� ״̬��
                      tempkl=[tempkl kbbest1l(j2)]; 
                   %end
                   else
                   %if lml<=kbbest1l(j2)<=phib  %��߷��򲻿ɴ�
                      tempkl=[tempkl lml]; 
                   end
               end
            
            %end
            %�����
            elseif  round((ds/radius)/alpha)<=km&&km<=36 
                lml=km+round((ds/radius)/alpha); %��߽�
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1l); 
                phib=km+36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j3=1:numb1
                    if km<=kbbest1l(j3)&&kbbest1l(j3)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1l(j3)]; 
                    %end
                    elseif lml<=kbbest1l(j3)&&kbbest1l(j3)<=phib  %��߷��򲻿ɴ�
                       tempkl=[tempkl lml]; 
                    %end
                    elseif km<=kbbest1l(j3)&&kbbest1l(j3)<=lmr  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1l(j3)]; 
                    else
                    tempkr=[tempkr lmr];  %�ұ߷��򲻿ɴ�
                    end
                end 
            %end
            else
            %�����
            %if  36<=km<=72-round((ds/radius)/alpha)
                lml=km+round((ds/radius)/alpha); %��߽�
                if lml~=0
                else
                   lml=1; 
                end
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1l); 
                phib=km-36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j4=1:numb1
                    if lmr<=kbbest1l(j4)&&kbbest1l(j4)<=km  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1l(j4)]; 
                    %end
                    elseif phib<=kbbest1l(j4)&&kbbest1l(j4)<=lmr  %�ұ߷��򲻿ɴ�
                       tempkr=[tempkr lmr]; 
                    %end
                    elseif km<=kbbest1l(j4)&&kbbest1l(j4)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1l(j4)]; 
                    else
                    tempkl=[tempkl lml];  %��߷��򲻿ɴ� 
                    end
                end
            end
            
            geshul=length(tempkl);
            geshur=length(tempkr);
            %��һ��ͶӰ�㣺�ܷ�����
            if  geshul>=1&&geshur>=1  
                lc=pf1lbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                       if or1l~=73 
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l));
                       else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),inf);   
                       end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),inf,his1l(or1l));
                    end
                end
                ft1ll=find(how1l==min(how1l));
                pf1llbest=filt(g1l(ft1ll),kt1l);  %�ҵ������ѷ��� 
                g1r=zeros(geshur,1);how1r=zeros(geshur,1);  %�ұ�ǰ������
                for i15=1:geshur
                    g1r(i15)=tempkr(i15);
                    order1r=g1r(i15);
                    ol1r=g1r(i15)-1;
                    or1r=g1r(i15)+1;
                    if ol1r~=0
                       if or1r~=73
                       how1r(i15)=howmany(g1r(i15),kt1l,km,lc,his1l(order1r),his1l(ol1r),his1l(or1r));
                       else
                       how1r(i15)=howmany(g1r(i15),kt1l,km,lc,his1l(order1r),his1l(ol1r),inf);    
                       end
                    else
                       how1r(i15)=howmany(g1r(i15),kt1l,km,lc,his1l(order1r),inf,his1l(or1r));
                    end
                end
                ft1lr=find(how1r==min(how1r));
                pf1lrbest=filt(g1r(ft1lr),kt1l);  %�ҵ��ұ���ѷ���
                %ǰ����ͶӰ��
                pp{1,3}=pp{1,1}+[v_car*time*cos(pf1llbest*alpha),v_car*time*sin(pf1llbest*alpha)];
                pp{1,4}=pp{1,1}+[v_car*time*cos(pf1lrbest*alpha),v_car*time*sin(pf1lrbest*alpha)];
                ol1l=pf1llbest-1;
                or1l=pf1llbest+1;
                order1l=pf1llbest;
                if ol1l~=0
                   if or1l~=73 
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l),ng)+gc{1,1};
                   else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),inf,ng)+gc{1,1};    
                   end
                else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),inf,his1l(or1l),ng)+gc{1,1}; 
                end
                ol1r=pf1lrbest-1;
                or1r=pf1lrbest+1;
                order1r=pf1lrbest;
                if ol1r~=0
                   if or1r~=73 
                   gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1r),his1l(ol1r),his1l(or1r),ng)+gc{1,1};
                   else
                   gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1r),his1l(ol1r),inf,ng)+gc{1,1};    
                   end
                else
                   gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1r),inf,his1l(or1r),ng)+gc{1,1}; 
                end
                kt1ll=round(caculatebeta(pp{1,3},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                kt1lr=round(caculatebeta(pp{1,4},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,3}=heu(kt1ll,pf1llbest,pf1llbest,ng);
                hc{1,4}=heu(kt1lr,pf1lrbest,pf1lrbest,ng);
                fc{1,3}=gc{1,3}+hc{1,3};
                fc{1,4}=gc{1,4}+hc{1,4};
                pfcun(1,1)=pf1llbest;
                pfcun(1,2)=pf1lrbest;
            %end
            %��һ��ͶӰ�㣺���ܷ����� ֻ��һ������
            elseif  geshul>=1&&geshur==0  %�÷�������
                lc=pf1lbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                       if or1l~=73 
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l));
                       else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),inf);    
                       end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),inf,his1l(or1l)); 
                    end
                end
                ft1ll=find(how1l==min(how1l));
                pf1llbest=filt(g1l(ft1ll),kt1l);  %�ҵ������ѷ��� 
                pp{1,3}=pp{1,1}+[v_car*time*cos(pf1llbest*alpha),v_car*time*sin(pf1llbest*alpha)];
                ol1l=pf1llbest-1;
                or1l=pf1llbest+1;
                order1l=pf1llbest;
                if ol1l~=0
                   if or1l~=73 
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l),ng)+gc{1,1};
                   else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),inf,ng)+gc{1,1};   
                   end
                else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),inf,his1l(or1l),ng)+gc{1,1}; 
                end
                kt1ll=round(caculatebeta(pp{1,3},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,3}=heu(kt1ll,pf1llbest,pf1llbest,ng);
                fc{1,3}=gc{1,3}+hc{1,3};
                fc{1,4}=inf;
                pfcun(1,1)=pf1llbest;
            %end
            elseif  geshur>=1&&geshul==0  %�÷�������
                lc=pf1lbest;
                g1l=zeros(geshur,1);how1l=zeros(geshur,1);  %�ұ�ǰ������ 
                for i14=1:geshur
                    g1l(i14)=tempkr(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                        if or1l~=73
                        how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l));
                        else
                        how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),inf);    
                        end
                    else
                        how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),inf,his1l(or1l)); 
                    end
                end
                ft1lr=find(how1l==min(how1l));
                pf1lrbest=filt(g1l(ft1lr),kt1l);  %�ҵ��ұ���ѷ��� 
                pp{1,4}=pp{1,1}+[v_car*time*cos(pf1lrbest*alpha),v_car*time*sin(pf1lrbest*alpha)];
                ol1l=pf1lrbest-1;
                or1l=pf1lrbest+1;
                order1l=pf1lrbest;
                if ol1l~=0
                    if or1l~=73
                    gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l),ng)+gc{1,1};
                    else
                    gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),inf,ng)+gc{1,1};    
                    end
                else
                    gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1l),inf,his1l(or1l),ng)+gc{1,1};
                end
                kt1lr=round(caculatebeta(pp{1,4},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,4}=heu(kt1lr,pf1lrbest,pf1lrbest,ng);
                fc{1,4}=gc{1,4}+hc{1,4};
                fc{1,3}=inf;
                pfcun(1,2)=pf1lrbest;
            %end
            %��һ��ͶӰ�㣺���ܷ����� �޷���
            else
            %if  geshul==geshur==0
                fc{1,3}=inf;
                fc{1,4}=inf;
            end
            % �����ڶ���ͶӰ��ļ�ֱ��ͼ
            i3=1;mag1r = zeros(n,1);his1r=zeros(n,1);
            while (i3<=length(obstacle))  
            
            %%%%%%%%%%% ����һ�γ���õ�������360�ȷ�Χ��Ұ�ڵ��ϰ���ֲ�ֵ 72�������ļ��ϰ����ܶ�  
            
                d1r = norm(obstacle(i3,:) - pp{1,2}); % �ϰ���դ���������֮�����
                if (d1r<dmax)
                    beta1r = caculatebeta(pp{1,2},obstacle(i3,:));  % �ϰ���դ�������ķ���
                    rangle1r=asin(rsafe/d1r);        % ����ĽǶ�
                    k1r = round(beta1r/alpha);       % ��ʱ��������k����������
                    if(k1r == 0)
                        k1r = 1;
                    end
                    % ���º�ļ�����ֱ��ͼ��hֵ
                    if((5*k1r>rad2deg(beta1r)-rad2deg(rangle1r))&&(5*k1r<rad2deg(beta1r)+rad2deg(rangle1r)))  
                        h1r(k1r)=1;
                    else
                        h1r(k1r)=0;
                    end
                    i3=i3+1;

                    m1r = C^2*Iij(d1r);   % �ϰ���դ���������ֵ����VFH���㷽����ͬ
                    mag1r(k1r)=max(mag1r(k1r),m1r.*h1r(k1r));   % magΪzeros(n,1)��mag�ĵ�k��Ԫ��Ϊm
                    i3=i3+1;
                else
                    i3=i3+1;
                end 
            end
            %�ڶ���ͶӰ�㣺��VFH+�ų�һЩ����
            i41r=1; %Ӧ��VFH+�㷨�������˶��뾶���� �ų����������
            km=pf1rbest;
            while (i41r<=length(obstacle))

                %%%%%%%%%% ����ת��뾶����
                    
                    dirtr(1)=radius*sin(km*alpha);   dirtr(2)=radius*cos(km*alpha);         %��ת�����Ĳ���
                    centerr(1)=pp{1,2}(1)+dirtr(1); centerr(2)=pp{1,2}(2)+dirtr(2); %��ת����������
                    dirtl(1)=-radius*sin(km*alpha);  dirtl(2)=-radius*cos(km*alpha);        %��ת�����Ĳ���
                    centerl(1)=pp{1,2}(1)+dirtl(1); centerl(2)=pp{1,2}(2)+dirtl(2); %��ת����������
                    %dor=norm(obstacle(i,:) - centerr);                          %�ϰ��ﵽ��ת�����ĵľ���
                    %dor=norm(obstacle(i,:) - centerl);                          %�ϰ��ﵽ��ת�����ĵľ���
                    dirtor(1)=obstacle(i41r)-pp{1,2}(1); dirtor(2)=obstacle(2)-pp{1,2}(2); %�ϰ��ﵽ�����˵������
                    disor=(dirtr(1)-dirtor(1))^2+(dirtr(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    disol=(dirtl(1)-dirtor(1))^2+(dirtl(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    if 0<=km&&km<36
                        phib=km+36; %��ʼ���޽Ƕ�=�˶�����ķ�����
                        phil=phib;  %��ʼ���޽Ƕ�
                        phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                        beta = caculatebeta(pp{1,2},obstacle(i41r,:));
                        k = round(beta/alpha); %�ϰ������ڵ�����
                        if km<=k&&k<phil  %�ϰ�������������
                            if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phil=k;
                                i5=phil;
                                while (phil<=i5&&i5<=phib)
                                    mag1r(i5)=max(mag1r);
                                    i5=i5+1;
                                end
                            end
                        else
                        %if (0<=k<km|phir<=k<=n) %�ϰ������Ұ������
                            if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phir=k;
                                if phir<=k&&k<=n
                                    i6=phib;
                                    while (phib<=i6&&i6<=phir)
                                        mag1r(i6)=max(mag1r);
                                        i6=i6+1;
                                    end
                                else
                                %if 0<=k<=km
                                    i7=phib;
                                    while (phib<=i7&&i7<=72)
                                        mag1r(i7)=max(mag1r);
                                        i7=i7+1;
                                    end
                                    i8=1;
                                    while (0<=i8&&i8<=phir)
                                        mag1r(i8)=max(mag1r);
                                        i8=i8+1;
                                    end
                                end
                            end
                        end
                    else
                    %if 36<=km<=72
                       phib=km-36; %��ʼ���޽Ƕ�=�˶�����ķ����� 
                       phil=phib;  %��ʼ���޽Ƕ�
                       phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                       beta = caculatebeta(pp{1,2},obstacle(i41r,:));
                       k = round(beta/alpha); %�ϰ������ڵ�����
                       if k~=0
                       else
                          k=1;
                       end
                       if phir<=k&&k<km  %�ϰ������Ұ������
                          if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                             phir=k;
                             i9=phib;
                             while (phib<=i9&&i9<=phir)
                                   mag1r(i9)=max(mag1r);
                                   i9=i9+1;
                             end
                          end
                       else
                       %if (km<=k<72|0<=k<=phil) %�ϰ�������������
                           if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                              phil=k;
                                if 0<=k&&k<=phib
                                    i10=phil;
                                    while (phil<=i10&&i10<=phib)
                                        i10
                                        mag1r(i10)=max(mag1r);
                                        i10=i10+1;
                                    end
                                else
                                %if km<=k<=72
                                    i11=1;
                                    while (0<=i11&&i11<=phib)
                                        mag1r(i11)=max(mag1r);
                                        i11=i11+1;
                                    end
                                    i12=1;
                                    while (phil<=i12&&i12<=72)
                                        mag1r(i12)=max(mag1r);
                                        i12=i12+1;
                                    end
                                end
                           end
                       end  
                    end
                    i41r=i41r+1;
            end
        
            his1r=mag1r;      %���� his ��һ����72��Ԫ�ص�����--���������ϰ����ܶ�
            %�ڶ���ͶӰ�㣺ѡȡһ����ѱ�ѡ����
            i1=1; %����Ӧ��ֵ��ѭ������
            kb=cell(1,blcs);
            howth=[];
            while (i1<=blcs)   % ����Ӧ��ֵ��whileѭ��������i1 i1ȡ9��ʱ�� ����ĳһ��ͣ�� i1ȡ15��ʱ�� ��ɱ��ϣ�˵������Ӧ��ֵ��Ч������
                %kb2=zeros(9,1);
                %howth2=zeros(9,1);
                Dt=norm(pp{1,2}-endpoint);
                Dth(i1)=Dthmax-i1*dirtD;
                c=[];
                if  Dth(i1)<Dt
                    threshold(i1)=C^2*Iij(Dth(i1));
                    j=1;q=1;
                    
                    while (q<=n)       
                        %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                        if(his1r(q)< threshold(i1))
                            kr=q;                        % �ҵ��˲��ȵ����
                            while(q<=n && his1r(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                                kl=q;
                                q=q+1;
                            end

                            if(kl-kr > smax)                  % ����
                                c   = [c round(kl - smax/2)];  % �������
                                c   = [c round(kr + smax/2)];  % �����Ҳ�
                                %j=j+2;
                                if(kt1r >= kr && kt1r <= kl)
                                    c  = [c kt1r];                % straight at look ahead
                                    %j=j+1;
                                end
                             elseif(kl-kr > smax/5)           % խ����
                                c  = [c round((kr+kl)/2-2.5)];
                                %j=j+1;
                             end

                        else
                            q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                        end                                   % �˳�ifѡ���ٴν���while����ѭ��
                    end                                       % �˳�whileѭ��

                    % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                    numb=length(c);
                    temp2=howmuchs(Dth(i1),Dthmax,numb,c,kt1r);
                end 

                %temp1=howmuch(Dth(i1),fk,kt,Dthmax);   
                kb{1,i1}=c;
                howth=[howth temp2];       %�洢��ֵ�ۺϴ���    
                i1=i1+1;
            end
            ftth=find(howth==min(howth));
            kbbest1r=kb{1,ftth(1)};   %��ʱ�����һ�������ֵ�µ����ɱ�ѡ����
            %�ڶ���ͶӰ�㣺�ܷ������
            %���һ��
            %if  0<=km<=round((ds/radius)/alpha)||72-round((ds/radius)/alpha)<=km<=72 
            if 0<=km&&km<=round((ds/radius)/alpha)  %������
               lml=km+round((ds/radius)/alpha); %��߽�
               lmr=km-round((ds/radius)/alpha)+72; %�ұ߽�
               numb1=length(kbbest1r); 
               phib=km+36; %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j1=1:numb1
                   if km<=kbbest1r(j1)&&kbbest1r(j1)<=lml  %��߷���ɴ�
                      tempkl=[tempkl kbbest1r(j1)];
                   %end
                   elseif lml<=kbbest1r(j1)&&kbbest1r(j1)<=phib %��߷��򲻿ɴ�
                      tempkl=[tempkl lml];
                   %end
                   elseif phib<=kbbest1r(j1)&&kbbest1r(j1)<=lmr %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr];
                   %end
                   elseif lmr<=kbbest1r(j1)&&kbbest1r(j1)<=72  %�ұ߷���ɴ� ״̬һ
                      tempkr=[tempkr kbbest1r(j1)];
                   %end
                   else
                   %if 0<=kbbest1r(j1)<=km  %�ұ߷���ɴ� ״̬��   
                      tempkr=[tempkr kbbest1r(j1)]; 
                   end
               end         
            
            elseif 72-round((ds/radius)/alpha)<=km&&km<=72  %�۽����
               lml=km+round((ds/radius)/alpha)-72;  %��߽�
               if lml~=0
               else
                  lml=1; 
               end
               lmr=km-round((ds/radius)/alpha);  %�ұ߽�
               numb1=length(kbbest1r);
               phib=km-36;  %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j2=1:numb1
                   if phib<=kbbest1r(j2)&&kbbest1r(j2)<=lmr  %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr]; 
                   %end
                   elseif lmr<=kbbest1r(j2)&&kbbest1r(j2)<=km  %�ұ߷���ɴ�
                      tempkr=[tempkr kbbest1r(j2)]; 
                   %end
                   elseif km<=kbbest1r(j2)&&kbbest1r(j2)<=72  %��߷���ɴ� ״̬һ
                      tempkl=[tempkl kbbest1r(j2)];
                   %end
                   elseif 0<=kbbest1r(j2)&&kbbest1r(j2)<=lml  %��߷���ɴ� ״̬��
                      tempkl=[tempkl kbbest1r(j2)]; 
                   %end
                   else
                   %if lml<=kbbest1r(j2)<=phib  %��߷��򲻿ɴ�
                      tempkl=[tempkl lml]; 
                   end
               end
            %end
            %end
            %�����
            elseif  round((ds/radius)/alpha)<=km&&km<=36 
                lml=km+round((ds/radius)/alpha); %��߽�
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1r); 
                phib=km+36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j3=1:numb1
                    if km<=kbbest1r(j3)&&kbbest1r(j3)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1r(j3)]; 
                    %end
                    elseif lml<=kbbest1r(j3)&&kbbest1r(j3)<=phib  %��߷��򲻿ɴ�
                       tempkl=[tempkl lml]; 
                    %end
                    elseif km<=kbbest1r(j3)&&kbbest1r(j3)<=lmr  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1r(j3)]; 
                    else
                    tempkr=[tempkr lmr];  %�ұ߷��򲻿ɴ�
                    end
                end 
            %end
            %�����
            else
            %if  36<=km<=72-round((ds/radius)/alpha)
                lml=km+round((ds/radius)/alpha); %��߽�
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1r); 
                phib=km-36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j4=1:numb1
                    if lmr<=kbbest1r(j4)&&kbbest1r(j4)<=km  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1r(j4)]; 
                    %end
                    elseif phib<=kbbest1r(j4)&&kbbest1r(j4)<=lmr  %�ұ߷��򲻿ɴ�
                       tempkr=[tempkr lmr]; 
                    %end
                    elseif km<=kbbest1r(j4)&&kbbest1r(j4)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1r(j4)]; 
                    else
                    tempkl=[tempkl lml];  %��߷��򲻿ɴ�
                    end
                end
            end
            
            geshul=length(tempkl);
            geshur=length(tempkr);
            %�ڶ���ͶӰ�㣺�ܷ�����
            if  geshul>=1&&geshur>=1  
                lc=pf1rbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                        if or1l~=73
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l));
                        else
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),inf);    
                        end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),inf,his1r(or1l)); 
                    end
                end
                ft1rl=find(how1l==min(how1l));
                pf1rlbest=filt(g1l(ft1rl),kt1r);  %�ҵ������ѷ��� 
                g1r=zeros(geshur,1);how1r=zeros(geshur,1);  %�ұ�ǰ������
                for i15=1:geshur
                    g1r(i15)=tempkr(i15);
                    order1r=g1r(i15);
                    ol1r=g1r(i15)-1;
                    or1r=g1r(i15)+1;
                    if ol1r~=0
                       if or1r~=73 
                       how1r(i15)=howmany(g1r(i15),kt1r,km,lc,his1r(order1r),his1r(ol1r),his1r(or1r));
                       else
                       how1r(i15)=howmany(g1r(i15),kt1r,km,lc,his1r(order1r),his1r(ol1r),inf);    
                       end
                    else
                       how1r(i15)=howmany(g1r(i15),kt1r,km,lc,his1r(order1r),inf,his1r(or1r)); 
                    end
                end
                ft1rr=find(how1r==min(how1r));
                pf1rrbest=filt(g1r(ft1rr),kt1r);  %�ҵ��ұ���ѷ���
                pp{1,5}=pp{1,2}+[v_car*time*cos(pf1rlbest*alpha),v_car*time*sin(pf1rlbest*alpha)];
                pp{1,6}=pp{1,2}+[v_car*time*cos(pf1rrbest*alpha),v_car*time*sin(pf1rrbest*alpha)];
                ol1l=pf1rlbest-1;
                or1l=pf1rlbest+1;
                order1l=pf1rlbest;
                if ol1l~=0
                   if or1l~=73
                   gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l),ng)+gc{1,2};
                   else
                   gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),inf,ng)+gc{1,2};    
                   end
                else
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),inf,his1r(or1l),ng)+gc{1,2}; 
                end
                ol1r=pf1rrbest-1;
                or1r=pf1rrbest+1;
                order1r=pf1rrbest;
                if ol1r~=0
                   if or1r~=73
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1r),his1r(ol1r),his1r(or1r),ng)+gc{1,2};
                   else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1r),his1r(ol1r),inf,ng)+gc{1,2};    
                   end
                else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1r),inf,his1r(or1r),ng)+gc{1,2}; 
                end
                kt1rl=round(caculatebeta(pp{1,5},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                kt1rr=round(caculatebeta(pp{1,6},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,5}=heu(kt1rl,pf1rlbest,pf1rlbest,ng);
                hc{1,6}=heu(kt1rr,pf1rrbest,pf1rrbest,ng);
                fc{1,5}=gc{1,5}+hc{1,5};
                fc{1,6}=gc{1,6}+hc{1,6};
                pfcun(1,3)=pf1rlbest;
                pfcun(1,4)=pf1rrbest;
            %end
            %�ڶ���ͶӰ�㣺���ܷ����� ֻ��һ������
            elseif  geshul>=1&&geshur==0  %�÷�������
                lc=pf1rbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                tempkl
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                        if or1l~=73 
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l));
                        else
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),inf);    
                        end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),inf,his1r(or1l)); 
                    end
                end
                ft1rl=find(how1l==min(how1l));
                pf1rlbest=filt(g1l(ft1rl),kt1r);  %�ҵ������ѷ���
                pp{1,5}=pp{1,2}+[v_car*time*cos(pf1rlbest*alpha),v_car*time*sin(pf1rlbest*alpha)];
                ol1l=pf1rlbest-1;
                or1l=pf1rlbest+1;
                order1l=pf1rlbest;
                if ol1l~=0
                    if or1l~=73 
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l),ng)+gc{1,2};
                    else
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),inf,ng)+gc{1,2};
                    end
                else
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),inf,his1r(or1l),ng)+gc{1,2};
                end
                kt1rl=round(caculatebeta(pp{1,5},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,5}=heu(kt1rl,pf1rlbest,pf1rlbest,ng);
                fc{1,5}=gc{1,5}+hc{1,5};
                fc{1,6}=inf;
                pfcun(1,3)=pf1rlbest;
            %end
            elseif  geshur>=1&&geshul==0  %�÷�������
                lc=pf1rbest;
                g1l=zeros(geshur,1);how1l=zeros(geshur,1);  %�ұ�ǰ������ 
                for i14=1:geshur
                    g1l(i14)=tempkr(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                       if or1l~=73 
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l));
                       else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),inf);
                       end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),inf,his1r(or1l)); 
                    end
                end
                ft1rr=find(how1l==min(how1l));
                pf1rrbest=filt(g1l(ft1rr),kt1r);  %�ҵ��ұ���ѷ���
                pp{1,6}=pp{1,2}+[v_car*time*cos(pf1rrbest*alpha),v_car*time*sin(pf1rrbest*alpha)];
                ol1l=pf1rrbest-1;
                or1l=pf1rrbest+1;
                order1l=pf1rrbest;
                if ol1l~=0
                   if or1l~=73  
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l),ng)+gc{1,2};
                   else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),inf,ng)+gc{1,2};
                   end
                else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1l),inf,his1r(or1l),ng)+gc{1,2}; 
                end
                kt1rr=round(caculatebeta(pp{1,6},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,6}=heu(kt1rr,pf1rrbest,pf1rrbest,ng);
                fc{1,6}=gc{1,6}+hc{1,6};
                fc{1,5}=inf;
                pfcun(1,4)=pf1rrbest;
            else
            %�ڶ���ͶӰ�㣺���ܷ����� �޷���
            %if  geshul==geshur==0
                fc{1,5}=inf;
                fc{1,6}=inf;
            end
            pd=[fc{1,3},fc{1,4},fc{1,5},fc{1,6}]  %�ж�ֵ
            ft=find(pd==min(pd)) %�ҳ������ڵ�fcֵ��С��
            dcyb=pfcun(1,ft);
            %lc=dc;
            
            if  length(ft)==1
                lc=dcyb;
                dc=dcyb;
                robot=pp{1,ft+2};  %VFH*�㷨�õ�������λ�ò����������
            elseif  length(ft)==2 %ע�� ft �� dcyb ��ʱ��2��1�еľ���2��1��
                geshu=length(dcyb);
                if dcyb(1)==dcyb(geshu)
                   dc=dcyb(1); 
                   lc=dc;
                   robot=pp{1,ft(1)+2};
                else
                   kt_1=round(caculatebeta(pp{1,ft(1)+2},endpoint)/alpha);
                   kt_2=round(caculatebeta(pp{1,ft(2)+2},endpoint)/alpha);
                   g_=zeros(geshu,1);how_=zeros(geshu,1);xushu=zeros(geshu,1);
                   kt_=[kt_1 kt_2];
                   for i14=1:geshu
                       g_(i14)=dcyb(i14);
                       how_(i14)=howmanyss(g_(i14),kt_(i14));
                       xushu(i14)=ft(i14);
                   end
                   if how_(1)~=how_(2)
                       ft_=find(how_==min(how_));
                       dc=g_(ft_);
                       lc=dc;
                       robot=pp{1,xushu(ft_)};
                   else
                       g__=zeros(geshu,1);how__=zeros(geshu,1);xushu_=zeros(geshu,1);
                       for i14=1:geshu
                           g__(i14)=dcyb(i14);
                           how__(i14)=dif(g__(i14),kt_(i14));
                           xushu_(i14)=ft(i14);
                       end
                       ft__=find(how__==min(how__));
                       dc=g__(ft__);
                       lc=dc;
                       robot=pp{1,xushu(ft__)};
                   end
                 end
            end

            %��ǰ�˶�����
            %�ϴ�ѡ����
        else   %���������VFH*�㷨 �Ǿ�ʹ��VFH+�㷨�ж�
            if  norm(robot-ref)==0
                lc=kt;
            else
                lc=lc;
            end
            
            i1=1; %����Ӧ��ֵ��ѭ������
            kb=[];%������ѷ��򼯺�
            howth=[];%������ֵ�����ֵ�·���Ĵ��ۼ���
            
            % ����Ӧ��ֵ��ʼ��
            
            while (i1<=blcs)
                Dt=norm(robot-endpoint);
                Dth(i1)=Dthmax-i1*dirtD;
                c=[];
                if  Dth(i1)<Dt
                    threshold(i1)=C^2*Iij(Dth(i1));
                    j=1;q=1;

                    while (q<=n)       
                        %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                        if(his(q)< threshold(i1))
                            kr=q;                        % �ҵ��˲��ȵ����
                            while(q<=n && his(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                                kl=q;
                                q=q+1;
                            end

                            if(kl-kr > smax)                  % ����
                                c   =  [c round(kl - smax/2)];  % �������
                                c   =  [c round(kr + smax/2)];  % �����Ҳ�
                                j=j+2;
                                if(kt >= kr && kt <= kl)
                                    c  = [c kt];                % straight at look ahead
                                    j=j+1;
                                end
                            elseif(kl-kr > smax/5)           % խ����
                                c   =  [c round((kr+kl)/2-2.5)];
                                j=j+1;
                            end

                        else
                            q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                        end                                   % �˳�ifѡ���ٴν���while����ѭ��
                    end                                       % �˳�whileѭ��

                    % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                    % ��ʼɸѡ���ŷ���
                    if norm(robot-ref)==0                            
                       g=zeros(j-1,1);how=zeros(j-1,1);
                       for i2=1:j-1
                           g(i2)=c(i2);     %g�в���Ŀ������
                           order=g(i2);
                           ol=g(i2)-1;
                           or=g(i2)+1;
                           dc=kt;           %���ڻ����˻�û��������Ŀ�귽����ǵ�ǰ�˶�����
                           lc=kt;           %���ڻ����˻�û��������Ŀ�귽������ϴ�ѡ����
                           if ol~=0   %��ֹ���ֵ�0���73
                              if or~=73
                               how(i2)=howmany(g(i2),kt,dc,lc,his(order),his(ol),his(or)); %���ۺ����������ŷ��� howΪ���� Ԫ�ظ����� g ����ͬ��
                              else
                               how(i2)=howmany(g(i2),kt,dc,lc,his(order),his(ol),inf);   
                              end
                           else
                              how(i2)=howmany(g(i2),kt,dc,lc,his(order),inf,his(or)); 
                           end 
                       end                                                             
                       ft=find(how==min(how));
                       fk=g(ft);
                       kb=[kb fk];  % ��ǰ��ֵ�µ���ѱ�ѡ����
                    else
                       g=zeros(j-1,1);how=zeros(j-1,1);
                       for i3=1:j-1
                           g(i3)=c(i3);
                           order=g(i3);
                           ol=g(i3)-1;
                           or=g(i3)+1;
                           if ol~=0   %��ֹ���ֵ�0���73
                              if or~=73
                               how(i3)=howmany(g(i3),kt,dc,lc,his(order),his(ol),his(or));
                              else
                               how(i3)=howmany(g(i3),kt,dc,lc,his(order),his(ol),inf);   
                              end
                           else
                              how(i3)=howmany(g(i3),kt,dc,lc,his(order),inf,his(or)); 
                           end
                       end
                       ft=find(how==min(how));
                       fk=g(ft);
                       kb=[kb fk];  % ��ǰ��ֵ�µ���ѱ�ѡ����
                    end 
                    
                    temp1=howmuch(Dth(i1),fk,kt,Dthmax); %���� ��ֵ�����ֵ����ѷ�����ۺϴ���
                    howth=[howth temp1]; %�洢�ۺϴ���
                end
                i1=i1+1;
            end
            ft=find(howth==min(howth));
            fbestyb=kb(ft);  %VFH+�㷨�õ�����÷���
            % ��ֹ�ж�����ŷ���
            if  length(ft)==1
                dc=fbestyb;       % ��ǰ���˶�����
                lc=dc;       % ��һ��ѡ��ķ���
                robot=robot+[v_car*time*cos(fbestyb*alpha),v_car*time*sin(fbestyb*alpha)];  %VFH+�㷨�õ�������λ�ò����������
            elseif  length(ft)==2 %ע�� ft �� dcyb ��ʱ��2��1�еľ���2��1��
                geshu=length(fbestyb);
                if fbestyb(1,1)==fbestyb(geshu,1)
                   dc=fbestyb(1,1);  % ��ǰ���˶�����
                   lc=dc; % ��һ��ѡ��ķ���
                   robot=robot+[v_car*time*cos(lc*alpha),v_car*time*sin(lc*alpha)];
                else
                   
                   g_=zeros(geshu,1);how_=zeros(geshu,1);  
                   for i14=1:geshu
                        g_(i14)=fbestyb(i14);
                        how_(i14)=howmanyss(g_(i14),kt);
                   end
                   ft_=find(how_==min(how_));
                   dc=g_(ft_); % ��ǰ���˶�����
                   lc=dc; % ��һ��ѡ��ķ���
                   robot=robot+[v_car*time*cos(lc*alpha),v_car*time*sin(lc*alpha)];
                end    
            elseif  length(ft)==3
                geshu=length(fbestyb);
                g_=zeros(geshu,1);how_=zeros(geshu,1);  
                   for i14=1:geshu
                        g_(i14)=fbestyb(i14);
                        how_(i14)=howmanyss(g_(i14),kt);
                   end
                   ft_=find(how_==min(how_));
                   dc=g_(ft_); % ��ǰ���˶�����
                   lc=dc; % ��һ��ѡ��ķ���
                   robot=robot+[v_car*time*cos(lc*alpha),v_car*time*sin(lc*alpha)];
            %else 
            end
        end
        ref=startpoint;
        scatter(robot(1),robot(2),'.r');
        drawnow;
        kt=round(caculatebeta(robot,endpoint)/alpha);  %�µ�Ŀ�귽��
        if(kt==0)
            kt=n;
        end
        if(norm(robot-endpoint))>step          % ������λ�ú��յ�λ�ò�����0.1ʱ
        else
            break
        end
        %���˱��Ϲ滮һ�����
        obstacle([5271:8870],:)=[];    %������Ϻ��޳���̬�ϰ���
        obstacle;
    elseif 4<i&&i<=10 %�ڶ��׶Σ�ʱ��Σ�
        v=0.85; phiv=(1/18)*pi;  %�ٶȴ�С������
        scatter(x0,y0,'.r');
        drawnow;
        x0=x0+v*cos(phiv)*time;  %Բ���˶�����   
        y0=y0+v*sin(phiv)*time;  %Բ���˶�����   
        x=x0+r*cos(phi);y=y0+r*sin(phi); %Բ�ķ���
        xy=[];
        xy=[xy;x;y];
        xy=xy'; %ת�ú� �õ�Բ�ϸ�������� 
        plot(x,y,'.g');
        hold on
        mid=xy;
        obstacle=cat(1,obstacle,mid);  %��̬�ϰ�����뾲̬�ϰ������� catΪ����ƴ�Ӻ��� 1����ƴ 2����ƴ
        
        %%% ���ڿ�ʼ����·���滮
        if(norm(robot-endpoint))>step          % ������λ�ú��յ�λ�ò�����0.1ʱ
        else
            break
        end
        %���Ƚ����ϰ���ļ�ֱ��ͼ
        i=1;mag = zeros(n,1);his=zeros(n,1);
        % ����һ�γ���õ�������360�ȷ�Χ��Ұ�ڵ��ϰ���ֲ�ֵ 72�������ļ��ϰ����ܶ�
        while (i<=length(obstacle)) 
           d = norm(obstacle(i,:) - robot); % �ϰ���դ���������֮�����
            if (d<dmax)
                beta = caculatebeta(robot,obstacle(i,:));  % �ϰ���դ�������ķ���
                rangle=asin(rsafe/d);        % ����ĽǶ�
                k = round(beta/alpha);       % ��ʱ��������k����������
                if(k == 0)
                    k = 1;
                end
                % ���º�ļ�����ֱ��ͼ��hֵ
                if((5*k>rad2deg(beta)-rad2deg(rangle))&&(5*k<rad2deg(beta)+rad2deg(rangle)))  
                    h(k)=1;
                else
                    h(k)=0;
                end
                i=i+1;
                m = C^2*Iij(d);   % �ϰ���դ���������ֵ����VFH���㷽����ͬ
                mag(k)=max(mag(k),m.*h(k));   % magΪzeros(n,1)��mag�ĵ�k��Ԫ��Ϊm
                i=i+1;
            else
                i=i+1;
            end
        end
        %����Ӧ��VFH+�㷨�������˶��뾶���� �ų����������
        i4=1;
        if  norm(robot-ref)==0
            km=kt;
        else
            km=dc;
        end
        k1=0;
        k2=0;       
        alpha;
        while (i4<=length(obstacle))
            % ����ת��뾶����
            dirtr(1)=radius*sin(km*alpha); 
            dirtr(2)=radius*cos(km*alpha);         %��ת�����Ĳ���
            centerr(1)=robot(1)+dirtr(1); centerr(2)=robot(2)+dirtr(2); %��ת����������
            dirtl(1)=-radius*sin(km*alpha);  dirtl(2)=-radius*cos(km*alpha);        %��ת�����Ĳ���
            centerl(1)=robot(1)+dirtl(1); centerl(2)=robot(2)+dirtl(2); %��ת����������
            %dor=norm(obstacle(i,:) - centerr);                          %�ϰ��ﵽ��ת�����ĵľ���
            %dor=norm(obstacle(i,:) - centerl);                          %�ϰ��ﵽ��ת�����ĵľ���
            dirtor(1)=obstacle(i4)-robot(1); dirtor(2)=obstacle(2)-robot(2); %�ϰ��ﵽ�����˵������
            disor=(dirtr(1)-dirtor(1))^2+(dirtr(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
            disol=(dirtl(1)-dirtor(1))^2+(dirtl(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
            if 0<=km&&km<36
                k1=k1+1
                phib=km+36; %��ʼ���޽Ƕ�=�˶�����ķ�����
                phil=phib;  %��ʼ���޽Ƕ�
                phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                beta = caculatebeta(robot,obstacle(i4,:));
                k = round(beta/alpha); %�ϰ������ڵ�����
                if km<=k&&k<phil  %�ϰ�������������
                    if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                        phil=k;
                        i5=phil;
                        while (phil<=i5&&i5<=phib)
                            mag(i5)=max(mag);
                            i5=i5+1;
                        end
                    end
                else
                %if (0<=k<km|phir<=k<=n) %�ϰ������Ұ������
                    if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                        phir=k;
                        if phir<=k&&k<=n
                            i6=phib;
                            while (phib<=i6&&i6<=phir)
                                mag(i6)=max(mag);
                                i6=i6+1;
                            end
                        else
                        %if 0<=k<=km
                            i7=phib;
                            while (phib<=i7&&i7<=72)
                                mag(i7)=max(mag);
                                i7=i7+1;
                            end
                            i8=1;
                            while (0<=i8&&i8<=phir)
                                mag(i8)=max(mag);
                                i8=i8+1;
                            end
                        end
                    end
                end
            elseif 36<=km&&km<=72
               k2=k2+1
               phib=km-36; %��ʼ���޽Ƕ�=�˶�����ķ����� 
               phil=phib;  %��ʼ���޽Ƕ�
               phir=phib;  %��ʼ�Ҽ��޽Ƕ�
               beta = caculatebeta(robot,obstacle(i4,:));
               k = round(beta/alpha); %�ϰ������ڵ�����
               if k~=0
               else
                   k=1;
               end
               if phir<=k&&k<km  %�ϰ������Ұ������
                  if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                     phir=k;
                     i9=phib;
                     while (phib<=i9&&i9<=phir)
                           mag(i9)=max(mag);
                           i9=i9+1;
                     end
                  end
               else
               %if (km<=k<72|0<=k<=phil) %�ϰ�������������
                   if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                      phil=k;
                        if 0<=k&&k<=phib
                            i10=phil;

                            while (phil<=i10&&i10<=phib)
                                mag(i10)=max(mag);
                                i10=i10+1;
                            end
                        else
                        %if km<=k<=72
                            i11=1;
                            while (0<=i11&&i11<=phib)
                                mag(i11)=max(mag);
                                i11=i11+1;
                            end
                            i12=1;
                            while (phil<=i12&&i12<=72)
                                mag(i12)=max(mag);
                                i12=i12+1;
                            end
                        end
                   end
               end  
            end
            i4=i4+1;
        end
        his=mag;      %���� his ��һ����72��Ԫ�ص�����--���������ϰ����ܶ�
        %������������Ӧ��ֵ��һ�鱸ѡ����һ���������ɸ���ѡ����
        i1=1; %����Ӧ��ֵ��ѭ������
        kb=cell(1,blcs);
        howth=[];
        while (i1<=blcs)   % ����Ӧ��ֵ��whileѭ��������i1 i1ȡ9��ʱ�� ����ĳһ��ͣ�� i1ȡ15��ʱ�� ��ɱ��ϣ�˵������Ӧ��ֵ��Ч������
            %kb2=zeros(9,1);
            %howth2=zeros(9,1);
            Dt=norm(robot-endpoint);
            Dth(i1)=Dthmax-i1*dirtD;
            c=[];
            if  Dth(i1)<Dt
                threshold(i1)=C^2*Iij(Dth(i1));
                j=1;q=1;
                
                while (q<=n)       
                    %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                    if(his(q)< threshold(i1))
                        kr=q;                        % �ҵ��˲��ȵ����
                        while(q<=n && his(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                            kl=q;
                            q=q+1;
                        end

                        if(kl-kr > smax)                  % ����
                            c   =  [c round(kl - smax/2)];  % �������
                            c   =  [c round(kr + smax/2)];  % �����Ҳ�
                            %j=j+1;
                            if(kt >= kr && kt <= kl)
                                c  = [c kt];                % straight at look ahead
                                %j=j+1;
                            end
                         elseif(kl-kr > smax/5)           % խ����
                            c   =  [c round((kr+kl)/2-2.5)];
                            %j=j+1;
                         end

                    else
                        q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                    end                                   % �˳�ifѡ���ٴν���while����ѭ��
                end                                       % �˳�whileѭ��
                % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                numb=length(c);
                temp2=howmuchs(Dth(i1),Dthmax,numb,c,kt);
            end 
            kb{1,i1}=c;
            howth=[howth temp2];       %�洢��ֵ�ۺϴ���    
            i1=i1+1;
        end
        ftth=find(howth==min(howth));
        kbbest=kb{1,ftth(1)};   %��ʱ�����һ�������ֵ�µ����ɱ�ѡ����
        %���ڣ�Ҫ�ж��Ƿ����VFH*�㷨����·���滮
        %�ж����鱸ѡ�����ܷ�ֳ������飺��ȷ����ǰ�˶�����
        %���һ��
        %if  (0<=km&&km<=round((ds/radius)/alpha))||(72-round((ds/radius)/alpha)<=km&&km<=72) 
        if 0<=km&&km<=round((ds/radius)/alpha)  %������
           lml=km+round((ds/radius)/alpha); %��߽�
           lmr=km-round((ds/radius)/alpha)+72; %�ұ߽�
           numb1=length(kbbest); 
           phib=km+36; %��ǰ�˶�������
           tempkl=[];
           tempkr=[];
           for j1=1:numb1
               if km<=kbbest(j1)&&kbbest(j1)<=lml  %��߷���ɴ�
                  tempkl=[tempkl kbbest(j1)];
               %end
               elseif lml<=kbbest(j1)&&kbbest(j1)<=phib %��߷��򲻿ɴ�
                  tempkl=[tempkl lml];
               %end
               elseif phib<=kbbest(j1)&&kbbest(j1)<=lmr %�ұ߷��򲻿ɴ�
                  tempkr=[tempkr lmr];
               %end
               elseif lmr<=kbbest(j1)&&kbbest(j1)<=72  %�ұ߷���ɴ� ״̬һ
                  tempkr=[tempkr kbbest(j1)];
               %end
               %if 0<=kbbest(j1)<=km  %�ұ߷���ɴ� ״̬�� 
               else
                  tempkr=[tempkr kbbest(j1)]; 
               end
           end         
        %else
        elseif 72-round((ds/radius)/alpha)<=km&&km<=72  %�۽����
           lml=km+round((ds/radius)/alpha)-72;  %��߽�
           if lml~=0
           else
              lml=1; 
           end
           lmr=km-round((ds/radius)/alpha);  %�ұ߽�
           numb1=length(kbbest);
           phib=km-36;  %��ǰ�˶�������
           tempkl=[];
           tempkr=[];
           for j2=1:numb1
               if phib<=kbbest(j2)&&kbbest(j2)<=lmr  %�ұ߷��򲻿ɴ�
                  tempkr=[tempkr lmr]; 
               %end
               elseif lmr<=kbbest(j2)&&kbbest(j2)<=km  %�ұ߷���ɴ�
                  tempkr=[tempkr kbbest(j2)]; 
               %end
               elseif km<=kbbest(j2)&&kbbest(j2)<=72  %��߷���ɴ� ״̬һ
                  tempkl=[tempkl kbbest(j2)];
               %end
               elseif 0<=kbbest(j2)&&kbbest(j2)<=lml  %��߷���ɴ� ״̬��
                  tempkl=[tempkl kbbest(j2)]; 
               %end
               else
               %if lml<=kbbest(j2)<=phib  %��߷��򲻿ɴ�
                  tempkl=[tempkl lml]; 
               end
           end
        
        %end
        %�����
        elseif  round((ds/radius)/alpha)<=km&&km<=36 
            lml=km+round((ds/radius)/alpha); %��߽�
            lmr=km-round((ds/radius)/alpha); %�ұ߽�
            numb1=length(kbbest); 
            phib=km+36; %��ǰ�˶�������
            tempkl=[];
            tempkr=[];
            for j3=1:numb1
                if km<=kbbest(j3)&&kbbest(j3)<=lml  %��߷���ɴ�
                   tempkl=[tempkl kbbest(j3)]; 
                %end
                elseif lml<=kbbest(j3)&&kbbest(j3)<=phib  %��߷��򲻿ɴ�
                   tempkl=[tempkl lml]; 
                %end
                elseif km<=kbbest(j3)&&kbbest(j3)<=lmr  %�ұ߷���ɴ�
                   tempkr=[tempkr kbbest(j3)]; 
                %end
                else
                tempkr=[tempkr lmr];  %�ұ߷��򲻿ɴ�
                end
            end 
        %end
        else
        %�����
        %if  36<=km<=72-round((ds/radius)/alpha)
            lml=km+round((ds/radius)/alpha); %��߽�
            lmr=km-round((ds/radius)/alpha); %�ұ߽�
            numb1=length(kbbest); 
            phib=km-36; %��ǰ�˶�������
            tempkl=[];
            tempkr=[];
            for j4=1:numb1
                if lmr<=kbbest(j4)&&kbbest(j4)<=km  %�ұ߷���ɴ�
                   tempkr=[tempkr kbbest(j4)]; 
                %end
                elseif phib<=kbbest(j4)&&kbbest(j4)<=lmr  %�ұ߷��򲻿ɴ�
                   tempkr=[tempkr lmr]; 
                %end
                elseif km<=kbbest(j4)&&kbbest(j4)<=lml  %��߷���ɴ�
                   tempkl=[tempkl kbbest(j4)]; 
                %end
                else
                tempkl=[tempkl lml];  %��߷��򲻿ɴ�
                end
            end
        end
        % �ж��Ƿ����VFH*�㷨 ���������ǲ��Ƕ�������һ������
        geshul=length(tempkl);
        geshur=length(tempkr);
        if  geshul>=1&&geshur>=1  %��������-��ʼ����VFH*�㷨
            refp=cell(1,6);  %δ��ͶӰλ�õ�����
            gc=cell(1,6);  %δ��ͶӰλ�õĴ���
            hc=cell(1,6);  %δ��ͶӰλ�õ�����ֵ
            fc=cell(1,6);  %δ��ͶӰλ�õ��ۺ��ж�ֵ
            pp=cell(1,6);  %δ��ͶӰλ�õĽڵ�
            pfcun=zeros(1,4);  %����ÿ���ڵ����ѷ���
            ng=1;  % ��ʼVFH* ��һ������
            %��ȷ����һ���ڵ�����ҷ���
            if  norm(robot-ref)==0
                lc=kt;
            else
            %if  norm(robot-ref)~=0
                lc=lc;
            end 
            g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
            for i14=1:geshul
                g1l(i14)=tempkl(i14);
                order1l=g1l(i14);
                ol1l=g1l(i14)-1;
                or1l=g1l(i14)+1;
                if ol1l~=0
                   if or1l~=73
                   how1l(i14,1)=howmany(g1l(i14),kt,km,lc,his(order1l),his(ol1l),his(or1l));
                   else
                   how1l(i14,1)=howmany(g1l(i14),kt,km,lc,his(order1l),his(ol1l),inf);    
                   end
                else
                   how1l(i14,1)=howmany(g1l(i14),kt,km,lc,his(order1l),inf,his(or1l)); 
                end
            end
            ft1l=find(how1l==min(how1l));
            ft1l;
            
            pf1lbest=filt(g1l(ft1l),kt);  %�ҵ������ѷ���
            g1r=zeros(geshur,1);how1r=zeros(geshur,1);  %�ұ�ǰ������
            for i15=1:geshur
                g1r(i15)=tempkr(i15);
                order1r=g1r(i15);
                ol1r=g1r(i15)-1;
                or1r=g1r(i15)+1;
                if ol1r~=0
                   if or1r~=73 
                   how1r(i15)=howmany(g1r(i15),kt,km,lc,his(order1r),his(ol1r),his(or1r));
                   else
                   how1r(i15)=howmany(g1r(i15),kt,km,lc,his(order1r),his(ol1r),inf);    
                   end
                else
                   how1r(i15)=howmany(g1r(i15),kt,km,lc,his(order1r),inf,his(or1r));
                end
            end
            ft1r=find(how1r==min(how1r));
            pf1rbest=filt(g1r(ft1r),kt);  %�ҵ��ұ���ѷ���
            %ǰ����ͶӰ��
            pp{1,1}=robot+[v_car*time*cos(pf1lbest*alpha),v_car*time*sin(pf1lbest*alpha)];
            pp{1,2}=robot+[v_car*time*cos(pf1rbest*alpha),v_car*time*sin(pf1rbest*alpha)];
            ol1l=pf1lbest-1;
            or1l=pf1lbest+1;
            order1l=pf1lbest;
            if ol1l~=0
               if or1l~=73 
               gc{1,1}=howmanys(pf1lbest,kt,km,lc,his(order1l),his(ol1l),his(or1l),ng);
               else
               gc{1,1}=howmanys(pf1lbest,kt,km,lc,his(order1l),his(ol1l),inf,ng);    
               end
            else
               gc{1,1}=howmanys(pf1lbest,kt,km,lc,his(order1l),inf,his(or1l),ng); 
            end
            ol1r=pf1rbest-1;
            or1r=pf1rbest+1;
            order1r=pf1rbest;
            if ol1r~=0
               if or1r~=73  
               gc{1,2}=howmanys(pf1rbest,kt,km,lc,his(order1r),his(ol1r),his(or1r),ng);
               else
               gc{1,2}=howmanys(pf1rbest,kt,km,lc,his(order1r),his(ol1r),inf,ng);    
               end
            else
               gc{1,2}=howmanys(pf1rbest,kt,km,lc,his(order1r),inf,his(or1r),ng); 
            end
            kt1l=round(caculatebeta(pp{1,1},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
            kt1r=round(caculatebeta(pp{1,2},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
            hc{1,1}=heu(kt1l,pf1lbest,pf1lbest,ng);
            hc{1,2}=heu(kt1r,pf1rbest,pf1rbest,ng);
            fc{1,1}=gc{1,1}+hc{1,1};
            fc{1,2}=gc{1,2}+hc{1,2};
            % ��ʼ VFH* �ڶ�������
            ng=ng+1;
            % ������һ��ͶӰ��ļ�ֱ��ͼ
            i2=1;mag1l = zeros(n,1);his1l=zeros(n,1);
            while (i2<=length(obstacle))  
            
            %%%%%%%%%%% ����һ�γ���õ�ͶӰ��һ��360�ȷ�Χ��Ұ�ڵ��ϰ���ֲ�ֵ 72�������ļ��ϰ����ܶ�  
            
                d1l = norm(obstacle(i2,:) - pp{1,1}); % �ϰ���դ���������֮�����
                if (d1l<dmax)
                    beta1l = caculatebeta(pp{1,1},obstacle(i2,:));  % �ϰ���դ�������ķ���
                    rangle1l=asin(rsafe/d1l);        % ����ĽǶ�
                    k1l = round(beta1l/alpha);       % ��ʱ��������k����������
                    if(k1l == 0)
                        k1l = 1;
                    end
                    % ���º�ļ�����ֱ��ͼ��hֵ
                    if((5*k1l>rad2deg(beta1l)-rad2deg(rangle1l))&&(5*k1l<rad2deg(beta1l)+rad2deg(rangle1l)))  
                        h1l(k1l)=1;
                    else
                        h1l(k1l)=0;
                    end
                    i2=i2+1;

                    m1l = C^2*Iij(d1l);   % �ϰ���դ���������ֵ����VFH���㷽����ͬ
                    mag1l(k1l)=max(mag1l(k1l),m1l.*h1l(k1l));   % magΪzeros(n,1)��mag�ĵ�k��Ԫ��Ϊm
                    i2=i2+1;
                else
                    i2=i2+1;
                end
            end
            % ��һ��ͶӰ�㣺��VFH+�ų�һЩ����
            i41l=1; %Ӧ��VFH+�㷨�������˶��뾶���� �ų����������
            if  norm(pp{1,1}-ref)==0
                km=kt;
            else
            %if  norm(pp{1,1}-ref)~=0
                km=pf1lbest;
            end
            while (i41l<=length(obstacle))

                %%%%%%%%%% ����ת��뾶����
                    km
                    dirtr(1)=radius*sin(km*alpha);   dirtr(2)=radius*cos(km*alpha);         %��ת�����Ĳ���
                    centerr(1)=pp{1,1}(1)+dirtr(1); centerr(2)=pp{1,1}(2)+dirtr(2); %��ת����������
                    dirtl(1)=-radius*sin(km*alpha);  dirtl(2)=-radius*cos(km*alpha);        %��ת�����Ĳ���
                    centerl(1)=pp{1,1}(1)+dirtl(1); centerl(2)=pp{1,1}(2)+dirtl(2); %��ת����������
                    %dor=norm(obstacle(i,:) - centerr);                          %�ϰ��ﵽ��ת�����ĵľ���
                    %dor=norm(obstacle(i,:) - centerl);                          %�ϰ��ﵽ��ת�����ĵľ���
                    dirtor(1)=obstacle(i41l)-pp{1,1}(1); dirtor(2)=obstacle(2)-pp{1,1}(2); %�ϰ��ﵽ�����˵������
                    disor=(dirtr(1)-dirtor(1))^2+(dirtr(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    disol=(dirtl(1)-dirtor(1))^2+(dirtl(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    if 0<=km&&km<36
                        phib=km+36; %��ʼ���޽Ƕ�=�˶�����ķ�����
                        phil=phib;  %��ʼ���޽Ƕ�
                        phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                        beta = caculatebeta(pp{1,1},obstacle(i41l,:));
                        k = round(beta/alpha); %�ϰ������ڵ�����
                        if km<=k&&km<phil  %�ϰ�������������
                            if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phil=k;
                                i5=phil;
                                while (phil<=i5&&i5<=phib)
                                    mag1l(i5)=max(mag1l);
                                    i5=i5+1;
                                end
                            end
                        else
                        %if (0<=k<km|phir<=k<=n) %�ϰ������Ұ������
                            if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phir=k;
                                if phir<=k&&k<=n
                                    i6=phib;
                                    while (phib<=i6&&i6<=phir)
                                        mag1l(i6)=max(mag1l);
                                        i6=i6+1;
                                    end
                                else
                                %if 0<=k<=km
                                    i7=phib;
                                    while (phib<=i7&&i7<=72)
                                        mag1l(i7)=max(mag1l);
                                        i7=i7+1;
                                    end
                                    i8=1;
                                    while (0<=i8&&i8<=phir)
                                        mag1l(i8)=max(mag1l);
                                        i8=i8+1;
                                    end
                                end
                            end
                        end
                    else
                    %if 36<=km<=72
                       phib=km-36; %��ʼ���޽Ƕ�=�˶�����ķ����� 
                       phil=phib;  %��ʼ���޽Ƕ�
                       phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                       beta = caculatebeta(pp{1,1},obstacle(i41l,:));
                       k = round(beta/alpha); %�ϰ������ڵ�����
                       if k~=0
                       else
                           k=1;
                       end
                       if phir<=k&&k<km  %�ϰ������Ұ������
                          if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                             phir=k;
                             i9=phib;
                             while (phib<=i9&&i9<=phir)
                                   mag1l(i9)=max(mag1l);
                                   i9=i9+1;
                             end
                          end
                       else
                       %if (km<=k<72|0<=k<=phil) %�ϰ�������������
                           if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                              phil=k;
                                if 0<=k&&k<=phib
                                    i10=phil;
                                    while (phil<=i10&&i10<=phib)
                                        mag1l(i10)=max(mag1l);
                                        i10=i10+1;
                                    end
                                else
                                %if km<=k<=72
                                    i11=1;
                                    while (0<=i11&&i11<=phib)
                                        mag1l(i11)=max(mag1l);
                                        i11=i11+1;
                                    end
                                    i12=1;
                                    while (phil<=i12&&i12<=72)
                                        mag1l(i12)=max(mag1l);
                                        i12=i12+1;
                                    end
                                end
                           end
                       end  
                    end
                    i41l=i41l+1;
            end
        
            his1l=mag1l;      %���� his ��һ����72��Ԫ�ص�����--���������ϰ����ܶ�
            % ��һ��ͶӰ�㣺ѡȡһ����ѱ�ѡ����
            i1=1; %����Ӧ��ֵ��ѭ������
            kb=cell(1,blcs);
            howth=[];
            while (i1<=blcs)   % ����Ӧ��ֵ��whileѭ��������i1 i1ȡ9��ʱ�� ����ĳһ��ͣ�� i1ȡ15��ʱ�� ��ɱ��ϣ�˵������Ӧ��ֵ��Ч������
                %kb2=zeros(9,1);
                %howth2=zeros(9,1);
                Dt=norm(pp{1,1}-endpoint);
                Dth(i1)=Dthmax-i1*dirtD;
                c=[];
                if  Dth(i1)<Dt
                    threshold(i1)=C^2*Iij(Dth(i1));
                    j=1;q=1;
                    
                    while (q<=n)       
                        %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                        if(his1l(q)< threshold(i1))
                            kr=q;                        % �ҵ��˲��ȵ����
                            while(q<=n && his1l(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                                kl=q;
                                q=q+1;
                            end

                            if(kl-kr > smax)                  % ����
                                c   = [c round(kl - smax/2)];  % �������
                                c   = [c round(kr + smax/2)];  % �����Ҳ�
                                %j=j+2;
                                if(kt1l >= kr && kt1l <= kl)
                                    c  = [c kt1l];                % straight at look ahead
                                    %j=j+1;
                                end
                             elseif(kl-kr > smax/5)           % խ����
                                c  = [c round((kr+kl)/2-2.5)];
                                %j=j+1;
                             end

                        else
                            q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                        end                                   % �˳�ifѡ���ٴν���while����ѭ��
                    end                                       % �˳�whileѭ��

                    % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                    numb=length(c);
                    temp2=howmuchs(Dth(i1),Dthmax,numb,c,kt1l);
                end 

                %temp1=howmuch(Dth(i1),fk,kt,Dthmax);   
                kb{1,i1}=c;
                howth=[howth temp2];       %�洢��ֵ�ۺϴ���    
                i1=i1+1;
            end
            ftth=find(howth==min(howth));
            kbbest1l=kb{1,ftth(1)};   %��ʱ�����һ�������ֵ�µ����ɱ�ѡ����
            %��һ��ͶӰ�㣺�ܷ������
            
            %���һ��
            %if  0<=km<=round((ds/radius)/alpha)||72-round((ds/radius)/alpha)<=km<=72 
            if 0<=km&&km<=round((ds/radius)/alpha)  %������
               lml=km+round((ds/radius)/alpha); %��߽�
               lmr=km-round((ds/radius)/alpha)+72; %�ұ߽�
               numb1=length(kbbest1l); 
               phib=km+36; %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j1=1:numb1
                   if km<=kbbest1l(j1)&&kbbest1l(j1)<=lml  %��߷���ɴ�
                      tempkl=[tempkl kbbest1l(j1)];
                   %end
                   elseif lml<=kbbest1l(j1)&&kbbest1l(j1)<=phib %��߷��򲻿ɴ�
                      tempkl=[tempkl lml];
                   %end
                   elseif phib<=kbbest1l(j1)&&kbbest1l(j1)<=lmr %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr];
                   %end
                   elseif lmr<=kbbest1l(j1)&&kbbest1l(j1)<=72  %�ұ߷���ɴ� ״̬һ
                      tempkr=[tempkr kbbest1l(j1)];
                   %end
                   else
                   %if 0<=kbbest1l(j1)<=km  %�ұ߷���ɴ� ״̬��   
                      tempkr=[tempkr kbbest1l(j1)]; 
                   end
               end         
            
            elseif 72-round((ds/radius)/alpha)<=km&&km<=72  %�۽����
               lml=km+round((ds/radius)/alpha)-72;  %��߽�
               if lml~=0
               else
                  lml=1; 
               end
               lmr=km-round((ds/radius)/alpha);  %�ұ߽�
               numb1=length(kbbest1l);
               phib=km-36;  %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j2=1:numb1
                   if phib<=kbbest1l(j2)&&kbbest1l(j2)<=lmr  %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr]; 
                   %end
                   elseif lmr<=kbbest1l(j2)&&kbbest1l(j2)<=km  %�ұ߷���ɴ�
                      tempkr=[tempkr kbbest1l(j2)]; 
                   %end
                   elseif km<=kbbest1l(j2)&&kbbest1l(j2)<=72  %��߷���ɴ� ״̬һ
                      tempkl=[tempkl kbbest1l(j2)];
                   %end
                   elseif 0<=kbbest1l(j2)&&kbbest1l(j2)<=lml  %��߷���ɴ� ״̬��
                      tempkl=[tempkl kbbest1l(j2)]; 
                   %end
                   else
                   %if lml<=kbbest1l(j2)<=phib  %��߷��򲻿ɴ�
                      tempkl=[tempkl lml]; 
                   end
               end
            
            %end
            %�����
            elseif  round((ds/radius)/alpha)<=km&&km<=36 
                lml=km+round((ds/radius)/alpha); %��߽�
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1l); 
                phib=km+36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j3=1:numb1
                    if km<=kbbest1l(j3)&&kbbest1l(j3)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1l(j3)]; 
                    %end
                    elseif lml<=kbbest1l(j3)&&kbbest1l(j3)<=phib  %��߷��򲻿ɴ�
                       tempkl=[tempkl lml]; 
                    %end
                    elseif km<=kbbest1l(j3)&&kbbest1l(j3)<=lmr  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1l(j3)]; 
                    else
                    tempkr=[tempkr lmr];  %�ұ߷��򲻿ɴ�
                    end
                end 
            %end
            else
            %�����
            %if  36<=km<=72-round((ds/radius)/alpha)
                lml=km+round((ds/radius)/alpha); %��߽�
                if lml~=0
                else
                   lml=1; 
                end
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1l); 
                phib=km-36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j4=1:numb1
                    if lmr<=kbbest1l(j4)&&kbbest1l(j4)<=km  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1l(j4)]; 
                    %end
                    elseif phib<=kbbest1l(j4)&&kbbest1l(j4)<=lmr  %�ұ߷��򲻿ɴ�
                       tempkr=[tempkr lmr]; 
                    %end
                    elseif km<=kbbest1l(j4)&&kbbest1l(j4)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1l(j4)]; 
                    else
                    tempkl=[tempkl lml];  %��߷��򲻿ɴ� 
                    end
                end
            end
            
            geshul=length(tempkl);
            geshur=length(tempkr);
            %��һ��ͶӰ�㣺�ܷ�����
            if  geshul>=1&&geshur>=1  
                lc=pf1lbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                       if or1l~=73 
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l));
                       else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),inf);   
                       end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),inf,his1l(or1l));
                    end
                end
                ft1ll=find(how1l==min(how1l));
                pf1llbest=filt(g1l(ft1ll),kt1l);  %�ҵ������ѷ��� 
                g1r=zeros(geshur,1);how1r=zeros(geshur,1);  %�ұ�ǰ������
                for i15=1:geshur
                    g1r(i15)=tempkr(i15);
                    order1r=g1r(i15);
                    ol1r=g1r(i15)-1;
                    or1r=g1r(i15)+1;
                    if ol1r~=0
                       if or1r~=73
                       how1r(i15)=howmany(g1r(i15),kt1l,km,lc,his1l(order1r),his1l(ol1r),his1l(or1r));
                       else
                       how1r(i15)=howmany(g1r(i15),kt1l,km,lc,his1l(order1r),his1l(ol1r),inf);    
                       end
                    else
                       how1r(i15)=howmany(g1r(i15),kt1l,km,lc,his1l(order1r),inf,his1l(or1r));
                    end
                end
                ft1lr=find(how1r==min(how1r));
                pf1lrbest=filt(g1r(ft1lr),kt1l);  %�ҵ��ұ���ѷ���
                %ǰ����ͶӰ��
                pp{1,3}=pp{1,1}+[v_car*time*cos(pf1llbest*alpha),v_car*time*sin(pf1llbest*alpha)];
                pp{1,4}=pp{1,1}+[v_car*time*cos(pf1lrbest*alpha),v_car*time*sin(pf1lrbest*alpha)];
                ol1l=pf1llbest-1;
                or1l=pf1llbest+1;
                order1l=pf1llbest;
                if ol1l~=0
                   if or1l~=73 
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l),ng)+gc{1,1};
                   else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),inf,ng)+gc{1,1};    
                   end
                else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),inf,his1l(or1l),ng)+gc{1,1}; 
                end
                ol1r=pf1lrbest-1;
                or1r=pf1lrbest+1;
                order1r=pf1lrbest;
                if ol1r~=0
                   if or1r~=73 
                   gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1r),his1l(ol1r),his1l(or1r),ng)+gc{1,1};
                   else
                   gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1r),his1l(ol1r),inf,ng)+gc{1,1};    
                   end
                else
                   gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1r),inf,his1l(or1r),ng)+gc{1,1}; 
                end
                kt1ll=round(caculatebeta(pp{1,3},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                kt1lr=round(caculatebeta(pp{1,4},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,3}=heu(kt1ll,pf1llbest,pf1llbest,ng);
                hc{1,4}=heu(kt1lr,pf1lrbest,pf1lrbest,ng);
                fc{1,3}=gc{1,3}+hc{1,3};
                fc{1,4}=gc{1,4}+hc{1,4};
                pfcun(1,1)=pf1llbest;
                pfcun(1,2)=pf1lrbest;
            %end
            %��һ��ͶӰ�㣺���ܷ����� ֻ��һ������
            elseif  geshul>=1&&geshur==0  %�÷�������
                lc=pf1lbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                       if or1l~=73 
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l));
                       else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),inf);    
                       end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),inf,his1l(or1l)); 
                    end
                end
                ft1ll=find(how1l==min(how1l));
                pf1llbest=filt(g1l(ft1ll),kt1l);  %�ҵ������ѷ��� 
                pp{1,3}=pp{1,1}+[v_car*time*cos(pf1llbest*alpha),v_car*time*sin(pf1llbest*alpha)];
                ol1l=pf1llbest-1;
                or1l=pf1llbest+1;
                order1l=pf1llbest;
                if ol1l~=0
                   if or1l~=73 
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l),ng)+gc{1,1};
                   else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),inf,ng)+gc{1,1};   
                   end
                else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),inf,his1l(or1l),ng)+gc{1,1}; 
                end
                kt1ll=round(caculatebeta(pp{1,3},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,3}=heu(kt1ll,pf1llbest,pf1llbest,ng);
                fc{1,3}=gc{1,3}+hc{1,3};
                fc{1,4}=inf;
                pfcun(1,1)=pf1llbest;
            %end
            elseif  geshur>=1&&geshul==0  %�÷�������
                lc=pf1lbest;
                g1l=zeros(geshur,1);how1l=zeros(geshur,1);  %�ұ�ǰ������ 
                for i14=1:geshur
                    g1l(i14)=tempkr(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                        if or1l~=73
                        how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l));
                        else
                        how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),inf);    
                        end
                    else
                        how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),inf,his1l(or1l)); 
                    end
                end
                ft1lr=find(how1l==min(how1l));
                pf1lrbest=filt(g1l(ft1lr),kt1l);  %�ҵ��ұ���ѷ��� 
                pp{1,4}=pp{1,1}+[v_car*time*cos(pf1lrbest*alpha),v_car*time*sin(pf1lrbest*alpha)];
                ol1l=pf1lrbest-1;
                or1l=pf1lrbest+1;
                order1l=pf1lrbest;
                if ol1l~=0
                    if or1l~=73
                    gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l),ng)+gc{1,1};
                    else
                    gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),inf,ng)+gc{1,1};    
                    end
                else
                    gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1l),inf,his1l(or1l),ng)+gc{1,1};
                end
                kt1lr=round(caculatebeta(pp{1,4},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,4}=heu(kt1lr,pf1lrbest,pf1lrbest,ng);
                fc{1,4}=gc{1,4}+hc{1,4};
                fc{1,3}=inf;
                pfcun(1,2)=pf1lrbest;
            %end
            %��һ��ͶӰ�㣺���ܷ����� �޷���
            else
            %if  geshul==geshur==0
                fc{1,3}=inf;
                fc{1,4}=inf;
            end
            % �����ڶ���ͶӰ��ļ�ֱ��ͼ
            i3=1;mag1r = zeros(n,1);his1r=zeros(n,1);
            while (i3<=length(obstacle))  
            
            %%%%%%%%%%% ����һ�γ���õ�������360�ȷ�Χ��Ұ�ڵ��ϰ���ֲ�ֵ 72�������ļ��ϰ����ܶ�  
            
                d1r = norm(obstacle(i3,:) - pp{1,2}); % �ϰ���դ���������֮�����
                if (d1r<dmax)
                    beta1r = caculatebeta(pp{1,2},obstacle(i3,:));  % �ϰ���դ�������ķ���
                    rangle1r=asin(rsafe/d1r);        % ����ĽǶ�
                    k1r = round(beta1r/alpha);       % ��ʱ��������k����������
                    if(k1r == 0)
                        k1r = 1;
                    end
                    % ���º�ļ�����ֱ��ͼ��hֵ
                    if((5*k1r>rad2deg(beta1r)-rad2deg(rangle1r))&&(5*k1r<rad2deg(beta1r)+rad2deg(rangle1r)))  
                        h1r(k1r)=1;
                    else
                        h1r(k1r)=0;
                    end
                    i3=i3+1;

                    m1r = C^2*Iij(d1r);   % �ϰ���դ���������ֵ����VFH���㷽����ͬ
                    mag1r(k1r)=max(mag1r(k1r),m1r.*h1r(k1r));   % magΪzeros(n,1)��mag�ĵ�k��Ԫ��Ϊm
                    i3=i3+1;
                else
                    i3=i3+1;
                end 
            end
            %�ڶ���ͶӰ�㣺��VFH+�ų�һЩ����
            i41r=1; %Ӧ��VFH+�㷨�������˶��뾶���� �ų����������
            km=pf1rbest;
            while (i41r<=length(obstacle))

                %%%%%%%%%% ����ת��뾶����
                    
                    dirtr(1)=radius*sin(km*alpha);   dirtr(2)=radius*cos(km*alpha);         %��ת�����Ĳ���
                    centerr(1)=pp{1,2}(1)+dirtr(1); centerr(2)=pp{1,2}(2)+dirtr(2); %��ת����������
                    dirtl(1)=-radius*sin(km*alpha);  dirtl(2)=-radius*cos(km*alpha);        %��ת�����Ĳ���
                    centerl(1)=pp{1,2}(1)+dirtl(1); centerl(2)=pp{1,2}(2)+dirtl(2); %��ת����������
                    %dor=norm(obstacle(i,:) - centerr);                          %�ϰ��ﵽ��ת�����ĵľ���
                    %dor=norm(obstacle(i,:) - centerl);                          %�ϰ��ﵽ��ת�����ĵľ���
                    dirtor(1)=obstacle(i41r)-pp{1,2}(1); dirtor(2)=obstacle(2)-pp{1,2}(2); %�ϰ��ﵽ�����˵������
                    disor=(dirtr(1)-dirtor(1))^2+(dirtr(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    disol=(dirtl(1)-dirtor(1))^2+(dirtl(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    if 0<=km&&km<36
                        phib=km+36; %��ʼ���޽Ƕ�=�˶�����ķ�����
                        phil=phib;  %��ʼ���޽Ƕ�
                        phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                        beta = caculatebeta(pp{1,2},obstacle(i41r,:));
                        k = round(beta/alpha); %�ϰ������ڵ�����
                        if km<=k&&k<phil  %�ϰ�������������
                            if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phil=k;
                                i5=phil;
                                while (phil<=i5&&i5<=phib)
                                    mag1r(i5)=max(mag1r);
                                    i5=i5+1;
                                end
                            end
                        else
                        %if (0<=k<km|phir<=k<=n) %�ϰ������Ұ������
                            if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phir=k;
                                if phir<=k&&k<=n
                                    i6=phib;
                                    while (phib<=i6&&i6<=phir)
                                        mag1r(i6)=max(mag1r);
                                        i6=i6+1;
                                    end
                                else
                                %if 0<=k<=km
                                    i7=phib;
                                    while (phib<=i7&&i7<=72)
                                        mag1r(i7)=max(mag1r);
                                        i7=i7+1;
                                    end
                                    i8=1;
                                    while (0<=i8&&i8<=phir)
                                        mag1r(i8)=max(mag1r);
                                        i8=i8+1;
                                    end
                                end
                            end
                        end
                    else
                    %if 36<=km<=72
                       phib=km-36; %��ʼ���޽Ƕ�=�˶�����ķ����� 
                       phil=phib;  %��ʼ���޽Ƕ�
                       phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                       beta = caculatebeta(pp{1,2},obstacle(i41r,:));
                       k = round(beta/alpha); %�ϰ������ڵ�����
                       if k~=0
                       else
                          k=1;
                       end
                       if phir<=k&&k<km  %�ϰ������Ұ������
                          if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                             phir=k;
                             i9=phib;
                             while (phib<=i9&&i9<=phir)
                                   mag1r(i9)=max(mag1r);
                                   i9=i9+1;
                             end
                          end
                       else
                       %if (km<=k<72|0<=k<=phil) %�ϰ�������������
                           if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                              phil=k;
                                if 0<=k&&k<=phib
                                    i10=phil;
                                    while (phil<=i10&&i10<=phib)
                                        i10
                                        mag1r(i10)=max(mag1r);
                                        i10=i10+1;
                                    end
                                else
                                %if km<=k<=72
                                    i11=1;
                                    while (0<=i11&&i11<=phib)
                                        mag1r(i11)=max(mag1r);
                                        i11=i11+1;
                                    end
                                    i12=1;
                                    while (phil<=i12&&i12<=72)
                                        mag1r(i12)=max(mag1r);
                                        i12=i12+1;
                                    end
                                end
                           end
                       end  
                    end
                    i41r=i41r+1;
            end
        
            his1r=mag1r;      %���� his ��һ����72��Ԫ�ص�����--���������ϰ����ܶ�
            %�ڶ���ͶӰ�㣺ѡȡһ����ѱ�ѡ����
            i1=1; %����Ӧ��ֵ��ѭ������
            kb=cell(1,blcs);
            howth=[];
            while (i1<=blcs)   % ����Ӧ��ֵ��whileѭ��������i1 i1ȡ9��ʱ�� ����ĳһ��ͣ�� i1ȡ15��ʱ�� ��ɱ��ϣ�˵������Ӧ��ֵ��Ч������
                %kb2=zeros(9,1);
                %howth2=zeros(9,1);
                Dt=norm(pp{1,2}-endpoint);
                Dth(i1)=Dthmax-i1*dirtD;
                c=[];
                if  Dth(i1)<Dt
                    threshold(i1)=C^2*Iij(Dth(i1));
                    j=1;q=1;
                    
                    while (q<=n)       
                        %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                        if(his1r(q)< threshold(i1))
                            kr=q;                        % �ҵ��˲��ȵ����
                            while(q<=n && his1r(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                                kl=q;
                                q=q+1;
                            end

                            if(kl-kr > smax)                  % ����
                                c   = [c round(kl - smax/2)];  % �������
                                c   = [c round(kr + smax/2)];  % �����Ҳ�
                                %j=j+2;
                                if(kt1r >= kr && kt1r <= kl)
                                    c  = [c kt1r];                % straight at look ahead
                                    %j=j+1;
                                end
                             elseif(kl-kr > smax/5)           % խ����
                                c  = [c round((kr+kl)/2-2.5)];
                                %j=j+1;
                             end

                        else
                            q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                        end                                   % �˳�ifѡ���ٴν���while����ѭ��
                    end                                       % �˳�whileѭ��

                    % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                    numb=length(c);
                    temp2=howmuchs(Dth(i1),Dthmax,numb,c,kt1r);
                end 

                %temp1=howmuch(Dth(i1),fk,kt,Dthmax);   
                kb{1,i1}=c;
                howth=[howth temp2];       %�洢��ֵ�ۺϴ���    
                i1=i1+1;
            end
            ftth=find(howth==min(howth));
            kbbest1r=kb{1,ftth(1)};   %��ʱ�����һ�������ֵ�µ����ɱ�ѡ����
            %�ڶ���ͶӰ�㣺�ܷ������
            %���һ��
            %if  0<=km<=round((ds/radius)/alpha)||72-round((ds/radius)/alpha)<=km<=72 
            if 0<=km&&km<=round((ds/radius)/alpha)  %������
               lml=km+round((ds/radius)/alpha); %��߽�
               lmr=km-round((ds/radius)/alpha)+72; %�ұ߽�
               numb1=length(kbbest1r); 
               phib=km+36; %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j1=1:numb1
                   if km<=kbbest1r(j1)&&kbbest1r(j1)<=lml  %��߷���ɴ�
                      tempkl=[tempkl kbbest1r(j1)];
                   %end
                   elseif lml<=kbbest1r(j1)&&kbbest1r(j1)<=phib %��߷��򲻿ɴ�
                      tempkl=[tempkl lml];
                   %end
                   elseif phib<=kbbest1r(j1)&&kbbest1r(j1)<=lmr %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr];
                   %end
                   elseif lmr<=kbbest1r(j1)&&kbbest1r(j1)<=72  %�ұ߷���ɴ� ״̬һ
                      tempkr=[tempkr kbbest1r(j1)];
                   %end
                   else
                   %if 0<=kbbest1r(j1)<=km  %�ұ߷���ɴ� ״̬��   
                      tempkr=[tempkr kbbest1r(j1)]; 
                   end
               end         
            
            elseif 72-round((ds/radius)/alpha)<=km&&km<=72  %�۽����
               lml=km+round((ds/radius)/alpha)-72;  %��߽�
               if lml~=0
               else
                  lml=1; 
               end
               lmr=km-round((ds/radius)/alpha);  %�ұ߽�
               numb1=length(kbbest1r);
               phib=km-36;  %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j2=1:numb1
                   if phib<=kbbest1r(j2)&&kbbest1r(j2)<=lmr  %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr]; 
                   %end
                   elseif lmr<=kbbest1r(j2)&&kbbest1r(j2)<=km  %�ұ߷���ɴ�
                      tempkr=[tempkr kbbest1r(j2)]; 
                   %end
                   elseif km<=kbbest1r(j2)&&kbbest1r(j2)<=72  %��߷���ɴ� ״̬һ
                      tempkl=[tempkl kbbest1r(j2)];
                   %end
                   elseif 0<=kbbest1r(j2)&&kbbest1r(j2)<=lml  %��߷���ɴ� ״̬��
                      tempkl=[tempkl kbbest1r(j2)]; 
                   %end
                   else
                   %if lml<=kbbest1r(j2)<=phib  %��߷��򲻿ɴ�
                      tempkl=[tempkl lml]; 
                   end
               end
            %end
            %end
            %�����
            elseif  round((ds/radius)/alpha)<=km&&km<=36 
                lml=km+round((ds/radius)/alpha); %��߽�
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1r); 
                phib=km+36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j3=1:numb1
                    if km<=kbbest1r(j3)&&kbbest1r(j3)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1r(j3)]; 
                    %end
                    elseif lml<=kbbest1r(j3)&&kbbest1r(j3)<=phib  %��߷��򲻿ɴ�
                       tempkl=[tempkl lml]; 
                    %end
                    elseif km<=kbbest1r(j3)&&kbbest1r(j3)<=lmr  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1r(j3)]; 
                    else
                    tempkr=[tempkr lmr];  %�ұ߷��򲻿ɴ�
                    end
                end 
            %end
            %�����
            else
            %if  36<=km<=72-round((ds/radius)/alpha)
                lml=km+round((ds/radius)/alpha); %��߽�
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1r); 
                phib=km-36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j4=1:numb1
                    if lmr<=kbbest1r(j4)&&kbbest1r(j4)<=km  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1r(j4)]; 
                    %end
                    elseif phib<=kbbest1r(j4)&&kbbest1r(j4)<=lmr  %�ұ߷��򲻿ɴ�
                       tempkr=[tempkr lmr]; 
                    %end
                    elseif km<=kbbest1r(j4)&&kbbest1r(j4)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1r(j4)]; 
                    else
                    tempkl=[tempkl lml];  %��߷��򲻿ɴ�
                    end
                end
            end
            
            geshul=length(tempkl);
            geshur=length(tempkr);
            %�ڶ���ͶӰ�㣺�ܷ�����
            if  geshul>=1&&geshur>=1  
                lc=pf1rbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                        if or1l~=73
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l));
                        else
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),inf);    
                        end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),inf,his1r(or1l)); 
                    end
                end
                ft1rl=find(how1l==min(how1l));
                pf1rlbest=filt(g1l(ft1rl),kt1r);  %�ҵ������ѷ��� 
                g1r=zeros(geshur,1);how1r=zeros(geshur,1);  %�ұ�ǰ������
                for i15=1:geshur
                    g1r(i15)=tempkr(i15);
                    order1r=g1r(i15);
                    ol1r=g1r(i15)-1;
                    or1r=g1r(i15)+1;
                    if ol1r~=0
                       if or1r~=73 
                       how1r(i15)=howmany(g1r(i15),kt1r,km,lc,his1r(order1r),his1r(ol1r),his1r(or1r));
                       else
                       how1r(i15)=howmany(g1r(i15),kt1r,km,lc,his1r(order1r),his1r(ol1r),inf);    
                       end
                    else
                       how1r(i15)=howmany(g1r(i15),kt1r,km,lc,his1r(order1r),inf,his1r(or1r)); 
                    end
                end
                ft1rr=find(how1r==min(how1r));
                pf1rrbest=filt(g1r(ft1rr),kt1r);  %�ҵ��ұ���ѷ���
                pp{1,5}=pp{1,2}+[v_car*time*cos(pf1rlbest*alpha),v_car*time*sin(pf1rlbest*alpha)];
                pp{1,6}=pp{1,2}+[v_car*time*cos(pf1rrbest*alpha),v_car*time*sin(pf1rrbest*alpha)];
                ol1l=pf1rlbest-1;
                or1l=pf1rlbest+1;
                order1l=pf1rlbest;
                if ol1l~=0
                   if or1l~=73
                   gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l),ng)+gc{1,2};
                   else
                   gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),inf,ng)+gc{1,2};    
                   end
                else
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),inf,his1r(or1l),ng)+gc{1,2}; 
                end
                ol1r=pf1rrbest-1;
                or1r=pf1rrbest+1;
                order1r=pf1rrbest;
                if ol1r~=0
                   if or1r~=73
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1r),his1r(ol1r),his1r(or1r),ng)+gc{1,2};
                   else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1r),his1r(ol1r),inf,ng)+gc{1,2};    
                   end
                else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1r),inf,his1r(or1r),ng)+gc{1,2}; 
                end
                kt1rl=round(caculatebeta(pp{1,5},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                kt1rr=round(caculatebeta(pp{1,6},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,5}=heu(kt1rl,pf1rlbest,pf1rlbest,ng);
                hc{1,6}=heu(kt1rr,pf1rrbest,pf1rrbest,ng);
                fc{1,5}=gc{1,5}+hc{1,5};
                fc{1,6}=gc{1,6}+hc{1,6};
                pfcun(1,3)=pf1rlbest;
                pfcun(1,4)=pf1rrbest;
            %end
            %�ڶ���ͶӰ�㣺���ܷ����� ֻ��һ������
            elseif  geshul>=1&&geshur==0  %�÷�������
                lc=pf1rbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                tempkl
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                        if or1l~=73 
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l));
                        else
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),inf);    
                        end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),inf,his1r(or1l)); 
                    end
                end
                ft1rl=find(how1l==min(how1l));
                pf1rlbest=filt(g1l(ft1rl),kt1r);  %�ҵ������ѷ���
                pp{1,5}=pp{1,2}+[v_car*time*cos(pf1rlbest*alpha),v_car*time*sin(pf1rlbest*alpha)];
                ol1l=pf1rlbest-1;
                or1l=pf1rlbest+1;
                order1l=pf1rlbest;
                if ol1l~=0
                    if or1l~=73 
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l),ng)+gc{1,2};
                    else
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),inf,ng)+gc{1,2};
                    end
                else
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),inf,his1r(or1l),ng)+gc{1,2};
                end
                kt1rl=round(caculatebeta(pp{1,5},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,5}=heu(kt1rl,pf1rlbest,pf1rlbest,ng);
                fc{1,5}=gc{1,5}+hc{1,5};
                fc{1,6}=inf;
                pfcun(1,3)=pf1rlbest;
            %end
            elseif  geshur>=1&&geshul==0  %�÷�������
                lc=pf1rbest;
                g1l=zeros(geshur,1);how1l=zeros(geshur,1);  %�ұ�ǰ������ 
                for i14=1:geshur
                    g1l(i14)=tempkr(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                       if or1l~=73 
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l));
                       else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),inf);
                       end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),inf,his1r(or1l)); 
                    end
                end
                ft1rr=find(how1l==min(how1l));
                pf1rrbest=filt(g1l(ft1rr),kt1r);  %�ҵ��ұ���ѷ���
                pp{1,6}=pp{1,2}+[v_car*time*cos(pf1rrbest*alpha),v_car*time*sin(pf1rrbest*alpha)];
                ol1l=pf1rrbest-1;
                or1l=pf1rrbest+1;
                order1l=pf1rrbest;
                if ol1l~=0
                   if or1l~=73  
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l),ng)+gc{1,2};
                   else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),inf,ng)+gc{1,2};
                   end
                else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1l),inf,his1r(or1l),ng)+gc{1,2}; 
                end
                kt1rr=round(caculatebeta(pp{1,6},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,6}=heu(kt1rr,pf1rrbest,pf1rrbest,ng);
                fc{1,6}=gc{1,6}+hc{1,6};
                fc{1,5}=inf;
                pfcun(1,4)=pf1rrbest;
            else
            %�ڶ���ͶӰ�㣺���ܷ����� �޷���
            %if  geshul==geshur==0
                fc{1,5}=inf;
                fc{1,6}=inf;
            end
            pd=[fc{1,3},fc{1,4},fc{1,5},fc{1,6}]  %�ж�ֵ
            ft=find(pd==min(pd)) %�ҳ������ڵ�fcֵ��С��
            dcyb=pfcun(1,ft);
            %lc=dc;
            
            if  length(ft)==1
                lc=dcyb;
                dc=dcyb;
                robot=pp{1,ft+2};  %VFH*�㷨�õ�������λ�ò����������
            elseif  length(ft)==2 %ע�� ft �� dcyb ��ʱ��2��1�еľ���2��1��
                geshu=length(dcyb);
                if dcyb(1)==dcyb(geshu)
                   dc=dcyb(1); 
                   lc=dc;
                   robot=pp{1,ft(1)+2};
                else
                   kt_1=round(caculatebeta(pp{1,ft(1)+2},endpoint)/alpha);
                   kt_2=round(caculatebeta(pp{1,ft(2)+2},endpoint)/alpha);
                   g_=zeros(geshu,1);how_=zeros(geshu,1);xushu=zeros(geshu,1);
                   kt_=[kt_1 kt_2];
                   for i14=1:geshu
                       g_(i14)=dcyb(i14);
                       how_(i14)=howmanyss(g_(i14),kt_(i14));
                       xushu(i14)=ft(i14);
                   end
                   if how_(1)~=how_(2)
                       ft_=find(how_==min(how_));
                       dc=g_(ft_);
                       lc=dc;
                       robot=pp{1,xushu(ft_)};
                   else
                       g__=zeros(geshu,1);how__=zeros(geshu,1);xushu_=zeros(geshu,1);
                       for i14=1:geshu
                           g__(i14)=dcyb(i14);
                           how__(i14)=dif(g__(i14),kt_(i14));
                           xushu_(i14)=ft(i14);
                       end
                       ft__=find(how__==min(how__));
                       dc=g__(ft__);
                       lc=dc;
                       robot=pp{1,xushu(ft__)};
                   end
                 end
            end

            %��ǰ�˶�����
            %�ϴ�ѡ����
        else   %���������VFH*�㷨 �Ǿ�ʹ��VFH+�㷨�ж�
            if  norm(robot-ref)==0
                lc=kt;
            else
                lc=lc;
            end
            
            i1=1; %����Ӧ��ֵ��ѭ������
            kb=[];%������ѷ��򼯺�
            howth=[];%������ֵ�����ֵ�·���Ĵ��ۼ���
            
            % ����Ӧ��ֵ��ʼ��
            
            while (i1<=blcs)
                Dt=norm(robot-endpoint);
                Dth(i1)=Dthmax-i1*dirtD;
                c=[];
                if  Dth(i1)<Dt
                    threshold(i1)=C^2*Iij(Dth(i1));
                    j=1;q=1;

                    while (q<=n)       
                        %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                        if(his(q)< threshold(i1))
                            kr=q;                        % �ҵ��˲��ȵ����
                            while(q<=n && his(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                                kl=q;
                                q=q+1;
                            end

                            if(kl-kr > smax)                  % ����
                                c   =  [c round(kl - smax/2)];  % �������
                                c   =  [c round(kr + smax/2)];  % �����Ҳ�
                                j=j+2;
                                if(kt >= kr && kt <= kl)
                                    c  = [c kt];                % straight at look ahead
                                    j=j+1;
                                end
                            elseif(kl-kr > smax/5)           % խ����
                                c   =  [c round((kr+kl)/2-2.5)];
                                j=j+1;
                            end

                        else
                            q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                        end                                   % �˳�ifѡ���ٴν���while����ѭ��
                    end                                       % �˳�whileѭ��

                    % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                    % ��ʼɸѡ���ŷ���
                    if norm(robot-ref)==0                            
                       g=zeros(j-1,1);how=zeros(j-1,1);
                       for i2=1:j-1
                           g(i2)=c(i2);     %g�в���Ŀ������
                           order=g(i2);
                           ol=g(i2)-1;
                           or=g(i2)+1;
                           dc=kt;           %���ڻ����˻�û��������Ŀ�귽����ǵ�ǰ�˶�����
                           lc=kt;           %���ڻ����˻�û��������Ŀ�귽������ϴ�ѡ����
                           if ol~=0   %��ֹ���ֵ�0���73
                              if or~=73
                               how(i2)=howmany(g(i2),kt,dc,lc,his(order),his(ol),his(or)); %���ۺ����������ŷ��� howΪ���� Ԫ�ظ����� g ����ͬ��
                              else
                               how(i2)=howmany(g(i2),kt,dc,lc,his(order),his(ol),inf);   
                              end
                           else
                              how(i2)=howmany(g(i2),kt,dc,lc,his(order),inf,his(or)); 
                           end 
                       end                                                             
                       ft=find(how==min(how));
                       fk=g(ft);
                       kb=[kb fk];  % ��ǰ��ֵ�µ���ѱ�ѡ����
                    else
                       g=zeros(j-1,1);how=zeros(j-1,1);
                       for i3=1:j-1
                           g(i3)=c(i3);
                           order=g(i3);
                           ol=g(i3)-1;
                           or=g(i3)+1;
                           if ol~=0   %��ֹ���ֵ�0���73
                              if or~=73
                               how(i3)=howmany(g(i3),kt,dc,lc,his(order),his(ol),his(or));
                              else
                               how(i3)=howmany(g(i3),kt,dc,lc,his(order),his(ol),inf);   
                              end
                           else
                              how(i3)=howmany(g(i3),kt,dc,lc,his(order),inf,his(or)); 
                           end
                       end
                       ft=find(how==min(how));
                       fk=g(ft);
                       %һ����ֵ��Ҳ�����ֶ����ѷ��� ��ɸѡ��
                       cd=length(fk); %���ŷ���ĸ���
                       if cd==1
                          fk=fk;  % ��ǰ��ֵ�µ���ѱ�ѡ���� 
                       else 
                          g_=zeros(cd,1);how_=zeros(cd,1); 
                          for i4=1:cd
                              g_(i4)=fk(i4);
                              how_(i4)=dif(g_(i4),kt);
                          end
                          ft_=find(how_==min(how_));
                          fk=g_(ft_);  % ��ǰ��ֵ�µ���ѱ�ѡ����
                       end
                       kb=[kb fk];  % ��ǰ��ֵ�µ���ѱ�ѡ����
                    end
                    
                    temp1=howmuch(Dth(i1),fk,kt,Dthmax); %���� ��ֵ�����ֵ����ѷ�����ۺϴ���
                    howth=[howth temp1]; %�洢�ۺϴ���
                end
                i1=i1+1;
            end
            ft=find(howth==min(howth));
            fbestyb=kb(ft);  %VFH+�㷨�õ�����÷���
            % ��ֹ�ж�����ŷ���
            if  length(ft)==1
                dc=fbestyb;       % ��ǰ���˶�����
                lc=dc;       % ��һ��ѡ��ķ���
                robot=robot+[v_car*time*cos(fbestyb*alpha),v_car*time*sin(fbestyb*alpha)];  %VFH+�㷨�õ�������λ�ò����������
            elseif  length(ft)==2 %ע�� ft �� dcyb ��ʱ��2��1�еľ���2��1��
                geshu=length(fbestyb);
                if fbestyb(1,1)==fbestyb(geshu,1)
                   dc=fbestyb(1,1);  % ��ǰ���˶�����
                   lc=dc; % ��һ��ѡ��ķ���
                   robot=robot+[v_car*time*cos(lc*alpha),v_car*time*sin(lc*alpha)];
                else
                   
                   g_=zeros(geshu,1);how_=zeros(geshu,1);  
                   for i14=1:geshu
                        g_(i14)=fbestyb(i14);
                        how_(i14)=howmanyss(g_(i14),kt);
                   end
                   ft_=find(how_==min(how_));
                   dc=g_(ft_); % ��ǰ���˶�����
                   lc=dc; % ��һ��ѡ��ķ���
                   robot=robot+[v_car*time*cos(lc*alpha),v_car*time*sin(lc*alpha)];
                end    
            elseif  length(ft)==3
                geshu=length(fbestyb);
                g_=zeros(geshu,1);how_=zeros(geshu,1);  
                   for i14=1:geshu
                        g_(i14)=fbestyb(i14);
                        how_(i14)=howmanyss(g_(i14),kt);
                   end
                   ft_=find(how_==min(how_));
                   dc=g_(ft_); % ��ǰ���˶�����
                   lc=dc; % ��һ��ѡ��ķ���
                   robot=robot+[v_car*time*cos(lc*alpha),v_car*time*sin(lc*alpha)];
            %else 
            end
        end
        ref=startpoint;
        scatter(robot(1),robot(2),'.r');
        drawnow;
        kt=round(caculatebeta(robot,endpoint)/alpha);  %�µ�Ŀ�귽��
        if(kt==0)
            kt=n;
        end
        if(norm(robot-endpoint))>step          % ������λ�ú��յ�λ�ò�����0.1ʱ
        else
            break
        end
        %���˱��Ϲ滮һ�����
        
        obstacle([5271:8870],:)=[];    %������Ϻ��޳���̬�ϰ���
        obstacle;
    else %�����׶Σ�ʱ��Σ�
        v=0.85; phiv=(2/3)*pi;  %�ٶȴ�С������
        scatter(x0,y0,'.r');
        drawnow;
        x0=x0+v*cos(phiv)*time;  %Բ���˶�����   
        y0=y0+v*sin(phiv)*time;  %Բ���˶�����   
        x=x0+r*cos(phi);y=y0+r*sin(phi); %Բ�ķ���
        xy=[];
        xy=[xy;x;y];
        xy=xy'; %ת�ú� �õ�Բ�ϸ�������� 
        plot(x,y,'.g');
        hold on
        mid=xy;
        obstacle=cat(1,obstacle,mid);  %��̬�ϰ�����뾲̬�ϰ������� catΪ����ƴ�Ӻ��� 1����ƴ 2����ƴ
        
        %%% ���ڿ�ʼ����·���滮
        if(norm(robot-endpoint))>step          % ������λ�ú��յ�λ�ò�����0.1ʱ
        else
            break
        end
        %���Ƚ����ϰ���ļ�ֱ��ͼ
        i=1;mag = zeros(n,1);his=zeros(n,1);
        % ����һ�γ���õ�������360�ȷ�Χ��Ұ�ڵ��ϰ���ֲ�ֵ 72�������ļ��ϰ����ܶ�
        while (i<=length(obstacle)) 
           d = norm(obstacle(i,:) - robot); % �ϰ���դ���������֮�����
            if (d<dmax)
                beta = caculatebeta(robot,obstacle(i,:));  % �ϰ���դ�������ķ���
                rangle=asin(rsafe/d);        % ����ĽǶ�
                k = round(beta/alpha);       % ��ʱ��������k����������
                if(k == 0)
                    k = 1;
                end
                % ���º�ļ�����ֱ��ͼ��hֵ
                if((5*k>rad2deg(beta)-rad2deg(rangle))&&(5*k<rad2deg(beta)+rad2deg(rangle)))  
                    h(k)=1;
                else
                    h(k)=0;
                end
                i=i+1;
                m = C^2*Iij(d);   % �ϰ���դ���������ֵ����VFH���㷽����ͬ
                mag(k)=max(mag(k),m.*h(k));   % magΪzeros(n,1)��mag�ĵ�k��Ԫ��Ϊm
                i=i+1;
            else
                i=i+1;
            end
        end
        %����Ӧ��VFH+�㷨�������˶��뾶���� �ų����������
        i4=1;
        if  norm(robot-ref)==0
            km=kt;
        else
            km=dc;
        end
        k1=0;
        k2=0;       
        alpha;
        while (i4<=length(obstacle))
            % ����ת��뾶����
            dirtr(1)=radius*sin(km*alpha); 
            dirtr(2)=radius*cos(km*alpha);         %��ת�����Ĳ���
            centerr(1)=robot(1)+dirtr(1); centerr(2)=robot(2)+dirtr(2); %��ת����������
            dirtl(1)=-radius*sin(km*alpha);  dirtl(2)=-radius*cos(km*alpha);        %��ת�����Ĳ���
            centerl(1)=robot(1)+dirtl(1); centerl(2)=robot(2)+dirtl(2); %��ת����������
            %dor=norm(obstacle(i,:) - centerr);                          %�ϰ��ﵽ��ת�����ĵľ���
            %dor=norm(obstacle(i,:) - centerl);                          %�ϰ��ﵽ��ת�����ĵľ���
            dirtor(1)=obstacle(i4)-robot(1); dirtor(2)=obstacle(2)-robot(2); %�ϰ��ﵽ�����˵������
            disor=(dirtr(1)-dirtor(1))^2+(dirtr(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
            disol=(dirtl(1)-dirtor(1))^2+(dirtl(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
            if 0<=km&&km<36
                k1=k1+1
                phib=km+36; %��ʼ���޽Ƕ�=�˶�����ķ�����
                phil=phib;  %��ʼ���޽Ƕ�
                phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                beta = caculatebeta(robot,obstacle(i4,:));
                k = round(beta/alpha); %�ϰ������ڵ�����
                if km<=k&&k<phil  %�ϰ�������������
                    if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                        phil=k;
                        i5=phil;
                        while (phil<=i5&&i5<=phib)
                            mag(i5)=max(mag);
                            i5=i5+1;
                        end
                    end
                else
                %if (0<=k<km|phir<=k<=n) %�ϰ������Ұ������
                    if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                        phir=k;
                        if phir<=k&&k<=n
                            i6=phib;
                            while (phib<=i6&&i6<=phir)
                                mag(i6)=max(mag);
                                i6=i6+1;
                            end
                        else
                        %if 0<=k<=km
                            i7=phib;
                            while (phib<=i7&&i7<=72)
                                mag(i7)=max(mag);
                                i7=i7+1;
                            end
                            i8=1;
                            while (0<=i8&&i8<=phir)
                                mag(i8)=max(mag);
                                i8=i8+1;
                            end
                        end
                    end
                end
            elseif 36<=km&&km<=72
               k2=k2+1
               phib=km-36; %��ʼ���޽Ƕ�=�˶�����ķ����� 
               phil=phib;  %��ʼ���޽Ƕ�
               phir=phib;  %��ʼ�Ҽ��޽Ƕ�
               beta = caculatebeta(robot,obstacle(i4,:));
               k = round(beta/alpha); %�ϰ������ڵ�����
               if k~=0
               else
                   k=1;
               end
               if phir<=k&&k<km  %�ϰ������Ұ������
                  if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                     phir=k;
                     i9=phib;
                     while (phib<=i9&&i9<=phir)
                           mag(i9)=max(mag);
                           i9=i9+1;
                     end
                  end
               else
               %if (km<=k<72|0<=k<=phil) %�ϰ�������������
                   if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                      phil=k;
                        if 0<=k&&k<=phib
                            i10=phil;

                            while (phil<=i10&&i10<=phib)
                                mag(i10)=max(mag);
                                i10=i10+1;
                            end
                        else
                        %if km<=k<=72
                            i11=1;
                            while (0<=i11&&i11<=phib)
                                mag(i11)=max(mag);
                                i11=i11+1;
                            end
                            i12=1;
                            while (phil<=i12&&i12<=72)
                                mag(i12)=max(mag);
                                i12=i12+1;
                            end
                        end
                   end
               end  
            end
            i4=i4+1;
        end
        his=mag;      %���� his ��һ����72��Ԫ�ص�����--���������ϰ����ܶ�
        %������������Ӧ��ֵ��һ�鱸ѡ����һ���������ɸ���ѡ����
        i1=1; %����Ӧ��ֵ��ѭ������
        kb=cell(1,blcs);
        howth=[];
        while (i1<=blcs)   % ����Ӧ��ֵ��whileѭ��������i1 i1ȡ9��ʱ�� ����ĳһ��ͣ�� i1ȡ15��ʱ�� ��ɱ��ϣ�˵������Ӧ��ֵ��Ч������
            %kb2=zeros(9,1);
            %howth2=zeros(9,1);
            Dt=norm(robot-endpoint);
            Dth(i1)=Dthmax-i1*dirtD;
            c=[];
            if  Dth(i1)<Dt
                threshold(i1)=C^2*Iij(Dth(i1));
                j=1;q=1;
                
                while (q<=n)       
                    %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                    if(his(q)< threshold(i1))
                        kr=q;                        % �ҵ��˲��ȵ����
                        while(q<=n && his(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                            kl=q;
                            q=q+1;
                        end

                        if(kl-kr > smax)                  % ����
                            c   =  [c round(kl - smax/2)];  % �������
                            c   =  [c round(kr + smax/2)];  % �����Ҳ�
                            %j=j+1;
                            if(kt >= kr && kt <= kl)
                                c  = [c kt];                % straight at look ahead
                                %j=j+1;
                            end
                         elseif(kl-kr > smax/5)           % խ����
                            c   =  [c round((kr+kl)/2-2.5)];
                            %j=j+1;
                         end

                    else
                        q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                    end                                   % �˳�ifѡ���ٴν���while����ѭ��
                end                                       % �˳�whileѭ��
                % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                numb=length(c);
                temp2=howmuchs(Dth(i1),Dthmax,numb,c,kt);
            end 
            kb{1,i1}=c;
            howth=[howth temp2];       %�洢��ֵ�ۺϴ���    
            i1=i1+1;
        end
        ftth=find(howth==min(howth));
        kbbest=kb{1,ftth(1)};   %��ʱ�����һ�������ֵ�µ����ɱ�ѡ����
        %���ڣ�Ҫ�ж��Ƿ����VFH*�㷨����·���滮
        %�ж����鱸ѡ�����ܷ�ֳ������飺��ȷ����ǰ�˶�����
        %���һ��
        %if  (0<=km&&km<=round((ds/radius)/alpha))||(72-round((ds/radius)/alpha)<=km&&km<=72) 
        if 0<=km&&km<=round((ds/radius)/alpha)  %������
           lml=km+round((ds/radius)/alpha); %��߽�
           lmr=km-round((ds/radius)/alpha)+72; %�ұ߽�
           numb1=length(kbbest); 
           phib=km+36; %��ǰ�˶�������
           tempkl=[];
           tempkr=[];
           for j1=1:numb1
               if km<=kbbest(j1)&&kbbest(j1)<=lml  %��߷���ɴ�
                  tempkl=[tempkl kbbest(j1)];
               %end
               elseif lml<=kbbest(j1)&&kbbest(j1)<=phib %��߷��򲻿ɴ�
                  tempkl=[tempkl lml];
               %end
               elseif phib<=kbbest(j1)&&kbbest(j1)<=lmr %�ұ߷��򲻿ɴ�
                  tempkr=[tempkr lmr];
               %end
               elseif lmr<=kbbest(j1)&&kbbest(j1)<=72  %�ұ߷���ɴ� ״̬һ
                  tempkr=[tempkr kbbest(j1)];
               %end
               %if 0<=kbbest(j1)<=km  %�ұ߷���ɴ� ״̬�� 
               else
                  tempkr=[tempkr kbbest(j1)]; 
               end
           end         
        %else
        elseif 72-round((ds/radius)/alpha)<=km&&km<=72  %�۽����
           lml=km+round((ds/radius)/alpha)-72;  %��߽�
           if lml~=0
           else
              lml=1; 
           end
           lmr=km-round((ds/radius)/alpha);  %�ұ߽�
           numb1=length(kbbest);
           phib=km-36;  %��ǰ�˶�������
           tempkl=[];
           tempkr=[];
           for j2=1:numb1
               if phib<=kbbest(j2)&&kbbest(j2)<=lmr  %�ұ߷��򲻿ɴ�
                  tempkr=[tempkr lmr]; 
               %end
               elseif lmr<=kbbest(j2)&&kbbest(j2)<=km  %�ұ߷���ɴ�
                  tempkr=[tempkr kbbest(j2)]; 
               %end
               elseif km<=kbbest(j2)&&kbbest(j2)<=72  %��߷���ɴ� ״̬һ
                  tempkl=[tempkl kbbest(j2)];
               %end
               elseif 0<=kbbest(j2)&&kbbest(j2)<=lml  %��߷���ɴ� ״̬��
                  tempkl=[tempkl kbbest(j2)]; 
               %end
               else
               %if lml<=kbbest(j2)<=phib  %��߷��򲻿ɴ�
                  tempkl=[tempkl lml]; 
               end
           end
        
        %end
        %�����
        elseif  round((ds/radius)/alpha)<=km&&km<=36 
            lml=km+round((ds/radius)/alpha); %��߽�
            lmr=km-round((ds/radius)/alpha); %�ұ߽�
            numb1=length(kbbest); 
            phib=km+36; %��ǰ�˶�������
            tempkl=[];
            tempkr=[];
            for j3=1:numb1
                if km<=kbbest(j3)&&kbbest(j3)<=lml  %��߷���ɴ�
                   tempkl=[tempkl kbbest(j3)]; 
                %end
                elseif lml<=kbbest(j3)&&kbbest(j3)<=phib  %��߷��򲻿ɴ�
                   tempkl=[tempkl lml]; 
                %end
                elseif km<=kbbest(j3)&&kbbest(j3)<=lmr  %�ұ߷���ɴ�
                   tempkr=[tempkr kbbest(j3)]; 
                %end
                else
                tempkr=[tempkr lmr];  %�ұ߷��򲻿ɴ�
                end
            end 
        %end
        else
        %�����
        %if  36<=km<=72-round((ds/radius)/alpha)
            lml=km+round((ds/radius)/alpha); %��߽�
            lmr=km-round((ds/radius)/alpha); %�ұ߽�
            numb1=length(kbbest); 
            phib=km-36; %��ǰ�˶�������
            tempkl=[];
            tempkr=[];
            for j4=1:numb1
                if lmr<=kbbest(j4)&&kbbest(j4)<=km  %�ұ߷���ɴ�
                   tempkr=[tempkr kbbest(j4)]; 
                %end
                elseif phib<=kbbest(j4)&&kbbest(j4)<=lmr  %�ұ߷��򲻿ɴ�
                   tempkr=[tempkr lmr]; 
                %end
                elseif km<=kbbest(j4)&&kbbest(j4)<=lml  %��߷���ɴ�
                   tempkl=[tempkl kbbest(j4)]; 
                %end
                else
                tempkl=[tempkl lml];  %��߷��򲻿ɴ�
                end
            end
        end
        % �ж��Ƿ����VFH*�㷨 ���������ǲ��Ƕ�������һ������
        geshul=length(tempkl);
        geshur=length(tempkr);
        if  geshul>=1&&geshur>=1  %��������-��ʼ����VFH*�㷨
            refp=cell(1,6);  %δ��ͶӰλ�õ�����
            gc=cell(1,6);  %δ��ͶӰλ�õĴ���
            hc=cell(1,6);  %δ��ͶӰλ�õ�����ֵ
            fc=cell(1,6);  %δ��ͶӰλ�õ��ۺ��ж�ֵ
            pp=cell(1,6);  %δ��ͶӰλ�õĽڵ�
            pfcun=zeros(1,4);  %����ÿ���ڵ����ѷ���
            ng=1;  % ��ʼVFH* ��һ������
            %��ȷ����һ���ڵ�����ҷ���
            if  norm(robot-ref)==0
                lc=kt;
            else
            %if  norm(robot-ref)~=0
                lc=lc;
            end 
            g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
            for i14=1:geshul
                g1l(i14)=tempkl(i14);
                order1l=g1l(i14);
                ol1l=g1l(i14)-1;
                or1l=g1l(i14)+1;
                if ol1l~=0
                   if or1l~=73
                   how1l(i14,1)=howmany(g1l(i14),kt,km,lc,his(order1l),his(ol1l),his(or1l));
                   else
                   how1l(i14,1)=howmany(g1l(i14),kt,km,lc,his(order1l),his(ol1l),inf);    
                   end
                else
                   how1l(i14,1)=howmany(g1l(i14),kt,km,lc,his(order1l),inf,his(or1l)); 
                end
            end
            ft1l=find(how1l==min(how1l));
            ft1l;
            
            pf1lbest=filt(g1l(ft1l),kt);  %�ҵ������ѷ���
            g1r=zeros(geshur,1);how1r=zeros(geshur,1);  %�ұ�ǰ������
            for i15=1:geshur
                g1r(i15)=tempkr(i15);
                order1r=g1r(i15);
                ol1r=g1r(i15)-1;
                or1r=g1r(i15)+1;
                if ol1r~=0
                   if or1r~=73 
                   how1r(i15)=howmany(g1r(i15),kt,km,lc,his(order1r),his(ol1r),his(or1r));
                   else
                   how1r(i15)=howmany(g1r(i15),kt,km,lc,his(order1r),his(ol1r),inf);    
                   end
                else
                   how1r(i15)=howmany(g1r(i15),kt,km,lc,his(order1r),inf,his(or1r));
                end
            end
            ft1r=find(how1r==min(how1r));
            pf1rbest=filt(g1r(ft1r),kt);  %�ҵ��ұ���ѷ���
            %ǰ����ͶӰ��
            pp{1,1}=robot+[v_car*time*cos(pf1lbest*alpha),v_car*time*sin(pf1lbest*alpha)];
            pp{1,2}=robot+[v_car*time*cos(pf1rbest*alpha),v_car*time*sin(pf1rbest*alpha)];
            ol1l=pf1lbest-1;
            or1l=pf1lbest+1;
            order1l=pf1lbest;
            if ol1l~=0
               if or1l~=73 
               gc{1,1}=howmanys(pf1lbest,kt,km,lc,his(order1l),his(ol1l),his(or1l),ng);
               else
               gc{1,1}=howmanys(pf1lbest,kt,km,lc,his(order1l),his(ol1l),inf,ng);    
               end
            else
               gc{1,1}=howmanys(pf1lbest,kt,km,lc,his(order1l),inf,his(or1l),ng); 
            end
            ol1r=pf1rbest-1;
            or1r=pf1rbest+1;
            order1r=pf1rbest;
            if ol1r~=0
               if or1r~=73  
               gc{1,2}=howmanys(pf1rbest,kt,km,lc,his(order1r),his(ol1r),his(or1r),ng);
               else
               gc{1,2}=howmanys(pf1rbest,kt,km,lc,his(order1r),his(ol1r),inf,ng);    
               end
            else
               gc{1,2}=howmanys(pf1rbest,kt,km,lc,his(order1r),inf,his(or1r),ng); 
            end
            kt1l=round(caculatebeta(pp{1,1},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
            kt1r=round(caculatebeta(pp{1,2},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
            hc{1,1}=heu(kt1l,pf1lbest,pf1lbest,ng);
            hc{1,2}=heu(kt1r,pf1rbest,pf1rbest,ng);
            fc{1,1}=gc{1,1}+hc{1,1};
            fc{1,2}=gc{1,2}+hc{1,2};
            % ��ʼ VFH* �ڶ�������
            ng=ng+1;
            % ������һ��ͶӰ��ļ�ֱ��ͼ
            i2=1;mag1l = zeros(n,1);his1l=zeros(n,1);
            while (i2<=length(obstacle))  
            
            %%%%%%%%%%% ����һ�γ���õ�ͶӰ��һ��360�ȷ�Χ��Ұ�ڵ��ϰ���ֲ�ֵ 72�������ļ��ϰ����ܶ�  
            
                d1l = norm(obstacle(i2,:) - pp{1,1}); % �ϰ���դ���������֮�����
                if (d1l<dmax)
                    beta1l = caculatebeta(pp{1,1},obstacle(i2,:));  % �ϰ���դ�������ķ���
                    rangle1l=asin(rsafe/d1l);        % ����ĽǶ�
                    k1l = round(beta1l/alpha);       % ��ʱ��������k����������
                    if(k1l == 0)
                        k1l = 1;
                    end
                    % ���º�ļ�����ֱ��ͼ��hֵ
                    if((5*k1l>rad2deg(beta1l)-rad2deg(rangle1l))&&(5*k1l<rad2deg(beta1l)+rad2deg(rangle1l)))  
                        h1l(k1l)=1;
                    else
                        h1l(k1l)=0;
                    end
                    i2=i2+1;

                    m1l = C^2*Iij(d1l);   % �ϰ���դ���������ֵ����VFH���㷽����ͬ
                    mag1l(k1l)=max(mag1l(k1l),m1l.*h1l(k1l));   % magΪzeros(n,1)��mag�ĵ�k��Ԫ��Ϊm
                    i2=i2+1;
                else
                    i2=i2+1;
                end
            end
            % ��һ��ͶӰ�㣺��VFH+�ų�һЩ����
            i41l=1; %Ӧ��VFH+�㷨�������˶��뾶���� �ų����������
            if  norm(pp{1,1}-ref)==0
                km=kt;
            else
            %if  norm(pp{1,1}-ref)~=0
                km=pf1lbest;
            end
            while (i41l<=length(obstacle))

                %%%%%%%%%% ����ת��뾶����
                    km
                    dirtr(1)=radius*sin(km*alpha);   dirtr(2)=radius*cos(km*alpha);         %��ת�����Ĳ���
                    centerr(1)=pp{1,1}(1)+dirtr(1); centerr(2)=pp{1,1}(2)+dirtr(2); %��ת����������
                    dirtl(1)=-radius*sin(km*alpha);  dirtl(2)=-radius*cos(km*alpha);        %��ת�����Ĳ���
                    centerl(1)=pp{1,1}(1)+dirtl(1); centerl(2)=pp{1,1}(2)+dirtl(2); %��ת����������
                    %dor=norm(obstacle(i,:) - centerr);                          %�ϰ��ﵽ��ת�����ĵľ���
                    %dor=norm(obstacle(i,:) - centerl);                          %�ϰ��ﵽ��ת�����ĵľ���
                    dirtor(1)=obstacle(i41l)-pp{1,1}(1); dirtor(2)=obstacle(2)-pp{1,1}(2); %�ϰ��ﵽ�����˵������
                    disor=(dirtr(1)-dirtor(1))^2+(dirtr(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    disol=(dirtl(1)-dirtor(1))^2+(dirtl(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    if 0<=km&&km<36
                        phib=km+36; %��ʼ���޽Ƕ�=�˶�����ķ�����
                        phil=phib;  %��ʼ���޽Ƕ�
                        phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                        beta = caculatebeta(pp{1,1},obstacle(i41l,:));
                        k = round(beta/alpha); %�ϰ������ڵ�����
                        if km<=k&&km<phil  %�ϰ�������������
                            if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phil=k;
                                i5=phil;
                                while (phil<=i5&&i5<=phib)
                                    mag1l(i5)=max(mag1l);
                                    i5=i5+1;
                                end
                            end
                        else
                        %if (0<=k<km|phir<=k<=n) %�ϰ������Ұ������
                            if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phir=k;
                                if phir<=k&&k<=n
                                    i6=phib;
                                    while (phib<=i6&&i6<=phir)
                                        mag1l(i6)=max(mag1l);
                                        i6=i6+1;
                                    end
                                else
                                %if 0<=k<=km
                                    i7=phib;
                                    while (phib<=i7&&i7<=72)
                                        mag1l(i7)=max(mag1l);
                                        i7=i7+1;
                                    end
                                    i8=1;
                                    while (0<=i8&&i8<=phir)
                                        mag1l(i8)=max(mag1l);
                                        i8=i8+1;
                                    end
                                end
                            end
                        end
                    else
                    %if 36<=km<=72
                       phib=km-36; %��ʼ���޽Ƕ�=�˶�����ķ����� 
                       phil=phib;  %��ʼ���޽Ƕ�
                       phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                       beta = caculatebeta(pp{1,1},obstacle(i41l,:));
                       k = round(beta/alpha); %�ϰ������ڵ�����
                       if k~=0
                       else
                           k=1;
                       end
                       if phir<=k&&k<km  %�ϰ������Ұ������
                          if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                             phir=k;
                             i9=phib;
                             while (phib<=i9&&i9<=phir)
                                   mag1l(i9)=max(mag1l);
                                   i9=i9+1;
                             end
                          end
                       else
                       %if (km<=k<72|0<=k<=phil) %�ϰ�������������
                           if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                              phil=k;
                                if 0<=k&&k<=phib
                                    i10=phil;
                                    while (phil<=i10&&i10<=phib)
                                        mag1l(i10)=max(mag1l);
                                        i10=i10+1;
                                    end
                                else
                                %if km<=k<=72
                                    i11=1;
                                    while (0<=i11&&i11<=phib)
                                        mag1l(i11)=max(mag1l);
                                        i11=i11+1;
                                    end
                                    i12=1;
                                    while (phil<=i12&&i12<=72)
                                        mag1l(i12)=max(mag1l);
                                        i12=i12+1;
                                    end
                                end
                           end
                       end  
                    end
                    i41l=i41l+1;
            end
        
            his1l=mag1l;      %���� his ��һ����72��Ԫ�ص�����--���������ϰ����ܶ�
            % ��һ��ͶӰ�㣺ѡȡһ����ѱ�ѡ����
            i1=1; %����Ӧ��ֵ��ѭ������
            kb=cell(1,blcs);
            howth=[];
            while (i1<=blcs)   % ����Ӧ��ֵ��whileѭ��������i1 i1ȡ9��ʱ�� ����ĳһ��ͣ�� i1ȡ15��ʱ�� ��ɱ��ϣ�˵������Ӧ��ֵ��Ч������
                %kb2=zeros(9,1);
                %howth2=zeros(9,1);
                Dt=norm(pp{1,1}-endpoint);
                Dth(i1)=Dthmax-i1*dirtD;
                c=[];
                if  Dth(i1)<Dt
                    threshold(i1)=C^2*Iij(Dth(i1));
                    j=1;q=1;
                    
                    while (q<=n)       
                        %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                        if(his1l(q)< threshold(i1))
                            kr=q;                        % �ҵ��˲��ȵ����
                            while(q<=n && his1l(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                                kl=q;
                                q=q+1;
                            end

                            if(kl-kr > smax)                  % ����
                                c   = [c round(kl - smax/2)];  % �������
                                c   = [c round(kr + smax/2)];  % �����Ҳ�
                                %j=j+2;
                                if(kt1l >= kr && kt1l <= kl)
                                    c  = [c kt1l];                % straight at look ahead
                                    %j=j+1;
                                end
                             elseif(kl-kr > smax/5)           % խ����
                                c  = [c round((kr+kl)/2-2.5)];
                                %j=j+1;
                             end

                        else
                            q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                        end                                   % �˳�ifѡ���ٴν���while����ѭ��
                    end                                       % �˳�whileѭ��

                    % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                    numb=length(c);
                    temp2=howmuchs(Dth(i1),Dthmax,numb,c,kt1l);
                end 

                %temp1=howmuch(Dth(i1),fk,kt,Dthmax);   
                kb{1,i1}=c;
                howth=[howth temp2];       %�洢��ֵ�ۺϴ���    
                i1=i1+1;
            end
            ftth=find(howth==min(howth));
            kbbest1l=kb{1,ftth(1)};   %��ʱ�����һ�������ֵ�µ����ɱ�ѡ����
            %��һ��ͶӰ�㣺�ܷ������
            
            %���һ��
            %if  0<=km<=round((ds/radius)/alpha)||72-round((ds/radius)/alpha)<=km<=72 
            if 0<=km&&km<=round((ds/radius)/alpha)  %������
               lml=km+round((ds/radius)/alpha); %��߽�
               lmr=km-round((ds/radius)/alpha)+72; %�ұ߽�
               numb1=length(kbbest1l); 
               phib=km+36; %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j1=1:numb1
                   if km<=kbbest1l(j1)&&kbbest1l(j1)<=lml  %��߷���ɴ�
                      tempkl=[tempkl kbbest1l(j1)];
                   %end
                   elseif lml<=kbbest1l(j1)&&kbbest1l(j1)<=phib %��߷��򲻿ɴ�
                      tempkl=[tempkl lml];
                   %end
                   elseif phib<=kbbest1l(j1)&&kbbest1l(j1)<=lmr %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr];
                   %end
                   elseif lmr<=kbbest1l(j1)&&kbbest1l(j1)<=72  %�ұ߷���ɴ� ״̬һ
                      tempkr=[tempkr kbbest1l(j1)];
                   %end
                   else
                   %if 0<=kbbest1l(j1)<=km  %�ұ߷���ɴ� ״̬��   
                      tempkr=[tempkr kbbest1l(j1)]; 
                   end
               end         
            
            elseif 72-round((ds/radius)/alpha)<=km&&km<=72  %�۽����
               lml=km+round((ds/radius)/alpha)-72;  %��߽�
               if lml~=0
               else
                  lml=1; 
               end
               lmr=km-round((ds/radius)/alpha);  %�ұ߽�
               numb1=length(kbbest1l);
               phib=km-36;  %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j2=1:numb1
                   if phib<=kbbest1l(j2)&&kbbest1l(j2)<=lmr  %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr]; 
                   %end
                   elseif lmr<=kbbest1l(j2)&&kbbest1l(j2)<=km  %�ұ߷���ɴ�
                      tempkr=[tempkr kbbest1l(j2)]; 
                   %end
                   elseif km<=kbbest1l(j2)&&kbbest1l(j2)<=72  %��߷���ɴ� ״̬һ
                      tempkl=[tempkl kbbest1l(j2)];
                   %end
                   elseif 0<=kbbest1l(j2)&&kbbest1l(j2)<=lml  %��߷���ɴ� ״̬��
                      tempkl=[tempkl kbbest1l(j2)]; 
                   %end
                   else
                   %if lml<=kbbest1l(j2)<=phib  %��߷��򲻿ɴ�
                      tempkl=[tempkl lml]; 
                   end
               end
            
            %end
            %�����
            elseif  round((ds/radius)/alpha)<=km&&km<=36 
                lml=km+round((ds/radius)/alpha); %��߽�
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1l); 
                phib=km+36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j3=1:numb1
                    if km<=kbbest1l(j3)&&kbbest1l(j3)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1l(j3)]; 
                    %end
                    elseif lml<=kbbest1l(j3)&&kbbest1l(j3)<=phib  %��߷��򲻿ɴ�
                       tempkl=[tempkl lml]; 
                    %end
                    elseif km<=kbbest1l(j3)&&kbbest1l(j3)<=lmr  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1l(j3)]; 
                    else
                    tempkr=[tempkr lmr];  %�ұ߷��򲻿ɴ�
                    end
                end 
            %end
            else
            %�����
            %if  36<=km<=72-round((ds/radius)/alpha)
                lml=km+round((ds/radius)/alpha); %��߽�
                if lml~=0
                else
                   lml=1; 
                end
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1l); 
                phib=km-36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j4=1:numb1
                    if lmr<=kbbest1l(j4)&&kbbest1l(j4)<=km  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1l(j4)]; 
                    %end
                    elseif phib<=kbbest1l(j4)&&kbbest1l(j4)<=lmr  %�ұ߷��򲻿ɴ�
                       tempkr=[tempkr lmr]; 
                    %end
                    elseif km<=kbbest1l(j4)&&kbbest1l(j4)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1l(j4)]; 
                    else
                    tempkl=[tempkl lml];  %��߷��򲻿ɴ� 
                    end
                end
            end
            
            geshul=length(tempkl);
            geshur=length(tempkr);
            %��һ��ͶӰ�㣺�ܷ�����
            if  geshul>=1&&geshur>=1  
                lc=pf1lbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                       if or1l~=73 
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l));
                       else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),inf);   
                       end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),inf,his1l(or1l));
                    end
                end
                ft1ll=find(how1l==min(how1l));
                pf1llbest=filt(g1l(ft1ll),kt1l);  %�ҵ������ѷ��� 
                g1r=zeros(geshur,1);how1r=zeros(geshur,1);  %�ұ�ǰ������
                for i15=1:geshur
                    g1r(i15)=tempkr(i15);
                    order1r=g1r(i15);
                    ol1r=g1r(i15)-1;
                    or1r=g1r(i15)+1;
                    if ol1r~=0
                       if or1r~=73
                       how1r(i15)=howmany(g1r(i15),kt1l,km,lc,his1l(order1r),his1l(ol1r),his1l(or1r));
                       else
                       how1r(i15)=howmany(g1r(i15),kt1l,km,lc,his1l(order1r),his1l(ol1r),inf);    
                       end
                    else
                       how1r(i15)=howmany(g1r(i15),kt1l,km,lc,his1l(order1r),inf,his1l(or1r));
                    end
                end
                ft1lr=find(how1r==min(how1r));
                pf1lrbest=filt(g1r(ft1lr),kt1l);  %�ҵ��ұ���ѷ���
                %ǰ����ͶӰ��
                pp{1,3}=pp{1,1}+[v_car*time*cos(pf1llbest*alpha),v_car*time*sin(pf1llbest*alpha)];
                pp{1,4}=pp{1,1}+[v_car*time*cos(pf1lrbest*alpha),v_car*time*sin(pf1lrbest*alpha)];
                ol1l=pf1llbest-1;
                or1l=pf1llbest+1;
                order1l=pf1llbest;
                if ol1l~=0
                   if or1l~=73 
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l),ng)+gc{1,1};
                   else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),inf,ng)+gc{1,1};    
                   end
                else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),inf,his1l(or1l),ng)+gc{1,1}; 
                end
                ol1r=pf1lrbest-1;
                or1r=pf1lrbest+1;
                order1r=pf1lrbest;
                if ol1r~=0
                   if or1r~=73 
                   gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1r),his1l(ol1r),his1l(or1r),ng)+gc{1,1};
                   else
                   gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1r),his1l(ol1r),inf,ng)+gc{1,1};    
                   end
                else
                   gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1r),inf,his1l(or1r),ng)+gc{1,1}; 
                end
                kt1ll=round(caculatebeta(pp{1,3},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                kt1lr=round(caculatebeta(pp{1,4},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,3}=heu(kt1ll,pf1llbest,pf1llbest,ng);
                hc{1,4}=heu(kt1lr,pf1lrbest,pf1lrbest,ng);
                fc{1,3}=gc{1,3}+hc{1,3};
                fc{1,4}=gc{1,4}+hc{1,4};
                pfcun(1,1)=pf1llbest;
                pfcun(1,2)=pf1lrbest;
            %end
            %��һ��ͶӰ�㣺���ܷ����� ֻ��һ������
            elseif  geshul>=1&&geshur==0  %�÷�������
                lc=pf1lbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                       if or1l~=73 
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l));
                       else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),inf);    
                       end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),inf,his1l(or1l)); 
                    end
                end
                ft1ll=find(how1l==min(how1l));
                pf1llbest=filt(g1l(ft1ll),kt1l);  %�ҵ������ѷ��� 
                pp{1,3}=pp{1,1}+[v_car*time*cos(pf1llbest*alpha),v_car*time*sin(pf1llbest*alpha)];
                ol1l=pf1llbest-1;
                or1l=pf1llbest+1;
                order1l=pf1llbest;
                if ol1l~=0
                   if or1l~=73 
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l),ng)+gc{1,1};
                   else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),inf,ng)+gc{1,1};   
                   end
                else
                   gc{1,3}=howmanys(pf1llbest,kt1l,km,lc,his1l(order1l),inf,his1l(or1l),ng)+gc{1,1}; 
                end
                kt1ll=round(caculatebeta(pp{1,3},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,3}=heu(kt1ll,pf1llbest,pf1llbest,ng);
                fc{1,3}=gc{1,3}+hc{1,3};
                fc{1,4}=inf;
                pfcun(1,1)=pf1llbest;
            %end
            elseif  geshur>=1&&geshul==0  %�÷�������
                lc=pf1lbest;
                g1l=zeros(geshur,1);how1l=zeros(geshur,1);  %�ұ�ǰ������ 
                for i14=1:geshur
                    g1l(i14)=tempkr(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                        if or1l~=73
                        how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l));
                        else
                        how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),his1l(ol1l),inf);    
                        end
                    else
                        how1l(i14)=howmany(g1l(i14),kt1l,km,lc,his1l(order1l),inf,his1l(or1l)); 
                    end
                end
                ft1lr=find(how1l==min(how1l));
                pf1lrbest=filt(g1l(ft1lr),kt1l);  %�ҵ��ұ���ѷ��� 
                pp{1,4}=pp{1,1}+[v_car*time*cos(pf1lrbest*alpha),v_car*time*sin(pf1lrbest*alpha)];
                ol1l=pf1lrbest-1;
                or1l=pf1lrbest+1;
                order1l=pf1lrbest;
                if ol1l~=0
                    if or1l~=73
                    gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),his1l(or1l),ng)+gc{1,1};
                    else
                    gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1l),his1l(ol1l),inf,ng)+gc{1,1};    
                    end
                else
                    gc{1,4}=howmanys(pf1lrbest,kt1l,km,lc,his1l(order1l),inf,his1l(or1l),ng)+gc{1,1};
                end
                kt1lr=round(caculatebeta(pp{1,4},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,4}=heu(kt1lr,pf1lrbest,pf1lrbest,ng);
                fc{1,4}=gc{1,4}+hc{1,4};
                fc{1,3}=inf;
                pfcun(1,2)=pf1lrbest;
            %end
            %��һ��ͶӰ�㣺���ܷ����� �޷���
            else
            %if  geshul==geshur==0
                fc{1,3}=inf;
                fc{1,4}=inf;
            end
            % �����ڶ���ͶӰ��ļ�ֱ��ͼ
            i3=1;mag1r = zeros(n,1);his1r=zeros(n,1);
            while (i3<=length(obstacle))  
            
            %%%%%%%%%%% ����һ�γ���õ�������360�ȷ�Χ��Ұ�ڵ��ϰ���ֲ�ֵ 72�������ļ��ϰ����ܶ�  
            
                d1r = norm(obstacle(i3,:) - pp{1,2}); % �ϰ���դ���������֮�����
                if (d1r<dmax)
                    beta1r = caculatebeta(pp{1,2},obstacle(i3,:));  % �ϰ���դ�������ķ���
                    rangle1r=asin(rsafe/d1r);        % ����ĽǶ�
                    k1r = round(beta1r/alpha);       % ��ʱ��������k����������
                    if(k1r == 0)
                        k1r = 1;
                    end
                    % ���º�ļ�����ֱ��ͼ��hֵ
                    if((5*k1r>rad2deg(beta1r)-rad2deg(rangle1r))&&(5*k1r<rad2deg(beta1r)+rad2deg(rangle1r)))  
                        h1r(k1r)=1;
                    else
                        h1r(k1r)=0;
                    end
                    i3=i3+1;

                    m1r = C^2*Iij(d1r);   % �ϰ���դ���������ֵ����VFH���㷽����ͬ
                    mag1r(k1r)=max(mag1r(k1r),m1r.*h1r(k1r));   % magΪzeros(n,1)��mag�ĵ�k��Ԫ��Ϊm
                    i3=i3+1;
                else
                    i3=i3+1;
                end 
            end
            %�ڶ���ͶӰ�㣺��VFH+�ų�һЩ����
            i41r=1; %Ӧ��VFH+�㷨�������˶��뾶���� �ų����������
            km=pf1rbest;
            while (i41r<=length(obstacle))

                %%%%%%%%%% ����ת��뾶����
                    
                    dirtr(1)=radius*sin(km*alpha);   dirtr(2)=radius*cos(km*alpha);         %��ת�����Ĳ���
                    centerr(1)=pp{1,2}(1)+dirtr(1); centerr(2)=pp{1,2}(2)+dirtr(2); %��ת����������
                    dirtl(1)=-radius*sin(km*alpha);  dirtl(2)=-radius*cos(km*alpha);        %��ת�����Ĳ���
                    centerl(1)=pp{1,2}(1)+dirtl(1); centerl(2)=pp{1,2}(2)+dirtl(2); %��ת����������
                    %dor=norm(obstacle(i,:) - centerr);                          %�ϰ��ﵽ��ת�����ĵľ���
                    %dor=norm(obstacle(i,:) - centerl);                          %�ϰ��ﵽ��ת�����ĵľ���
                    dirtor(1)=obstacle(i41r)-pp{1,2}(1); dirtor(2)=obstacle(2)-pp{1,2}(2); %�ϰ��ﵽ�����˵������
                    disor=(dirtr(1)-dirtor(1))^2+(dirtr(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    disol=(dirtl(1)-dirtor(1))^2+(dirtl(2)-dirtor(2))^2; %�ϰ��ﵽ��ת�����ľ��루ƽ����
                    if 0<=km&&km<36
                        phib=km+36; %��ʼ���޽Ƕ�=�˶�����ķ�����
                        phil=phib;  %��ʼ���޽Ƕ�
                        phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                        beta = caculatebeta(pp{1,2},obstacle(i41r,:));
                        k = round(beta/alpha); %�ϰ������ڵ�����
                        if km<=k&&k<phil  %�ϰ�������������
                            if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phil=k;
                                i5=phil;
                                while (phil<=i5&&i5<=phib)
                                    mag1r(i5)=max(mag1r);
                                    i5=i5+1;
                                end
                            end
                        else
                        %if (0<=k<km|phir<=k<=n) %�ϰ������Ұ������
                            if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                                phir=k;
                                if phir<=k&&k<=n
                                    i6=phib;
                                    while (phib<=i6&&i6<=phir)
                                        mag1r(i6)=max(mag1r);
                                        i6=i6+1;
                                    end
                                else
                                %if 0<=k<=km
                                    i7=phib;
                                    while (phib<=i7&&i7<=72)
                                        mag1r(i7)=max(mag1r);
                                        i7=i7+1;
                                    end
                                    i8=1;
                                    while (0<=i8&&i8<=phir)
                                        mag1r(i8)=max(mag1r);
                                        i8=i8+1;
                                    end
                                end
                            end
                        end
                    else
                    %if 36<=km<=72
                       phib=km-36; %��ʼ���޽Ƕ�=�˶�����ķ����� 
                       phil=phib;  %��ʼ���޽Ƕ�
                       phir=phib;  %��ʼ�Ҽ��޽Ƕ�
                       beta = caculatebeta(pp{1,2},obstacle(i41r,:));
                       k = round(beta/alpha); %�ϰ������ڵ�����
                       if k~=0
                       else
                          k=1;
                       end
                       if phir<=k&&k<km  %�ϰ������Ұ������
                          if disor<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                             phir=k;
                             i9=phib;
                             while (phib<=i9&&i9<=phir)
                                   mag1r(i9)=max(mag1r);
                                   i9=i9+1;
                             end
                          end
                       else
                       %if (km<=k<72|0<=k<=phil) %�ϰ�������������
                           if disol<(radius+rsafe)^2   %����ϰ��ﵲס����ת��Բ�켣
                              phil=k;
                                if 0<=k&&k<=phib
                                    i10=phil;
                                    while (phil<=i10&&i10<=phib)
                                        i10
                                        mag1r(i10)=max(mag1r);
                                        i10=i10+1;
                                    end
                                else
                                %if km<=k<=72
                                    i11=1;
                                    while (0<=i11&&i11<=phib)
                                        mag1r(i11)=max(mag1r);
                                        i11=i11+1;
                                    end
                                    i12=1;
                                    while (phil<=i12&&i12<=72)
                                        mag1r(i12)=max(mag1r);
                                        i12=i12+1;
                                    end
                                end
                           end
                       end  
                    end
                    i41r=i41r+1;
            end
        
            his1r=mag1r;      %���� his ��һ����72��Ԫ�ص�����--���������ϰ����ܶ�
            %�ڶ���ͶӰ�㣺ѡȡһ����ѱ�ѡ����
            i1=1; %����Ӧ��ֵ��ѭ������
            kb=cell(1,blcs);
            howth=[];
            while (i1<=blcs)   % ����Ӧ��ֵ��whileѭ��������i1 i1ȡ9��ʱ�� ����ĳһ��ͣ�� i1ȡ15��ʱ�� ��ɱ��ϣ�˵������Ӧ��ֵ��Ч������
                %kb2=zeros(9,1);
                %howth2=zeros(9,1);
                Dt=norm(pp{1,2}-endpoint);
                Dth(i1)=Dthmax-i1*dirtD;
                c=[];
                if  Dth(i1)<Dt
                    threshold(i1)=C^2*Iij(Dth(i1));
                    j=1;q=1;
                    
                    while (q<=n)       
                        %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                        if(his1r(q)< threshold(i1))
                            kr=q;                        % �ҵ��˲��ȵ����
                            while(q<=n && his1r(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                                kl=q;
                                q=q+1;
                            end

                            if(kl-kr > smax)                  % ����
                                c   = [c round(kl - smax/2)];  % �������
                                c   = [c round(kr + smax/2)];  % �����Ҳ�
                                %j=j+2;
                                if(kt1r >= kr && kt1r <= kl)
                                    c  = [c kt1r];                % straight at look ahead
                                    %j=j+1;
                                end
                             elseif(kl-kr > smax/5)           % խ����
                                c  = [c round((kr+kl)/2-2.5)];
                                %j=j+1;
                             end

                        else
                            q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                        end                                   % �˳�ifѡ���ٴν���while����ѭ��
                    end                                       % �˳�whileѭ��

                    % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                    numb=length(c);
                    temp2=howmuchs(Dth(i1),Dthmax,numb,c,kt1r);
                end 

                %temp1=howmuch(Dth(i1),fk,kt,Dthmax);   
                kb{1,i1}=c;
                howth=[howth temp2];       %�洢��ֵ�ۺϴ���    
                i1=i1+1;
            end
            ftth=find(howth==min(howth));
            kbbest1r=kb{1,ftth(1)};   %��ʱ�����һ�������ֵ�µ����ɱ�ѡ����
            %�ڶ���ͶӰ�㣺�ܷ������
            %���һ��
            %if  0<=km<=round((ds/radius)/alpha)||72-round((ds/radius)/alpha)<=km<=72 
            if 0<=km&&km<=round((ds/radius)/alpha)  %������
               lml=km+round((ds/radius)/alpha); %��߽�
               lmr=km-round((ds/radius)/alpha)+72; %�ұ߽�
               numb1=length(kbbest1r); 
               phib=km+36; %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j1=1:numb1
                   if km<=kbbest1r(j1)&&kbbest1r(j1)<=lml  %��߷���ɴ�
                      tempkl=[tempkl kbbest1r(j1)];
                   %end
                   elseif lml<=kbbest1r(j1)&&kbbest1r(j1)<=phib %��߷��򲻿ɴ�
                      tempkl=[tempkl lml];
                   %end
                   elseif phib<=kbbest1r(j1)&&kbbest1r(j1)<=lmr %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr];
                   %end
                   elseif lmr<=kbbest1r(j1)&&kbbest1r(j1)<=72  %�ұ߷���ɴ� ״̬һ
                      tempkr=[tempkr kbbest1r(j1)];
                   %end
                   else
                   %if 0<=kbbest1r(j1)<=km  %�ұ߷���ɴ� ״̬��   
                      tempkr=[tempkr kbbest1r(j1)]; 
                   end
               end         
            
            elseif 72-round((ds/radius)/alpha)<=km&&km<=72  %�۽����
               lml=km+round((ds/radius)/alpha)-72;  %��߽�
               if lml~=0
               else
                  lml=1; 
               end
               lmr=km-round((ds/radius)/alpha);  %�ұ߽�
               numb1=length(kbbest1r);
               phib=km-36;  %��ǰ�˶�������
               tempkl=[];
               tempkr=[];
               for j2=1:numb1
                   if phib<=kbbest1r(j2)&&kbbest1r(j2)<=lmr  %�ұ߷��򲻿ɴ�
                      tempkr=[tempkr lmr]; 
                   %end
                   elseif lmr<=kbbest1r(j2)&&kbbest1r(j2)<=km  %�ұ߷���ɴ�
                      tempkr=[tempkr kbbest1r(j2)]; 
                   %end
                   elseif km<=kbbest1r(j2)&&kbbest1r(j2)<=72  %��߷���ɴ� ״̬һ
                      tempkl=[tempkl kbbest1r(j2)];
                   %end
                   elseif 0<=kbbest1r(j2)&&kbbest1r(j2)<=lml  %��߷���ɴ� ״̬��
                      tempkl=[tempkl kbbest1r(j2)]; 
                   %end
                   else
                   %if lml<=kbbest1r(j2)<=phib  %��߷��򲻿ɴ�
                      tempkl=[tempkl lml]; 
                   end
               end
            %end
            %end
            %�����
            elseif  round((ds/radius)/alpha)<=km&&km<=36 
                lml=km+round((ds/radius)/alpha); %��߽�
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1r); 
                phib=km+36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j3=1:numb1
                    if km<=kbbest1r(j3)&&kbbest1r(j3)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1r(j3)]; 
                    %end
                    elseif lml<=kbbest1r(j3)&&kbbest1r(j3)<=phib  %��߷��򲻿ɴ�
                       tempkl=[tempkl lml]; 
                    %end
                    elseif km<=kbbest1r(j3)&&kbbest1r(j3)<=lmr  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1r(j3)]; 
                    else
                    tempkr=[tempkr lmr];  %�ұ߷��򲻿ɴ�
                    end
                end 
            %end
            %�����
            else
            %if  36<=km<=72-round((ds/radius)/alpha)
                lml=km+round((ds/radius)/alpha); %��߽�
                lmr=km-round((ds/radius)/alpha); %�ұ߽�
                numb1=length(kbbest1r); 
                phib=km-36; %��ǰ�˶�������
                tempkl=[];
                tempkr=[];
                for j4=1:numb1
                    if lmr<=kbbest1r(j4)&&kbbest1r(j4)<=km  %�ұ߷���ɴ�
                       tempkr=[tempkr kbbest1r(j4)]; 
                    %end
                    elseif phib<=kbbest1r(j4)&&kbbest1r(j4)<=lmr  %�ұ߷��򲻿ɴ�
                       tempkr=[tempkr lmr]; 
                    %end
                    elseif km<=kbbest1r(j4)&&kbbest1r(j4)<=lml  %��߷���ɴ�
                       tempkl=[tempkl kbbest1r(j4)]; 
                    else
                    tempkl=[tempkl lml];  %��߷��򲻿ɴ�
                    end
                end
            end
            
            geshul=length(tempkl);
            geshur=length(tempkr);
            %�ڶ���ͶӰ�㣺�ܷ�����
            if  geshul>=1&&geshur>=1  
                lc=pf1rbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                        if or1l~=73
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l));
                        else
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),inf);    
                        end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),inf,his1r(or1l)); 
                    end
                end
                ft1rl=find(how1l==min(how1l));
                pf1rlbest=filt(g1l(ft1rl),kt1r);  %�ҵ������ѷ��� 
                g1r=zeros(geshur,1);how1r=zeros(geshur,1);  %�ұ�ǰ������
                for i15=1:geshur
                    g1r(i15)=tempkr(i15);
                    order1r=g1r(i15);
                    ol1r=g1r(i15)-1;
                    or1r=g1r(i15)+1;
                    if ol1r~=0
                       if or1r~=73 
                       how1r(i15)=howmany(g1r(i15),kt1r,km,lc,his1r(order1r),his1r(ol1r),his1r(or1r));
                       else
                       how1r(i15)=howmany(g1r(i15),kt1r,km,lc,his1r(order1r),his1r(ol1r),inf);    
                       end
                    else
                       how1r(i15)=howmany(g1r(i15),kt1r,km,lc,his1r(order1r),inf,his1r(or1r)); 
                    end
                end
                ft1rr=find(how1r==min(how1r));
                pf1rrbest=filt(g1r(ft1rr),kt1r);  %�ҵ��ұ���ѷ���
                pp{1,5}=pp{1,2}+[v_car*time*cos(pf1rlbest*alpha),v_car*time*sin(pf1rlbest*alpha)];
                pp{1,6}=pp{1,2}+[v_car*time*cos(pf1rrbest*alpha),v_car*time*sin(pf1rrbest*alpha)];
                ol1l=pf1rlbest-1;
                or1l=pf1rlbest+1;
                order1l=pf1rlbest;
                if ol1l~=0
                   if or1l~=73
                   gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l),ng)+gc{1,2};
                   else
                   gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),inf,ng)+gc{1,2};    
                   end
                else
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),inf,his1r(or1l),ng)+gc{1,2}; 
                end
                ol1r=pf1rrbest-1;
                or1r=pf1rrbest+1;
                order1r=pf1rrbest;
                if ol1r~=0
                   if or1r~=73
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1r),his1r(ol1r),his1r(or1r),ng)+gc{1,2};
                   else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1r),his1r(ol1r),inf,ng)+gc{1,2};    
                   end
                else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1r),inf,his1r(or1r),ng)+gc{1,2}; 
                end
                kt1rl=round(caculatebeta(pp{1,5},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                kt1rr=round(caculatebeta(pp{1,6},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,5}=heu(kt1rl,pf1rlbest,pf1rlbest,ng);
                hc{1,6}=heu(kt1rr,pf1rrbest,pf1rrbest,ng);
                fc{1,5}=gc{1,5}+hc{1,5};
                fc{1,6}=gc{1,6}+hc{1,6};
                pfcun(1,3)=pf1rlbest;
                pfcun(1,4)=pf1rrbest;
            %end
            %�ڶ���ͶӰ�㣺���ܷ����� ֻ��һ������
            elseif  geshul>=1&&geshur==0  %�÷�������
                lc=pf1rbest;
                g1l=zeros(geshul,1);how1l=zeros(geshul,1);  %���ǰ������ 
                tempkl
                for i14=1:geshul
                    g1l(i14)=tempkl(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                        if or1l~=73 
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l));
                        else
                        how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),inf);    
                        end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),inf,his1r(or1l)); 
                    end
                end
                ft1rl=find(how1l==min(how1l));
                pf1rlbest=filt(g1l(ft1rl),kt1r);  %�ҵ������ѷ���
                pp{1,5}=pp{1,2}+[v_car*time*cos(pf1rlbest*alpha),v_car*time*sin(pf1rlbest*alpha)];
                ol1l=pf1rlbest-1;
                or1l=pf1rlbest+1;
                order1l=pf1rlbest;
                if ol1l~=0
                    if or1l~=73 
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l),ng)+gc{1,2};
                    else
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),inf,ng)+gc{1,2};
                    end
                else
                    gc{1,5}=howmanys(pf1rlbest,kt1r,km,lc,his1r(order1l),inf,his1r(or1l),ng)+gc{1,2};
                end
                kt1rl=round(caculatebeta(pp{1,5},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,5}=heu(kt1rl,pf1rlbest,pf1rlbest,ng);
                fc{1,5}=gc{1,5}+hc{1,5};
                fc{1,6}=inf;
                pfcun(1,3)=pf1rlbest;
            %end
            elseif  geshur>=1&&geshul==0  %�÷�������
                lc=pf1rbest;
                g1l=zeros(geshur,1);how1l=zeros(geshur,1);  %�ұ�ǰ������ 
                for i14=1:geshur
                    g1l(i14)=tempkr(i14);
                    order1l=g1l(i14);
                    ol1l=g1l(i14)-1;
                    or1l=g1l(i14)+1;
                    if ol1l~=0
                       if or1l~=73 
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l));
                       else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),his1r(ol1l),inf);
                       end
                    else
                       how1l(i14)=howmany(g1l(i14),kt1r,km,lc,his1r(order1l),inf,his1r(or1l)); 
                    end
                end
                ft1rr=find(how1l==min(how1l));
                pf1rrbest=filt(g1l(ft1rr),kt1r);  %�ҵ��ұ���ѷ���
                pp{1,6}=pp{1,2}+[v_car*time*cos(pf1rrbest*alpha),v_car*time*sin(pf1rrbest*alpha)];
                ol1l=pf1rrbest-1;
                or1l=pf1rrbest+1;
                order1l=pf1rrbest;
                if ol1l~=0
                   if or1l~=73  
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),his1r(or1l),ng)+gc{1,2};
                   else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1l),his1r(ol1l),inf,ng)+gc{1,2};
                   end
                else
                   gc{1,6}=howmanys(pf1rrbest,kt1r,km,lc,his1r(order1l),inf,his1r(or1l),ng)+gc{1,2}; 
                end
                kt1rr=round(caculatebeta(pp{1,6},endpoint)/alpha);  %�½ڵ��Ŀ�귽�� ��
                hc{1,6}=heu(kt1rr,pf1rrbest,pf1rrbest,ng);
                fc{1,6}=gc{1,6}+hc{1,6};
                fc{1,5}=inf;
                pfcun(1,4)=pf1rrbest;
            else
            %�ڶ���ͶӰ�㣺���ܷ����� �޷���
            %if  geshul==geshur==0
                fc{1,5}=inf;
                fc{1,6}=inf;
            end
            pd=[fc{1,3},fc{1,4},fc{1,5},fc{1,6}]  %�ж�ֵ
            ft=find(pd==min(pd)) %�ҳ������ڵ�fcֵ��С��
            dcyb=pfcun(1,ft);
            %lc=dc;
            
            if  length(ft)==1
                lc=dcyb;
                dc=dcyb;
                robot=pp{1,ft+2};  %VFH*�㷨�õ�������λ�ò����������
            elseif  length(ft)==2 %ע�� ft �� dcyb ��ʱ��2��1�еľ���2��1��
                geshu=length(dcyb);
                if dcyb(1)==dcyb(geshu)
                   dc=dcyb(1); 
                   lc=dc;
                   robot=pp{1,ft(1)+2};
                else
                   kt_1=round(caculatebeta(pp{1,ft(1)+2},endpoint)/alpha);
                   kt_2=round(caculatebeta(pp{1,ft(2)+2},endpoint)/alpha);
                   g_=zeros(geshu,1);how_=zeros(geshu,1);xushu=zeros(geshu,1);
                   kt_=[kt_1 kt_2];
                   for i14=1:geshu
                       g_(i14)=dcyb(i14);
                       how_(i14)=howmanyss(g_(i14),kt_(i14));
                       xushu(i14)=ft(i14);
                   end
                   if how_(1)~=how_(2)
                       ft_=find(how_==min(how_));
                       dc=g_(ft_);
                       lc=dc;
                       robot=pp{1,xushu(ft_)};
                   else
                       g__=zeros(geshu,1);how__=zeros(geshu,1);xushu_=zeros(geshu,1);
                       for i14=1:geshu
                           g__(i14)=dcyb(i14);
                           how__(i14)=dif(g__(i14),kt_(i14));
                           xushu_(i14)=ft(i14);
                       end
                       ft__=find(how__==min(how__));
                       dc=g__(ft__);
                       lc=dc;
                       robot=pp{1,xushu(ft__)};
                   end
                 end
            end

            %��ǰ�˶�����
            %�ϴ�ѡ����
        else   %���������VFH*�㷨 �Ǿ�ʹ��VFH+�㷨�ж�
            if  norm(robot-ref)==0
                lc=kt;
            else
                lc=lc;
            end
            
            i1=1; %����Ӧ��ֵ��ѭ������
            kb=[];%������ѷ��򼯺�
            howth=[];%������ֵ�����ֵ�·���Ĵ��ۼ���
            
            % ����Ӧ��ֵ��ʼ��
            
            while (i1<=blcs)
                Dt=norm(robot-endpoint);
                Dth(i1)=Dthmax-i1*dirtD;
                c=[];
                if  Dth(i1)<Dt
                    threshold(i1)=C^2*Iij(Dth(i1));
                    j=1;q=1;

                    while (q<=n)       
                        %%%%%%%%%%%%%%%%%%%%%           ���к��ʵķ���ȫ���ҳ���
                        if(his(q)< threshold(i1))
                            kr=q;                        % �ҵ��˲��ȵ����
                            while(q<=n && his(q)< threshold(i1))   %��һС���ҵ��˲��ȵ��Ҷ�
                                kl=q;
                                q=q+1;
                            end

                            if(kl-kr > smax)                  % ����
                                c   =  [c round(kl - smax/2)];  % �������
                                c   =  [c round(kr + smax/2)];  % �����Ҳ�
                                j=j+2;
                                if(kt >= kr && kt <= kl)
                                    c  = [c kt];                % straight at look ahead
                                    j=j+1;
                                end
                            elseif(kl-kr > smax/5)           % խ����
                                c   =  [c round((kr+kl)/2-2.5)];
                                j=j+1;
                            end

                        else
                            q=q+1;                            % his(q)��Ϊ0��ֱ����һ��

                        end                                   % �˳�ifѡ���ٴν���while����ѭ��
                    end                                       % �˳�whileѭ��

                    % %%%% ������ֵ�Ŀ�խ�������б�ѡ�ķ��򶼴浽 c ������
                    % ��ʼɸѡ���ŷ���
                    if norm(robot-ref)==0                            
                       g=zeros(j-1,1);how=zeros(j-1,1);
                       for i2=1:j-1
                           g(i2)=c(i2);     %g�в���Ŀ������
                           order=g(i2);
                           ol=g(i2)-1;
                           or=g(i2)+1;
                           dc=kt;           %���ڻ����˻�û��������Ŀ�귽����ǵ�ǰ�˶�����
                           lc=kt;           %���ڻ����˻�û��������Ŀ�귽������ϴ�ѡ����
                           if ol~=0   %��ֹ���ֵ�0���73
                              if or~=73
                               how(i2)=howmany(g(i2),kt,dc,lc,his(order),his(ol),his(or)); %���ۺ����������ŷ��� howΪ���� Ԫ�ظ����� g ����ͬ��
                              else
                               how(i2)=howmany(g(i2),kt,dc,lc,his(order),his(ol),inf);   
                              end
                           else
                              how(i2)=howmany(g(i2),kt,dc,lc,his(order),inf,his(or)); 
                           end 
                       end                                                             
                       ft=find(how==min(how));
                       fk=g(ft);
                       kb=[kb fk];  % ��ǰ��ֵ�µ���ѱ�ѡ����
                    else
                       g=zeros(j-1,1);how=zeros(j-1,1);
                       for i3=1:j-1
                           g(i3)=c(i3);
                           order=g(i3);
                           ol=g(i3)-1;
                           or=g(i3)+1;
                           if ol~=0   %��ֹ���ֵ�0���73
                              if or~=73
                               how(i3)=howmany(g(i3),kt,dc,lc,his(order),his(ol),his(or));
                              else
                               how(i3)=howmany(g(i3),kt,dc,lc,his(order),his(ol),inf);   
                              end
                           else
                              how(i3)=howmany(g(i3),kt,dc,lc,his(order),inf,his(or)); 
                           end
                       end
                       ft=find(how==min(how));
                       fk=g(ft);
                       %һ����ֵ��Ҳ�����ֶ����ѷ��� ��ɸѡ��
                       cd=length(fk); %���ŷ���ĸ���
                       if cd==1
                          fk=fk;  % ��ǰ��ֵ�µ���ѱ�ѡ���� 
                       else 
                          g_=zeros(cd,1);how_=zeros(cd,1); 
                          for i4=1:cd
                              g_(i4)=fk(i4);
                              how_(i4)=dif(g_(i4),kt);
                          end
                          ft_=find(how_==min(how_));
                          fk=g_(ft_);  % ��ǰ��ֵ�µ���ѱ�ѡ����
                       end
                       kb=[kb fk];  % ��ǰ��ֵ�µ���ѱ�ѡ����
                    end 
                    
                    temp1=howmuch(Dth(i1),fk,kt,Dthmax); %���� ��ֵ�����ֵ����ѷ�����ۺϴ���
                    howth=[howth temp1]; %�洢�ۺϴ���
                end
                i1=i1+1;
            end
            ft=find(howth==min(howth));
            fbestyb=kb(ft);  %VFH+�㷨�õ�����÷���
            % ��ֹ�ж�����ŷ���
            if  length(ft)==1
                dc=fbestyb;       % ��ǰ���˶�����
                lc=dc;       % ��һ��ѡ��ķ���
                robot=robot+[v_car*time*cos(fbestyb*alpha),v_car*time*sin(fbestyb*alpha)];  %VFH+�㷨�õ�������λ�ò����������
            elseif  length(ft)==2 %ע�� ft �� dcyb ��ʱ��2��1�еľ���2��1��
                geshu=length(fbestyb);
                if fbestyb(1,1)==fbestyb(geshu,1)
                   dc=fbestyb(1,1);  % ��ǰ���˶�����
                   lc=dc; % ��һ��ѡ��ķ���
                   robot=robot+[v_car*time*cos(lc*alpha),v_car*time*sin(lc*alpha)];
                else
                   
                   g_=zeros(geshu,1);how_=zeros(geshu,1);  
                   for i14=1:geshu
                        g_(i14)=fbestyb(i14);
                        how_(i14)=howmanyss(g_(i14),kt);
                   end
                   ft_=find(how_==min(how_));
                   dc=g_(ft_); % ��ǰ���˶�����
                   lc=dc; % ��һ��ѡ��ķ���
                   robot=robot+[v_car*time*cos(lc*alpha),v_car*time*sin(lc*alpha)];
                end    
            elseif  length(ft)==3
                geshu=length(fbestyb);
                g_=zeros(geshu,1);how_=zeros(geshu,1);  
                   for i14=1:geshu
                        g_(i14)=fbestyb(i14);
                        how_(i14)=howmanyss(g_(i14),kt);
                   end
                   ft_=find(how_==min(how_));
                   dc=g_(ft_); % ��ǰ���˶�����
                   lc=dc; % ��һ��ѡ��ķ���
                   robot=robot+[v_car*time*cos(lc*alpha),v_car*time*sin(lc*alpha)];
            %else 
            end
        end
        ref=startpoint;
        scatter(robot(1),robot(2),'.r');
        drawnow;
        kt=round(caculatebeta(robot,endpoint)/alpha);  %�µ�Ŀ�귽��
        if(kt==0)
            kt=n;
        end
        if(norm(robot-endpoint))>step          % ������λ�ú��յ�λ�ò�����0.1ʱ
        else
            break
        end
        %���˱��Ϲ滮һ�����
        
        obstacle([5271:8870],:)=[];    %������Ϻ��޳���̬�ϰ���
        obstacle;
    end
end
 