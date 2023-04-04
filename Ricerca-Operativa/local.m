function [xi,xs,vi,vs] = local(T,c,val,P,tipo,copert)
%se tipo è b allora la matrice è già composta da 1
%indica se il problema è di massima o minima copertura -> i(mIn), a(mAx)

A=T;

if(tipo~='b')
    for i=1:size(T,1)
        for j=1:size(T,2)
            if(T(i,j)<=val)
                A(i,j)=-1;
            else
                A(i,j)=0;
            end
        end
    end
end
A=-A;
disp('La matrice di 1')
disp(-A);


if(copert=='i')
    b=-ones(size(A,1),1);
    
    
    Aeq=[];
    beq=[];
    LB=zeros(size(A,2),1);
    UB=[];
    
    [xi,vi]=linprog(c,A,b,Aeq,beq,LB,UB);
    
    %vs con arrotondamento
    xs=zeros(1,length(xi));
    for i=1:length(xi)
        if(xi(i)-fix(xi(i))~=0)
            xs(i)=fix(xi)+1;%arrotondo per eccesso
        else
            xs(i)=xi(i);
        end
    end
    xs=xs';
    
    vs=c*xs;
    
    %chvatal -> seleziono i servizi in ordine crescente e applico la regola di
    %riduzione (quella che elimina le righe con 1 nella colonna selezionata)
    %finchè tutti i quartieri sono coperti
else
    chvatal=-A;
    h=c;
    %aggiorno c (il vettore popolazione)
    m=size(A,1);
    n=size(A,2);
    p=length(c);
    quntvar=n+p;
    aux=zeros(1,quntvar);
    aux(1,n+1:quntvar)=c;
    c=aux;

    zed=eye(p);
    T=zeros(2*m,quntvar);
    T(1:m,1:n)=A;
    T(m+1:2*m,1:n)=A;
    T(m+1:2*m,n+1:quntvar)=zed;
    A=T;

    b=zeros(2*m,1);
    b(1:m,1)=-ones(m,1);

    c=-c;%perchè problema di massimo

    LB=zeros(quntvar,1);
    UB=[];
    Aeq=zeros(1,quntvar);
    Aeq(1,1:n)=ones(1,n);
    beq=P;

    [xs,vs]=linprog(c,A,b,Aeq,beq,LB,UB);

    vs=-vs;


    vi=0;
    nocap=zeros(1,n);
    for i=1:n
        for j=1:m
            if(chvatal(j,i)==1)
                nocap(i)=nocap(i)+h(j);
            end
        end
        if(vi<nocap(i))
            vi=nocap(i);
            xi=i;
        end
    end

    %seleziono il servizio con più popolazione (1 sola iterazione chvatal, P=1)
    %per altre iterazioni, eliminare colonna e usare la regola di riduzione
    %(selezione), sommare quindi gli h per i servizi rimasti

    disp('La popolazione coperta da ogni servizio (in ordine dal primo) -> chvatal P=1');
    disp(nocap);


end



end