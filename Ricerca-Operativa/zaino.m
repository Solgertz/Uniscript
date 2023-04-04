function [xs,vs,xi,vi] = zaino(valore,peso,P,tipo)
format rat;

%FUNZIONI USATE: linprog()
%INPUT:
%       -valore: vettore dei valori
%       -peso:   vettore dei pesi
%       -P :  peso massimo
%       -tipo:  zaino intero(i), zaino binario(b)

%è un problema di massimo (da trasformare in minimo)

if(tipo=='i')%zaino intero
    %calcolo vs -> rilassato continuo o divisibile (intero)
    if(length(valore)~=length(peso))
        disp('errore nella scrittura di valore e peso(non hanno stessa lunghezza)');
        return;
    end
    
    A=peso;
    b=P;
    Aeq=[];
    beq=[];
    c=-valore;%perchè problema di massimo
    lpe=length(peso);
    LB=zeros(lpe,1);
    UB=[];
    [xs,vs]=linprog(c,A,b,Aeq,beq,LB,UB);
    vs=-vs;%perchè problema di massimo
    
    %calcolo vi -> greedy rendimenti indivisibili
    
    rendimenti=valore./peso;
    
    [rend,posrend]=sort(rendimenti,'descend');

    k=1;
    for i=1:lpe
        if(k==1 && peso(posrend(i))<=P)%prende il primo numero inferiore al peso, che può starci più volte
            sol=P/(peso(posrend(i)));
            sol=fix(sol);
            idiv=posrend(i);
            k=k+1;
        end
    end

    xi=zeros(1,lpe);
    xi(idiv)=sol;

    vi=(-c)*(xi');

else %caso intero
    %vs -> divisibile binaria (1/3)
    A=peso;
    b=P;
    c=-valore;%perchè problema di massimo
    lpe=length(peso);
    rendimenti=valore./peso;
    
    [rend,posrend]=sort(rendimenti,'descend');

    Paxu=P;
    xaxxu=P;
    xs=zeros(1,lpe);
    xi=xs;
    k=1;
    j=1;
    sol=zeros(1,lpe);
    for i=1:lpe
        %sulla vs
        if(peso(posrend(i))<=Paxu)%prende il primo numero inferiore al peso, che può starci più volte
            Paxu=Paxu-peso(posrend(i));
            xs(posrend(i))=1;
            k=k+1;
        else
            if(Paxu~=0)
                sol(k)=Paxu/peso(posrend(i));
                idiv(k)=posrend(i);
                xs(idiv(k))=sol(k);
                k=k+1;
                Paxu=0;
            end 
        end
        %sulla vi
        if(peso(posrend(i))<=xaxxu)
            xaxxu=xaxxu-peso(posrend(i));
            xi(posrend(i))=1;
            j=j+1;
        end
    end

    vs=(-c)*(xs');
    
    %vi -> indivisibile binaria (1 o 0)
    vi=(-c)*(xi');
    if(xaxxu==0)
        disp('Non è avanzato niente nello zaino');
    else
        fprintf('Sono avanzati %d nella Vi binaria',xaxxu);
    end

end
end