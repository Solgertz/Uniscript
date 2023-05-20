function [c,nA,nb,Aeq,beq,LB,UB,Augu,bugu,simbugu] = sostitutore(c,A,b,simb,tipo)
%Dati gli input di un problema, sostituisce tutto correttamente dentro il
%linprog
% -valuta e decide se cambiare segno alla funzione obiettivo
% -determina UB e LB sostituendo le righe di A con vincoli semplici
% -interpreta simb per assegnare ad Aeq o A
% - riporta tutto nella forma Ax<=b


if(tipo=='p')
    c=-c;       %trasformo in Minimo
end
Aeq=[];
beq=[];
LB=zeros(length(c),1);%nei minimi LB>=0 almeno
UB=inf(length(c),1);
m=size(A,1);n=size(A,2);j=1;k=1;t=1;
for i=1:m
    [sit,burp]=unsolovalore(A(i,:));
    if((sit==1 && simb(i)==0) || sit==0) %VINCOLI
        if(simb(i)==0)    %=
            Augu(t,:)=A(i,:);
            bugu(t)=b(i);
            Aeq(j,:)=A(i,:);
            beq(j)=b(i);
            j=j+1;
            t=t+1;
        else
            if(simb(i)==1)%>= diventano <=
                Augu(t,:)=-A(i,:);
                bugu(t)=-b(i);
                simbugu(t)=-1; 
                nA(k,:)=-A(k,:);
                nb(k)=-b(k);
            else
                Augu(t,:)=A(i,:);
                bugu(t)=b(i);
                simbugu(t)=1;
                nA(k,:)=A(k,:);
                nb(k)=b(k);
            end
            t=t+1;
            k=k+1;
        end
    else        %BOUND
        if(A(i,burp)<0)
            A(i,burp)=-A(i,burp);
            b(i)=-b(i);
            simb(i)=-simb(i);
        end
        if(simb(i)==1) %LB di x_i>=2
            LB(burp,1)=b(i)/A(i,burp);
            Augu(t,:)=-A(i,:);
            bugu(t)=-b(i);
            simbugu(t)=-1; 
            t=t+1;
        else            %UB di x_i<=5
            UB(burp,1)=b(i)/A(i,burp);
            Augu(t,:)=A(i,:);
            bugu(t)=b(i);
            simbugu(t)=1; 
            t=t+1;
        end
    end
end
nb=nb';
bugu=bugu';

end