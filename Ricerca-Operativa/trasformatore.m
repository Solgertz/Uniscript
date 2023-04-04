function [A,b,c] = trasformatore(A,b,c,partenza,arrivo)

%primale standard->dualizzato (p,u)
if(partenza=='p' && arrivo=='u')
    numvar=length(c);
    aux=b;
    b=c';
    c=aux';
    [m,n]=size(A);
    aux=zeros(1,numvar+m);
    aux(1,1:numvar)=c;
    c=aux;
    
    aux=zeros(m+numvar,n);
    aux(1:m,:)=A;
    aux(m+1:m+numvar,:)=-eye(numvar);%le variabili sono sempre >0 -> devo cambiare comparazione
    A=aux';
end


%duale standard -> dualizzato (d,u)
if(partenza=='d'&& arrivo=='u')
    %non lo abbiamo fatto-> si fa stessa cosa modificando bene c

    %Ammettendo che la matrice identica sia sull'ultima parte
    [m,n]=size(A);
    %aux=zeros(1,n);
    %aux(1,1:m)=c;
    aux=c;
    c=b';
    b=aux';
    A=A';

end


%pimale standard -> duale standard (p,d)
if(partenza=='p' && arrivo=='d')
    disp('Attenzione, vo diventa -vo');
    c=-c;
    [m,n]=size(A);
    aux=zeros(1,m+n);
    aux(1,1:m)=c;
    c=aux;
    aux=zeros(m,n+m);
    aux(:,1:n)=A;
    aux(:,n+1:n+m)=eye(m);
    A=aux;
end


%duale standard -> primale standard (p,d)
if(partenza=='d' && arrivo=='p')
    disp('Attenzione, vo diventa -vo');
    c=-c;
    [m,n]=size(A);

    aux=zeros(2*m,n);
    aux(1:m,:)=A;
    aux(m+1:2*m,:)=-A;
    A=aux;
    aux=zeros(2*m,1);
    aux(1:m,1)=b;
    aux(m+1:2*m,1)=-b;
    b=aux;

end


end