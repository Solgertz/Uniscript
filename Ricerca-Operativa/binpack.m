function [vi,vs,xi] = binpack(oggetti,P,tipo)

%vi
vi=(sum(oggetti))/P;
if(vi-fix(vi)~=0)
    vi=fix((sum(oggetti))/P)+1;
end
l=length(oggetti);
c=zeros(1,(vi*l)+vi);
c(1,(vi*l)+1:(vi*l)+vi)=ones(1,vi);

A=zeros(vi,(vi*l)+vi);
conty=eye(vi);
k=0;
for i=1:vi
    A(i,(l*k)+1:l*(k+1))=oggetti;
    k=k+1;
end
A(:,(vi*l)+1:(vi*l)+vi)=-conty;

b=zeros(vi,1);
beq=ones(l,1);

Aeq=zeros(l,(vi*l)+vi);

k=1;
for i=1:l
    for j=0:vi-1
        m=k+j*l;
        Aeq(i,m)=1;
    end
    k=k+1;
end

LB=zeros((l*vi)+vi,1);
UB=[];

I=(1:(l*vi)+vi);

[xi,in]=intlinprog(c,I,A,b,Aeq,beq,LB,UB);

%{
%vs
if(tipo=='n')%NFD ->next

    [valogg,og]=sort(oggetti,'descend');
    k=1;
    
    lon=length(og);
    while lon==0
        dire="c"+string(k)+"  ";
        Paux=P;
 
        if(Paux-valogg(i)>0)
            Paux=Paux-valogg(i);
            dire=dire+"og"+string(og(i))+",";
            lon=lon-1;
            i=i+1;
        else
            k=k+1;
        end
  
    end
end

if(tipo=='f')%FFD -> first
end

if(tipo=='b')%BFD -> best

end

%}


end