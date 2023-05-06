function [situazione] = pausiliario(A,b,simb)
%mi dice se il problema è vuoto
%situazione=1 problema non vuoto, situazione=0 problema vuoto

%ELIMINO TUTTI I VINCOLI NON "="
i=1;
j=1;
dim=length(b);
while (i<=dim)
    if(simb(j)~=0)    
        A(j,:)=[];
        b(j)=[];
    end
    i=i+1;
    if(simb(j)==0)
        j=j+1;
    end
end

n=size(A,1);%numero equazioni
m=size(A,2);%numero vincoli

for i=1:n           %vettore c>=0
    if(b(i)<0)
        b(i)=b(i)*-1;
        A(i,:)=A(i,:)*-1;
    end
end


epsi=ones(1,n);%epsilon
vepsi=zeros(1,m+n);%c
vepsi(1,m+1:m+n)=epsi; % la nuova c -> 0 0 0 0 ... 1 1 1 1 (y | e)

nuovaA=zeros(n,m+n);
nuovaA(1:n,1:m)=A;
nuovaA(1:n,m+1:m+n)=eye(n);%matrice modificata

LB=zeros(m+n,1);
UB=[];

Am=[];
bm=[];

[~,v]=linprog(vepsi,Am,bm,nuovaA,b,LB,UB);
%=linprog(vepsi,Am,bm,nuovaA,b,LB,UB);

if(v>0)
    situazione=0;
end

if(v<0)
    situazione=2;
end

if(v==0)
    situazione=1;
end


end