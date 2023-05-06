function [B,N] = ricavBase(A,b,x,tipo)
%Ricavatore di base

%caso primale
if(tipo=='p')
    s=A*x==b;
    B=find(s);
    s=~s;
    N=find(s);
    Ab=A(B);
    n=size(A,2);
end
%caso duale
if(tipo=='d')
    B=(x~=0);%vettore logico dei vincoli di base
    N=~B;
    B=(find(B));%base effettiva
    N=(find(N));
    Ab=A(:,B);
    n=size(A,1);
end
degenere=false;
if(rank(Ab)~=n)
    degenere=true;
end
%conversione in vettori colonna
if(size(B,2)>1)
    B=B';
end
if(size(N,2)>1)
    N=N';
end


end