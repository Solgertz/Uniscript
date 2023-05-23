function [xs,vs,xi,vi] = zaino(valore,peso,P,tipo)

%FUNZIONI USATE: linprog(),stampalatex()
%INPUT:
%       -valore: vettore dei valori
%       -peso:   vettore dei pesi
%       -P :  peso massimo
%       -tipo:  zaino intero(i), zaino binario(b)

%è un problema di massimo (da trasformare in minimo)

%ORDINAMENTO
rendimenti=valore./peso;
[~,posrend]=sort(rendimenti,'descend');
ordinati=rendimenti(posrend);

dire=" \section{Calcoli} $"+matrivetlate(valore,"\text{valore}",0)+"$\\$"+matrivetlate(peso,"\text{pesi}",0)+"\qquad P_{\text{max}}="+P+" $"+matrivetlate(rendimenti,"\text{rendimenti}",1)+matrivetlate(ordinati,"\text{ordinamento}",1);

if(tipo=='i')%zaino intero
    %calcolo vs -> rilassato continuo o divisibile (intero)
    if(length(valore)~=length(peso))
        disp('errore nella scrittura di valore e peso(non hanno stessa lunghezza)');
        return;
    end
    
    %Vs -> rilassato continuo
    A=peso;
    b=P;
    Aeq=[];
    beq=[];
    c=-valore;%perchè problema di massimo
    lpe=length(peso);
    LB=zeros(lpe,1);
    UB=[];
    [xs,vs]=linprog(c,A,b,Aeq,beq,LB,UB);
    vs=approssima(-vs,0);%approssimo per difetto
    
    

    %Vi -> greedy rendimenti indivisibili
  
    pesantibus=0;
    xi=zeros(1,lpe);
    for i=1:lpe
        if(pesantibus+peso(posrend(i))<=P)%prende il primo numero inferiore al peso massimo
            sol=P/(peso(posrend(i))); %valore divisibile
            sol=approssima(sol,0); %approssimo per difetto (valore indivisibile)
            xi(posrend(i))=sol;
            pesantibus=pesantibus+(sol*peso(posrend(i)));
        end
    end
    vi=(-c)*(xi');
    vi=approssima(vi,0);
    
else %caso binario

    %vs -> divisibile binaria (1/3)
    
    A=peso;
    b=P;
    Aeq=[];
    beq=[];
    c=-valore;%perchè problema di massimo
    lpe=length(peso);
    LB=zeros(lpe,1);
    UB=ones(lpe,1);
    [xs,vs]=linprog(c,A,b,Aeq,beq,LB,UB);
    vs=approssima(-vs,0);%perchè problema di massimo

    %vi -> indivisibile binaria (1 o 0)
    
    pesantibus=0;
    xi=zeros(1,lpe);
    for i=1:lpe
        if(pesantibus+peso(posrend(i))<=P)%prende il primo numero inferiore al peso massimo
            xi(posrend(i))=1;
            pesantibus=pesantibus+peso(posrend(i));
        end
    end
    vi=(-c)*(xi');
    vi=approssima(vi,0);
    
    simb=-ones(size(A,1),1);
end

dire=dire+"\section{Valutazioni} $"+matrivetlate(xi,"x_i",0)+"\qquad "+matrivetlate(vi,"v_i",0)+" $\\$ "+matrivetlate(xs',"x_s",0)+"\qquad "+matrivetlate(vs,"v_s",0)+" $";

stampalatex(dire);
end