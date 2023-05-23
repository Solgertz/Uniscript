function [xw,pimu] = capacitata(archi_c_u,b)

%funzioni usate: VetLin2mat()

%INPUT:
%- archi_c_u è una matrice (non per forza in ordine lessicografico) del
%           formato : [1,2,4,10,T;1,3,4,10,U;i,j,c,u,tripartizione...]
%           per la tripartizione: 1=T, 2=L, 3=U
%- b vettore colonna dei bilanci
%- u vettore colonna delle capacità inferiori


%CONTROLLI STUPIDITà 
%- la matrice deve essere n*5
if(size(archi_c_u,2)<5)
    disp("la matrice deve essere n*5 !!!");
    return;
end


%ORDINAMENTO (lessicografico) matrice
archi_c_u=sortrows(archi_c_u,[1:2]);

%SEPARAZIONE DELLA TRIPARTIZIONE E DI ALTRI ELEMENTI DI CALCOLO
u=archi_c_u(:,4);
T=[];L=[];U=[];uU=[];uL=[];uT=[];cTT=[];cLT=[];cUT=[];dimT=0; dimL=0; dimU=0;
indT=[];indL=[]; indU=[];
for i=1:size(archi_c_u,1)
    if(archi_c_u(i,5)==2) %L
        L=[L,archi_c_u(i,1:2)];
        indL=[indL,i];
        dimL=dimL+1;
        uL=[uL;archi_c_u(i,4)];
        cLT=[cLT,archi_c_u(i,3)];
    else
        if(archi_c_u(i,5)==3)%U
            U=[U,archi_c_u(i,1:2)];
            indU=[indU,i];
            uU=[uU;archi_c_u(i,4)];
            cUT=[cUT,archi_c_u(i,3)];
            dimU=dimU+1;
        else%T
            T=[T,archi_c_u(i,1:2)];
            indT=[indT,i];
            cTT=[cTT,archi_c_u(i,3)];
            uT=[uT;archi_c_u(i,4)];
            dimT=dimT+1;
        end
    end
end

%CALCOLO numero archi e nodi
nodi=max(T);                    %deve per forza essere un albero di copertura (tocca tutti i nodi)
archi=(length(T)/2)+(length(L)/2)+(length(U)/2);


% CONVERSIONE INPUT
T=VetLin2mat(T,1);
L=VetLin2mat(L,1);
U=VetLin2mat(U,1);
E=VetLin2mat([T,L,U],2);
ET=E(:,1:dimT);
if(dimT+dimL+1==dimT+dimU+dimL)
    EU=E(:,dimT+dimL+1);
else
    EU=E(:,dimT+dimL+1:dimT+dimU+dimL);
end

b(1)=[];        %il primo vincolo è eliminato (sistema sovradeterminato)

%CALCOLO TRIPARTIZIONE, AMMISSIBILITà e soluzine
[xw,pimu,ridottiL,ridottiU,xammis,xdeg,piammis,pideg] = TUTL(ET,EU,b,cTT,cLT,cUT,uU,uL,uT,dimT,dimU,dimL,T,L,U);


%a=numero archi, n=numero nodi

%PROBLEMA FLUSSO COSTO MINIMO (Fcm)
% min c^Tx
% Ex=b
% l<=x<=u
% 1->3   E1,(13)=-1   E3,(13)=1  E=0
% x ha ordine lessicografico
% sum(b)=0   (altrimenti aggiungere nodo fittizio che porti a zero la somma e a cui sono collegati tutti)

% Duale Fcm
% max p^Tb
% p^T E <=c^T    con p=pi greco simbolo


% Cammino minimo (Dijsktra) -> problema di flusso a costo minimo modificato
% u=+inf
%  b_radice=a-(n-1)   b_altri=1

% Minima connessione -> Fcm modificato: trovare T{archi} per cui per ogni
% coppia di nodi si trova percorso minimo

% Flusso Massimo (Ford Falkerson)
% può essere illimitato superiormente se ci sono troppi +inf in u
% dati s=partenza, t=arrivo, v=flusso totale spedito da s a t
% max v
% Ex=b
% 0<=x<=u
% bi=-v se vincolo di partenza, bi=v se vincolo di arrivo, bi=0 altrimenti


% Albero di copertura T (connesso e senza cicli)
% da E va cancellata sempre la riga del nodo 1 (sovradeterminata)
% E_T  è la sottomatrice ottenuta prendendo l'albero di copertura T


% la visita per foglie fa ottenere E_T

% Sul flusso Fcm
% Base=(T,L)
% x_T=E_T^{-1}b  x_L=0   soluzione di base
% p^T=c_T^TE_T^{-1}     potenziale di base
% Cij^p=cij+pi-pj   è il costo ridotto
% ammissibile se x_T>=0, degenere se almeno un x_T=0 
% ammissibile se p^TE_L<=c_L
% ammissibile con costi ridotti (Bellman) (i,j \in L) se Cij^p>=0  degenere se almeno un Cij^p=0
% ottimo=x e p ammissibili

%b a componenti intere allora anche flusso di base lo è

% visita per foglie : partire da una foglia e a ritroso determinare quanto
% assegnare agli archi




end