function [G] = Hemilton(nodi,T,tipo,K_albero,nodovicino,esclusiva)

%Funzioni usate: eliminatore(), toppe()

%INPUT:
%-T         se 'a': matrice quadrata completa(con diagonale)
%                   matrice rettangolare semplificata (senza diagonale)
%           se 's': matrice quadrata semplificata (esclusa la diagonale) 
%                   e con i costi effettivi sul triangolo superiore
%                   OPPURE matrice quadrata completa (con la diagonale di 0)
%                   e con i costi effettivi sul triangolo superiore
%-nodi      è il numero di nodi totali
%-tipo      a (asimmetrico), tipo s (simmetrico)
%           PER SIMMETRICO
%-K_albero      nodo di partenza per Vi (omettibile)
%-nodovicino    nodo di partenza per Vs (omettibile)


%c è una matrice di archi
if(tipo=='a')%versione asimmetrica
    
    %Vi -> assegnamento non cooperativo    
    [A,~]=eliminatore(T,nodi,'a');
    [~,B]=eliminatore(A,nodi,'a');
    semplice=B;
    [~,B]=eliminatore(B,nodi,'a'); %diagonale 0
    f = reshape(A',1,[]);
    Aeq = kron(eye(nodi),ones(1,nodi));
    beq = ones(2*nodi,1);
    lb = zeros(size(f));
    ub = ones(size(f));
    Amod = repmat(eye(nodi),1,nodi); % Crea la matrice per i vincoli di riga
    Aeq=[Aeq;Amod];
    [xi, vi] = linprog(f,[],[],Aeq,beq,lb,ub);
    
    ragionamento="\section{TSP Asimmetrico}"+matrivetlate(B,"ATSP",1)+matrivetlate(semplice,'ATSP_{\text{ridotta}}',1);
    G = digraph(B) ;
    figure;
    plot(G,'EdgeLabel',G.Edges.Weight);
    title("Grafo originale");

    % Aggiunta dei pesi
    k=1;
    for i = 1:length(xi)
        if(xi(i)~=0)
            u(k)= ceil(i/nodi); % calcola l'indice della riga
            v(k)= mod(i-1, nodi) + 1; % calcola l'indice della colonna
            %G = addedge(G, u, v, f(i)); % aggiunge l'arco con il peso corrispondente
            pesi(k)=f(i);
            k=k+1;
        end
    end
    G = digraph(u,v,pesi) ;
    figure;
    plot(G,'EdgeLabel',G.Edges.Weight);
    title("Valutazione inferiore");

    %matrice di adiacenza
    for i = 1:length(u)
        usami(u(i), v(i)) = pesi(i);
    end
    
    
    minimale=vi;
    %VS
    %codice interattivo!!!!

    %INPUTTAGGIO
    stop=false;
    while(~stop)
        responso=input("Continuare algoritmo Y/N [N]?","s"); %risposta predefinita è no
        if(responso=="Y")
            disp("inserendo come input la lettera N a qualsiasi fase, si provocherà lo stop dell'algoritmo");
        else
            stop=true;
            break;
        end

        arc=input("Rattoppo (es: [arco1;arco2]=[1,2;5,7]) :"); %matrice 2*2
        
        if(~isempty(arc) && size(arc,1)==2 && size(arc,2)==2)
            [Gadia,situazione,vi]=toppe(G,B,arc(1,:),arc(2,:),vi);
            if(situazione==0)
                break; %nessun ciclo
            end
            if(situazione==1)
                disp("Grafo non unibile con questi nodi");
                continue;
            end
            G = digraph(Gadia);
            figure;
            plot(G,'EdgeLabel',G.Edges.Weight);
            title("Toppa");
            if(situazione==2)
                break;
            end
        else
            disp("La matrice deve essere 2*2: prima riga=primo arco e seconda riga=secondo arco");
            disp("ogni arco deve essere orientato: prima colonna=partenza e seconda colonna=arrivo");
            continue;
        end
    end

    %RISULTAGGIO
    ragionamento=ragionamento+"\section{Risultato}"+matrivetlate(xi',"x_i",1)+"$$ "+latex(sym(minimale))+" \leq "+"V_o"+" \leq "+latex(sym(vi))+" $$";
    
    G=B;
else

    
    %RICAVO LA SIMMETRICA (Gestisce sia il caso di matrice con diagonale che senza)
    [G,~]=eliminatore(T,nodi,'s'); %diagonale 10^7
    [~,G]=eliminatore(G,nodi,'s'); %senza diagonale
    semplice=G;
    [~,G]=eliminatore(G,nodi,'s'); %diagonale 0
    %azzero la triangolare ingeriore
    G=triu(G);
    G=G+G';
  
    H = graph(G);
    figure; %permette di creare più grafici
    plot(H,'EdgeLabel',H.Edges.Weight);
    title("Grafo di partenza");

    ragionamento="\section{TSP simmetrico}"+matrivetlate(G,"STSP",1)+matrivetlate(semplice,'STSP_{\text{ridotta}}',1);
    %matrice espansa e semplificata, vettore pesi e archi crescenti, grafo
    %originale

%Vi per Kruskal

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

   [costi,ordim]=sort(costi);
   archi=archi(:,ordim);
   ragionamento=ragionamento+matrivetlate(archi,"Archi",1)+matrivetlate(costi,"Costi",1);

   %di appoggio per la VS
   archiVS=archi;
   archiVSrise=archi;
   costiVS=costi;

    

   if(isempty(K_albero)) %cerco il nodo escluso (se non specificato)
       costov=inf;
       
       for i=1:nodi
           [~,archiesclu]=find(archi==i); %se erano in ordine crescente prima, lo sono anche ora
           costiescl=[costi(archiesclu(1)),costi(archiesclu(2))];
           if(costiescl(1)+costiescl(2)<costov)
               archiv=archi(:,archiesclu(1:2));
               costov=costiescl(1)+costiescl(2);
               K_albero=i;
           end
       end


   else
       [~,archiesclu]=find(archi==K_albero); %se erano in ordine crescente prima, lo sono anche ora
       costiescl=[costi(archiesclu(1)),costi(archiesclu(2))];
       archiv=archi(:,archiesclu(1:2));
       costov=costiescl(1)+costiescl(2);
       
       costi(archiesclu)=[];
       archi(:,archiesclu)=[];
   end
   [~,j]=find(archi==K_albero); %elimino gli archi del nodo K per fare Kruskal
   costi(j)=[];
   archi(:,j)=[];


        %Kruskal

    nodus=0;
    i=1;
    k=1;
    archiVI=[];
    while (length(nodus)<nodi && i<=length(costi))
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
   k=1;
   for i=1:length(costi)
       if(i~=1)
            if(~((~isempty(find(archiVI==archi(1,i)))) && (~isempty(find(archiVI==archi(2,i))))))
                archiVI(:,k)=archi(:,i);
                costov=costov+costi(i);
                k=k+1;
            end
       else
            archiVI(:,k)=archi(:,i);
            costov=costov+costi(i);
            k=k+1;
       end
   end
   %}
   xi=[archiv,archiVI];


   %Vs
   if(isempty(nodovicino))
        nodovicino=1;
   end
   primo=nodovicino;
    costofin=0;
    nodus=[1:nodi];
    nodus=nodus(nodus~=nodovicino);
    nodVS=[];%indici degli archi
    k=1;
    while(~isempty(nodus))
        %Seleziono archi del nodovicino e prendo quello più basso
        [~,col]=find(archiVS==nodovicino);
        col=col(1);
        %aggiungo arco, tolgo nodo nuovo, aggiorno nuovo nodovicino
        nodVS(k)=col;
        
        if(~isempty(find(nodus==archiVS(1,col))))
            nodus=nodus(nodus~=archiVS(1,col));
            [~,j]=find(archiVS==nodovicino);
            nodovicino=archiVS(1,col);
            archiVS(:,j)=-1;
        else
            nodus=nodus(nodus~=archiVS(2,col));
            [~,j]=find(archiVS==nodovicino);
            nodovicino=archiVS(2,col);
            archiVS(:,j)=-1;
        end
        costofin=costofin+costiVS(col);
        k=k+1;
    end
    %chiudo il cammino
    archiVS=archiVSrise(:,nodVS);
    archiVS=[archiVS,[nodovicino;primo]];
    costofin=costofin+G(nodovicino,primo);

    %MOSTRO I RISULTATI

    
    %Vi
    %xi, costov
    for i=1:size(xi,2)
        pesini(i)=G(xi(1,i),xi(2,i));
    end
    for i=1:size(archiVS,2)
        pesoni(i)=G(archiVS(1,i),archiVS(2,i));
    end
    H = graph(xi(1,:),xi(2,:),pesini);
    figure; %permette di creare più grafici
    plot(H,'EdgeLabel',H.Edges.Weight);
    title("Valutazione Inferiore ("+K_albero+"-albero)");
    
    %VS
    %archiVS, costofin
    H = graph(archiVS(1,:),archiVS(2,:),pesoni);
    figure;
    plot(H,'EdgeLabel',H.Edges.Weight);
    title("Valutazione Superiore (nodo partenza="+primo+")");
    

    ragionamento=ragionamento+"\section{Risultato}"+"$$ "+latex(sym(costov))+" \leq "+"V_o"+" \leq "+latex(sym(costofin))+" $$";
    stampalatex(ragionamento);

    [valutfinal] = BeBHem(xi,costov,costofin,nodi,G,K_albero,esclusiva);
end