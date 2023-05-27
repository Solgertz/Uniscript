function [valutfinal] = BeBzaino(c,A,b,simb,tipo,vs,xs,vi,xi,mod,scelta)

%Classi usate: nodoalbero

%INPUT:
%-mod:  bipartito classico (0), bipartito binario (1), Hamitlon (2). Non è preso in
%       cosiderazione il caso multipartito
%-scelta:    in questo caso è indicato un ordine di istanziazione delle
%            variabili (che può non essere completo). E' un vettore riga
%            degli indici
%-tipo:  'p' se problema di massimo 'd' se problema di minimo


if(isempty(scelta))
    scelta=[1:length(c)+1];   % tutte le variabili in ordine
else
    scelta=[scelta,0];
end

Amod=A;
bmod=b;
simboli=simb;
lista=[];
foglie=[];

if(tipo=='p')
    stepper=vi;
    aggiornabile=vi;
else
    stepper=vs;
    aggiornabile=vs;
end
if(mod==1)
    a=nodoalbero(0,1,vs,vi,0,1,scelta(1),lista,size(A,2),0);
else
    if(tipo=='p')
        a=nodoalbero(0,1,vs,vi,floor(xs(scelta(1))),ceil(xs(scelta(1))),scelta(1),lista,size(A,2),2);
    else
        a=nodoalbero(0,1,vs,vi,floor(xi(scelta(1))),ceil(xi(scelta(1))),scelta(1),lista,size(A,2),2);
    end
end
%a.scelta=scelta(1);
%scelta(1)=[]; 
lista=a.albero;%permette di aggiornare le caratteristiche della lista (va messo a ogni update)
dim=length(c);%nodi massimi
finale=a; %contiene l'albero totale
tisca=1;
rimuovere=[];
for i=1:dim  %visito per livello 
    %BRANCHING
    % Costruzione dei vincoli figli
    for j=1:(2^i)
        tisca=tisca+1;
        Amod=A;
        bmod=b;
        simboli=simb;
        if(tipo=='p')
            a=nodoalbero(i,j,vs,aggiornabile,1,1,scelta(1),lista,[],[]);
        else
            a=nodoalbero(i,j,aggiornabile,vi,1,1,scelta(1),lista,[],[]);
        end
        if(a.stato==2)
            lista=[lista,a];
            rimuovere=[rimuovere,tisca];
            continue;   %non considero i nodi inesistenti
        end
        
        usare=a.vincoli;
        Amod=[Amod;cell2mat(usare{1})];
        if(size(usare{3},1)==1)
            bmod=[bmod;usare{3}];
            simboli=[simboli;usare{2}];
        else
            bmod=[bmod;cell2mat(usare{3})];
            simboli=[simboli;cell2mat(usare{2})];
        end
        %rilassamento del problema
        [ce,nA,nb,Aeq,beq,LB,UB,~,~,~]=sostitutore(c,Amod,bmod,simboli,tipo);
        cUB=UB;
        for ic=1:size(UB,1)
            if(cUB(ic)==Inf)
                cUB(ic)=1;
            end
        end
        [x,v]=linprog(ce,nA,nb,Aeq,beq,LB,cUB);
        
         %cerco la prima componente frazionaria
        for  ic=1:length(x)
            if(~(x(ic)==0 || x(ic)==1))
                primato=ic;
                break;
            end
        end
        %scelta=[ic,scelta];
        a.scelta=ic;
        
        if(isempty(x))%problema vuoto
            a.stato=2;
            lista=[lista,a];
            finale=[finale,a];
            continue;
        else
        %BOUNDING
         if(tipo=='p')
             vs=approssima(-v,0);
             a.vs=vs;
             a.vi=aggiornabile;
             if(a.vs<=aggiornabile)  %regola di taglio 2
                 a.stato=1;
                 finale=[finale,a];
                 lista=[lista,a];
                 if(i==dim) %foglia esistente
                     a.marco=1;
                     if(a.stato~=2 && a.vi>stepper)
                        %prendo la foglia che ha la Vi più grande
                            stepper=a.vi;
                     end
                 end
                 continue;
             end
             if(a.vs>aggiornabile)   %regola di taglio 3
                %verifico ammissibilità
                [~,Aprova,bprova,~,~,~]=convOdual(2,c,A,simb,b,0,0);
                condca=true;
                for z=1:length(x)
                    if(floor(x(z))~=x(z) || ceil(x(z))~=x(z))
                        condca=false;
                        break;
                    end
                end
                if(condca && Aprova*x<=bprova)
                    aggiornabile=a.vs;
                    a.vi=aggiornabile;
                    a.stato=3;
                    finale=[finale,a];
                    lista=[lista,a];
                    if(i==dim) %foglia esistente
                         a.marco=1;
                         if(a.stato~=2 && a.vi>stepper)
                           %prendo la foglia che ha la Vi più grande
                                stepper=a.vi;
                         end
                     end
                    continue;
                end
             end
             if(i==dim) %foglia esistente
                 a.marco=1;
                 if(a.stato~=2 && a.vi>stepper)
                    %prendo la foglia che ha la Vi più grande
                    stepper=a.vi;
                 end
             end
         else
             vi=approssima(v,1);
             a.vi=vi;
             a.vs=aggiornabile;
             if(a.vi>=aggiornabile)  %regola di taglio 2
                 a.stato=1;
                 finale=[finale,a];
                 lista=[lista,a];
                 if(i==dim) %foglia esistente
                     a.marco=1;
                     if(a.stato~=2 && a.vs<stepper)
                        %prendo la foglia che ha la Vs più grande
                         stepper=a.vs;
                     end
                 end
                 continue;
             end
             if(a.vi<aggiornabile)   %regola di taglio 3
                %verifico ammissibilità
                [~,Aprova,bprova,~,~,~]=convOdual(1,c,A,simb,b,0,0);
                if(Aprova*x==bprova)
                    aggiornabile=a.vi;
                    a.vs=aggiornabile;
                    a.stato=3;
                    finale=[finale,a];
                    lista=[lista,a];
                    if(i==dim) %foglia esistente
                     a.marco=1;
                     if(a.stato~=2 && a.vs<stepper)
                       %prendo la foglia che ha la Vs più grande
                        stepper=a.vs;
                     end
                    end
                    continue;
                end
             end
             if(i==dim) %foglia esistente
                 a.marco=1;
                 if(a.stato~=2 && a.vs<stepper)
                    %prendo la foglia che ha la Vs più grande
                    stepper=a.vs;
                 end
             end
         end
         if(mod==1)
            a.arsx=0;
            a.ardx=1;
         else
            a.arsx=floor(x(scelta(1)));
            a.arcdx=ceil(x(scelta(1)));
         end
         finale=[finale,a];
         lista=[lista,a];
        end
    end
    %scelta(1)=[];
end
    
    
    valutfinal=stepper;

    %PLOTTING
    
    nodato=[];%indica il nome Pij
    bippato=[];%indica le valutazioni Pi,j
    colorato=[];%indica i colori dei nodi 
    scopata=length(finale);
    for i=1:scopata
        a=finale(i);
        if(a.stato==4)
            bippato=[bippato,"$\O$"];
        else
            bippato=[bippato,"["+num2str(a.vi)+","+num2str(a.vs)+"]"];
        end
        if(a.stato==0)
            colorato=[colorato;0,0,0];%nero
        end
        if(a.stato==3)
            colorato=[colorato;0,1,0];%verde (taglio con aggiornamento)
        end
        if(a.stato==1)
            colorato=[colorato;0,0,1];%blu (taglio senza aggiornare)
        end
        if(a.stato==4)
            colorato=[colorato;1,0,0];%rosso (caso vuoto)
        end
        nodato=[nodato,"$P_{"+num2str(a.id(1))+","+num2str(a.id(2))+"}$"];
    end
    [mat,parlato]=costruiscitabella(lista,finale);
    figure;
    G=digraph(mat);
    G.Edges.vincoli=parlato';
    %rimozione nodi inutili
    G=rmnode(G,rimuovere);
    G.Nodes.nomi=nodato';
    h=plot(G,'EdgeLabel',G.Edges.vincoli,'NodeLabel',G.Nodes.nomi,Interpreter='latex',EdgeFontSize=10,NodeColor=colorato);
    if(tipo=='p')
        title("BeB con $v_i="+num2str(valutfinal)+"$",Interpreter="latex");
        %title("BeB con $v_i=3$",Interpreter="latex");
        
    else
        title("BeB con $v_s="+num2str(valutfinal)+"$",Interpreter="latex");
    end

    % Add new labels that are to the upper, right of the nodes
    text(h.XData+.01, h.YData+.01 ,h.NodeLabel, ...
    'VerticalAlignment','Bottom',...
    'HorizontalAlignment', 'left',...
    'FontSize', 10,Interpreter='latex');
    text(h.XData+.01, h.YData+.01 ,bippato, ...
    'VerticalAlignment','Bottom',...
    'HorizontalAlignment', 'right',...
    'FontSize', 10,Interpreter='latex');
    % Remove old labels
    h.NodeLabel = {}; 
    


end
