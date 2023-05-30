function [xi,costov,ammis] = Kruskaladattivo(G,archiobblig,presenza,K_albero,nodi,grafo)

%INPUT
%-G                 matrice di adiacenza
%-archiobblig       archi con vincoli particolari (obbligati, da rimuovere)
%-presenza          specifica il tipo di particolarità
%-K_albero          
%-nodi              numero di nodi
%-grafo             nome del grafo

archiobblig=archiobblig';

G=graph(G);
archi=G.Edges;
archi=table2array(archi);
archi(:,3)=[];
archi=archi';


%CLASSIFICARE

obbligati=[];darimuovere=[];
for i=1:size(archiobblig,2)
    if(presenza(i)==1)
        obbligati=[obbligati,archiobblig(:,i)];
    else
        darimuovere=[darimuovere,archiobblig(:,i)];
    end
end
metalgear=obbligati;
pool=diffmatrice(archi,darimuovere,1);  %archi da rimuovere rimossi
traffico=pool;

%gestione archi di k
%-controllo la pool di k
[~,aux]=find(pool==K_albero);
if(isempty(aux) || length(aux)<2)
    xi=[];
    costov=[];
    ammis=false;
    return;
end
%-obbligati
kobbligati=[];
if(~isempty(obbligati))%possono essere 0 1 2
    if(~isempty(find(obbligati==K_albero)))
        [~,i]=find(obbligati==K_albero);
        kobbligati=obbligati(:,i);
    end
end
if(isempty(kobbligati))  %determino quanti kobbligati ci sono
    countobbligati=0;
else
    countobbligati=size(kobbligati,2);
end
if(countobbligati>2)        %non si forma un k_albero se forzo ad averne più di uno in k
    xi=[];
    costov=[];
    ammis=false;
    return;
end

%-da scegliere tra i più bassi
auxa=diffmatrice(pool,kobbligati,1);   %archi privati degli esclusi e dei possibili Kobbligati
[~,indo]=find(auxa==K_albero);
auxa=auxa(:,indo);%limitazione a quelli di K
auxc=recuperacosti(G,auxa);
[auxc,indo]=sort(auxc);         % 0 1 2
auxa=auxa(:,indo);

if(isempty(auxa))  %determino quanti kobbligati ci sono
    countknormali=0;
else
    countknormali=size(auxa,2);
end
%-gestisco i casi misti
kfinali=[];
if(countobbligati==2)
    kfinali=kobbligati;
else
    if(countobbligati==1)
        kfinali=[kobbligati,auxa(:,1)];
    else
        kfinali=auxa(:,1:2);
    end
end
%-elimino gli archi collegati a k  (quindi anche una parte degli obbligati)
[~,aux]=find(pool==K_albero);
pool(:,aux)=[];
%-aggiorno gli obbligati (elimino quelli di k)
obbligati=diffmatrice(obbligati,kobbligati,1);


%-elimino archi obbligati rimasti
pool=diffmatrice(pool,obbligati,1);

%pool non contiene: quelli da escludere, i collegati a k,archi obbligati in
%soluzione



%KRUSKAL
%-nodus: nodi collegati
%-xi:  archi già nella soluzione finale (obbligati)
%-pool:    pool di scelta

auxc=recuperacosti(G,pool);
[~,indo]=sort(auxc);  
pool=pool(:,indo);

xi=obbligati;
nodus=0;
%stabilisco il numero di nodi già collegati
if(~isempty(xi))
    nodus=[nodus;unique(xi(:))];
    nodus=nodus';
end
i=1;
while (length(nodus)<=nodi && i<=size(pool,2))  %esco se: ho collegato tutti i nodi, ho finito archi in pool
    %creo ipotetica rete
    graziami=[xi,pool(:,i)];
    graziami=graph(graziami(1,:),graziami(2,:));
    if(~hascycles(graziami))
        xi=[xi,pool(:,i)];  %aggiungo in soluzione arco
        %aggiungo il nodo a quelli già collegati
        if(isempty(find(nodus==pool(1,i))))
            nodus=[nodus,pool(1,i)];
        end
        if(isempty(find(nodus==pool(2,i))))
            nodus=[nodus,pool(2,i)];
        end
    end  
    i=i+1;
end


%MOSTRO GRAFICI
xi=[kfinali,xi];
costov=recuperacosti(G,xi);
costov=sum(costov);
zio=graph(xi(1,:),xi(2,:));
%Grafici del BeB
figure;
plot(zio);
title("$P_{"+grafo(1)+","+grafo(2)+"}$",Interpreter="latex");



%VERIFICA



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
cicli=allcycles(zio);ciclantibus=cicli;
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
    %CONTROLLO VUOTEZZA DEL PROBLEMA: se l'arco che non appartiene al ciclo,
    %gli ho escluso tutti gli archi
    cicli=cell2mat(ciclantibus);

    nodinonciclo=[1:nodi];
    nodinonciclo=setdiff(nodinonciclo,cicli);
    
    if(~isempty(nodinonciclo))
        conto=0;
        for i=1:length(nodinonciclo)
            for j=1:size(traffico,2)
                if(traffico(1,j)==nodinonciclo(i) || traffico(2,j)==nodinonciclo(i))
                    conto=conto+1;
                end
            end
        end
        if(conto<2)
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



%CONTROLLO SE GLI ARCHI OBBLIGATI NON FORMANO UN CICLO IRROMPIBILE
%CONTROLLO SE TRA GLI OBBLIGATI C'è UN NODO COLLEGATO A PIù DI 3 ARCHI
if(~ammis && ~isempty(metalgear))
    metal=graph(metalgear(1,:),metalgear(2,:));
    if(hascycles(metal))
            xi=[];
        costov=[];
        ammis=false;
    end
    for i=1:nodi
        conto=sum(metalgear(:)==i);  %conto quante volte compare un certo nodo
        if(conto>2)
            xi=[];
            costov=[];
            ammis=false;
            return;
        end
    end
end
end