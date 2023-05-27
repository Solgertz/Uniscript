function [solx,solpi] = capacitata(archi_c_u,b,r)

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

%SATURAZIONE
for i=1:dimU  
    b(U(1,i))=b(U(1,i))+uU(i);
    b(U(2,i))=b(U(2,i))-uU(i);
end

%b(1)=[];        %il primo vincolo è eliminato (sistema sovradeterminato)

%AMMISSIBILITà e SOUZIONI
[uno,ottimo,ridottiL,ridottiU,solx,solpi,xtot] = reteammis(nodi,T,L,U,dimT,dimL,dimU,b,cTT,cLT,cUT,uT,uU);


%UN PASSO DEL SIMPLESSO
if(~ottimo)
    [tre,situa] = passoSimplessorete(T,L,U,ridottiU,ridottiL,archi_c_u,xtot);
end


%DIJSKTRA (cammino minimo)
[due,albero]=dijsktra(archi_c_u(:,1:3),nodi,r);
if(~isempty(albero))
    userei=setdiff(archi_c_u(:,[1:2]),albero,"rows");
    baus=ones(nodi,1);
    baus(1)=-(nodi-1);
    [xtot] = smartflux(nodi,albero',userei',size(albero,1),size(userei,1),baus);
    due=dire+matrivetlate(xtot,"x",1);
end


%FORD-FALKERSON
[Ns,Nt,x,v,quattro] = fordfalkerson([archi_c_u(:,[1,2,4]),zeros(archi,1),zeros(archi,1)],archi,nodi);


dire=uno+" "+tre+" "+due+quattro;
stampalatex(dire);


end