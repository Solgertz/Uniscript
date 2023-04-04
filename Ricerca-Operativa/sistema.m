function [tipo,fo,A,simb,b] = sistema(tipo,fo,a1,a2,a3,b1,b2,b3,ottenimento)
%Partendo dai vincoli, rilascia in formato primale, duale o inverte forma
clc
%tipo può essere max o min oppure 1 o 2
%fo sono i soli coefficienti
%A è la matrice dei vincoli
%b è il vettore dei termini noti
%a1 è la sottomatrice con i vincoli <=, a2 con =, a3 con >= (stessa cosa per b)


%ottenimento indica quale risultato avere:
% 1 o s standardizza il sistema, 2 o i converte nell'altra forma, 3 o null
% trascrive semplicemente, 4 o p richiama il primale, 5 o d richiama il
% duale



%gestisco il caso in cui mi scordi i numeri corrispondenti alle modalità
switch(tipo)
    case 'max'
        tipo=1;
    case 'min'
        tipo=2;
    case 'maxi'
        tipo=3;
    case 'mini'
        tipo=4;
    otherwise

end

switch(ottenimento)
    case 's'
        ottenimento=1;
    case 'i'
        ottenimento=2;
    case 'null'
        ottenimento=3;
    case 'p'
        ottenimento=4;
    case 'd'
        ottenimento=5;
    otherwise
end


%preallocazione simboli
s1=a1(:,1);
s7=a1(:,1);
s2=a2(:,1);
s3=a3(:,1);
s4=a2(:,1);
s6=a3(:,1);
%calcolo i simboli
for i=1:size(a1,1)
    s1(i,1)='<';
    s7(i,1)='>';
end

for i=1:size(a2,1)
    s2(1,i)='=';
    s4(1,i)='<';
end

for i=1:size(a3,1)
    s3(1,i)='>';
    s6(1,i)='<';
end

%standardizza
if(ottenimento<=2) %standardizza o inverti
    if(ottenimento==1)%standardizza
        if(tipo==1)%max standard
             A=[a1;a2;-a2;-a3];
             b=[b1;b2;-b2;-b3];
             simb=[s1;s4;s4;s6];
        else %min
             A=[-a1;a2;a3];
             b=[-b1;b2;b3];
             simb=[s7;s2;s3];
        end
    end
    if(ottenimento==2)%inverti
        fo=-fo;
        if(tipo==2 || tipo==4)% voglio un max standard
             A=[a1;a2;-a2;-a3];
             b=[b1;b2;-b2;-b3];
             simb=[s1;s4;s4;s6];
             if(tipo==4)
                 tipo=1;%inverto a max
             else 
                 tipo=3;%inverto a max_i perchè fo deve avere (-1)
             end
        else % voglio ottenere min
             A=[-a1;a2;a3];
             b=[-b1;b2;b3];
             simb=[s7;s2;s3];
             if(tipo==3)
                 tipo=2;
             else
                 tipo=4;%inverto a min_i
             end
        end
    end
end

%caso null
if (ottenimento==3)
    A=[a1;a2;a3];
    simb=[s1;s2;s3];
    b=[b1;b2;b3];
end

%caso duale
if(ottenimento==5 && a2==0 && a3==0 && b2==0 && b3==0)
    %b
    b=fo';
    %calcolo A
    A=a1';
    simb=A(:,1);
    for i=1:size(simb,1)
        simb(i,1)='=';
    end
    fo=b';
end

mostrasistema(tipo,fo,A,simb,b);
end