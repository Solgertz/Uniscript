function [A] = matrixadder(A,v,ti)

%aggiunge la colonna o riga v come ultima (o una sottomatrice)
% -ti: 1(riga) e 2(colonna)

m=size(A,1);
n=size(A,2);

if(ti==1)
    q=size(v,1);
    m=m+q;
else
    q=size(v,2);
    n=n+q;
end
aux=zeros(m,n);

if(ti==1)
    aux(1:m-q,1:n)=A(1:m-q,1:n);
    aux(m-q+1:m,:)=v;
else
    aux(1:m,1:n-q)=A(1:m,1:n-q);
    aux(:,n-q+1:n)=v;
end

A=aux;

end