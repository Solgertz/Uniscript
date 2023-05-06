function [Gadia,situazione,vi] = toppe(G,A,arco1,arco2,vi)
%applica l'algoritmo delle toppe su un grafo e ricava il ciclo Hemiltoniano
%corrispondente

%OUTPUT:  matrice di adiacenza del nuovo grafo

%INPUT:
%-G:        grafo
%-A:        matrice dei costi completa
%-arco1 e arco2:   vettori degli archi da unire (partenza,arrivo)
%-Vi:       precedente valutazione inferiore

%FUNZIONI USATE: maggiore(), unisci()

%Situazione
%   -0:  grafo aciclico, inutile continuare
%   -1:  il grafo non contiene due cicli distinti con arco1 e arco2
%   -2:  Ciclo hemiltoniano
%   -3:  C'è ancora da unire

if(A(arco1(1),arco1(2))==0 ||A(arco2(1),arco2(2))==0) %caso in cui ho sbagliato la direzione di un arco
    situazione=1;
    return;
end

cicli = allcycles(G);%tutti i cicli disgiunti
p=length(cicli);  %numero cicli
Gadia = full(adjacency(G)); %matrice dei costi del grafo
Gadia=A.*Gadia;

if(p<2)
    situazione=0;
    return;
end

%ricerca dei due cicli da unire
Ch=[];
Ck=[];
for i=1:p
    Chi=cell2mat(cicli(i));
    Cki=cell2mat(cicli(i));
    if(~isempty(Chi(Chi==arco1(1)))  && ~isempty(Chi(Chi==arco1(2))))
        Ch=Chi;
    end
    if(~isempty(Cki(Cki==arco2(1)))  && ~isempty(Cki(Cki==arco2(2))))
        Ck=Cki;
    end
end

if(isequal(Ch,Ck) || (isempty(Ch) || isempty(Ck))) %archi non presenti
    situazione=1;
    return;
end



i=arco1(1);j=arco1(2);
k=arco2(1);l=arco2(2);

%aggiorno valutazione
vi=vi-A(i,j)-A(k,l)+A(i,l)+A(k,j);
Gadia(i,j)=0;Gadia(i,l)=A(i,l);
Gadia(k,l)=0;Gadia(k,j)=A(k,j);

p=p-1;
if(p==1)
    situazione=2;
else
    situazione=3;
end


end
