function [xs,vs,xi,vi,dire] = zaino(valore,peso,P,tipo)

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


         %Conversione vincoli
    Augu=A;
    for i=1:size(Augu,1)
         %CONVERSIONE IN = dei vincoli
         %aggiungo var di resto
         zam=zeros(size(Augu,1),1);
         zam(i,1)=1;
         [Augu]=matrixadder(Augu,zam,2);
    end

    %max,Augu,x>=
    LB=zeros(size(Augu,2),1);
    UB=inf(size(Augu,2),1);
    cugu=c;
    cugu((size(A,2)+1):(size(Augu,2)))=0; %var di scarto (essendo di minimo si usano variabili di slack)
    [izi,bizi]=linprog(cugu,[],[],Augu,b,LB,UB);

    [base,N]=ricavBase(Augu,b,izi,'d');

    [Alfa,beta,essi] = gomory(Augu,N,base,izi,b);

    dire=dire+" "+essi;
    
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
    
    %cerco la prima componente frazionaria
    for  i=1:length(xs)
        if(~(xs(i)==0 || xs(i)==1))
            primato=i;
            break;
        end
    end


    [valutfinal] = BeBzaino(-c,A,b,[-1],'p',vs,xs,vi,xi,1,primato);
   
    %simb=-ones(size(A,1),1);
end



dire=dire+"\section{Valutazioni} $"+matrivetlate(xi,"x_i",0)+"\qquad "+matrivetlate(vi,"v_i",0)+" $\\$ "+matrivetlate(xs',"x_s",0)+"\qquad "+matrivetlate(vs,"v_s",0)+" $";
%stampalatex(dire);
end