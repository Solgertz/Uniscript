function [valutfinal] = BeBHem(xs,vi,vs,nodi,A,K_albero,scelta)
%Breanch and Bound personalizzato per Hemilton

%Funzioni usate: KBeB

%INTPUT:
%-scelta   vettore di archi [i1,j1;i2,j2;...]
%- A       matrice di degli archi


scelta=[scelta;0,0];%fantasma
Amod=A;
lista=[];
stepper=vs;
aggiornabile=vs;
a=nodoalbero(0,1,vs,vi,scelta(1,:),scelta(1,:),scelta(1,:),lista,size(A,2),1);
scelta(1,:)=[]; 
lista=a.albero;%permette di aggiornare le caratteristiche della lista (va messo a ogni update)
dim=size(scelta,1);%nodi massimi
finale=a; %contiene l'albero totale
tisca=1;
rimuovere=[];
for i=1:dim  %visito per livello 
    %BRANCHING
    % Costruzione dei vincoli figli
    for j=1:(2^i)
        tisca=tisca+1;
        bmod=[];
        simboli=[];
        a=nodoalbero(i,j,aggiornabile,vi,1,1,scelta(1,:),lista,[],[]);

        if(a.stato==2)
            lista=[lista,a];
            rimuovere=[rimuovere,tisca];
            continue;   %non considero i nodi inesistenti
        end
        
        
        usare=a.vincoli;
        if(size(usare{1},1)==1)
            bmod=[bmod;usare{2}];
            simboli=[simboli;usare{1}];
        else
            bmod=[bmod;cell2mat(usare{2})];
            simboli=[simboli;cell2mat(usare{1})];
        end
        %rilassamento del problema
        
        [x,v,ammiss]=KBeB(A,bmod,simboli,K_albero,nodi,a.id); %ordinati in colonna

        if(isempty(x))%problema vuoto
            a.stato=4;
            lista=[lista,a];
            finale=[finale,a];
            continue;
        else
        %BOUNDING
        
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
                if(ammiss)
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
        
         a.arsx=scelta(1,:);
         a.ardx=scelta(1,:);
         finale=[finale,a];
         lista=[lista,a];
        end
    end
    scelta(1,:)=[];
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

    title("BeB con $v_s="+num2str(valutfinal)+"$",Interpreter="latex");


    % Label traslati
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