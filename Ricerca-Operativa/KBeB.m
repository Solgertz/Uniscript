function [xi,costov,ammis] = KBeB(G,archiobblig,presenza,K_albero,nodi,grafo)
%Kruscal per il BeB



%Creo vettore dei costi e degli archi
u=1;
for i=1:size(G,1)
    for j=1:size(G,2)
        if(j>i)
            costi(u)=G(i,j);
            archi(:,u)=[i;j];
            u=u+1;
        end
    end
end

%Ordinamento archi e costi
[costi,ordim]=sort(costi);
archi=archi(:,ordim);


%Rimozione archi obbligati e costi obbligati
if(~isempty(archiobblig))
    for i=1:size(archiobblig,1)
        if(presenza(i)==0)
            G(archiobblig(i,1),archiobblig(i,2))=0;
            loreipsum=[archiobblig(i,1);archiobblig(i,2)];
            k=1;
            for j=1:size(archi,2)
                if(archi(:,j)==loreipsum)
                    ulcera(k)=j;
                end
            end
            archi(:,ulcera)=[];
            costi(ulcera)=[];
        end
    end
end

%aggiungo archi obbligati
k=1;
costiobblig=[];
obbligh=[];
karchi=[];
kcosti=[];
if(~isempty(archiobblig))%istanzio array di archiobblig e costiobblig
    for i=1:size(archiobblig,1)
        if(presenza(i)==1)
            costiobblig(k)=G(archiobblig(i,1),archiobblig(i,2));
            obbligh(:,k)=[archiobblig(i,1);archiobblig(i,2)];
            k=k+1;
        end
    end
    [costiobblig,ordim]=sort(costiobblig);
    obbligh=obbligh(:,ordim);
    %verifico se il nodo obbligato è di un k-albero
    [~,kindici]=find(obbligh==K_albero);
    if(~isempty(kindici))
        if(length(kindici)>1)
            karchi=[obbligh(:,kindici(1)),obbligh(:,kindici(2))];
            kcosti=[costiobblig(kindici(1)),costiobblig(kindici(2))];
            obbligh(:,kindici(1:2))=[];
            costiobblig(kindici(1:2))=[];
        else
            karchi=obbligh(:,kindici);
            kcosti=costiobblig(kindici);
            obbligh(:,kindici)=[];
            costiobblig(kindici)=[];
        end
    end
    
end

%escludo il nodo del K-albero
[~,archiesclu]=find(archi==K_albero); %se erano in ordine crescente prima, lo sono anche ora
%controllo se ci sono almeno 2 archi (altrimenti è vuoto)
if(isempty(archiesclu) || length(archiesclu)==1)
    xi=[];
    costov=[];
    ammis=false;
    return;
end


%costo finale=costi archi esclusi + costi obbligati
if(~isempty(kcosti))
    if(length(kcosti)==1)
        costiescl=[costi(archiesclu(1)),kcosti]; %c'è un arco k-albero obbligato
        archiv=[archi(:,archiesclu(1)),karchi]; %archi esclusi
    else
        costiescl=kcosti(1:2); %ci sono entrambi
        archiv=karchi(:,1:2);
    end
else
    costiescl=[costi(archiesclu(1)),costi(archiesclu(2))]; %nessun arco k_albero obbligato
    archiv=archi(:,archiesclu(1:2)); %archi esclusi
end
costov=sum(costiescl);
%archi finali= archi esclusi (archiv) + pool di kruskal
archiVI=obbligh;  %pool di kruskal (archi obbligati, tranne quelli di K_albero)

%elimino tutti gli archi collegati al K_albero
costi(archiesclu)=[];  
archi(:,archiesclu)=[];

%per Kruskal: elimino archi della pool (ci stanno già in soluzione)
if(~isempty(archiVI))
    k=1;
    ulceratopo=[];
    for i=1:size(archiVI,2)
        for j=1:size(archi,2)
            if(archi(:,j)==archiVI(:,i))
                ulceratopo(k)=j;
                k=k+1;
            end
        end
    end
if(isempty(ulceratopo))  % in caso arco obbligato non sia karco ma sia legato al k-albero (già eliminati prima)
    k=1;
else
    costi(ulceratopo)=[];
    archi(:,ulceratopo)=[];
    k=size(archiVI,2)+1;
end
else
    k=1;
end




    %Kruskal  %archi vs pool
nodus=0;
if(~isempty(archiVI))
    nodus=[nodus;unique(archiVI(:))];
    nodus=nodus';
end
i=1;
while (length(nodus)<=nodi && i<=length(costi))
    graziami=archiVI;
    if(~isempty(graziami))
        lungo=size(graziami,2)+1;
    else
        lungo=1;
    end
    graziami(:,lungo)=archi(:,i);
    aiutami=graph(graziami(1,:),graziami(2,:));
    if(~hascycles(aiutami))
        archiVI(:,k)=archi(:,i);
        costov=costov+costi(i);
        %aggiungo il nodo 
        if(isempty(find(nodus==archi(1,i))))
            nodus=[nodus,archi(1,i)];
        end
        if(isempty(find(nodus==archi(2,i))))
            nodus=[nodus,archi(2,i)];
        end
        k=k+1;
    end  
    i=i+1;
end
%{
for i=1:length(costi)
    graziami=archiVI;
    if(~isempty(graziami))
        lungo=size(graziami,2)+1;
    else
        lungo=1;
    end
    graziami(:,lungo)=archi(:,i);
    aiutami=graph(graziami(1,:),graziami(2,:));
    if(~hascycles(aiutami))
        archiVI(:,k)=archi(:,i);
        costov=costov+costi(i);
        k=k+1;
    end
end
%}

xi=[archiv,archiVI];
zio=graph(xi(1,:),xi(2,:));
%Grafici del BeB
figure;
plot(zio);
title("$P_{"+grafo(1)+","+grafo(2)+"}$",Interpreter="latex");


ammis=true;%verifico ammissibilità
for i=1:nodi
    [r,c]=find(xi==i);
    if(length(r)~=2) %c'è almeno un nodo senza 2 archi
        ammis=false;
    end
end

%verifico se è tutto connesso
emirati=conncomp(zio);
if(~all(emirati==emirati(1)))
    xi=[];
    costov=[];
    ammis=false;
    return;
end

%verifico se c'è più di un ciclo (e se l'unico ciclo coinvolge almeno il k-albero)
cicli=allcycles(zio);
if(hascycles(zio))
    if(length(cicli)>1)%verifico che non ci sia più di un ciclo
        xi=[];
        costov=[];
        ammis=false;
        return;
    else
        %verifico se l'unico ciclo contiene almeno il k_albero
        cicli=cell2mat(cicli);
        s=[];
        [~,s]=find(cicli==K_albero);
        if(isempty(s))
            xi=[];
            costov=[];
            ammis=false;
            return;
        end
    end
else
    xi=[];
    costov=[];
    ammis=false;
    return;
end






end