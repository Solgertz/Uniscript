function [Ns,Nt,x,v,dire] = fordfalkerson(G,dimx,dimp)

%INPUT
%-G     contiene il grafo in ordine lessicografico   (ogni riga è un arco)
%-dimx  numero di archi
%-dimp  numero nodi

%OUTPUT
%-[Ns,Nt]   costituisce il taglio

%controllo se G contiene capacità intere (in quel caso si può applicare l'algoritmo)
Ns=[]; Nt=[];v=[];x=[];
for i=1:size(G,1)
    if(floor(G(i,3))~=G(i,3))
        dire="FORD FALKERSON NON APPLICABILE: G deve avere capacità intere";
        return;
    end
end
dire="\section{Flusso Massimo con Ford-Falkerson}";
v=0;
x=G(:,5);
%x=zeros(1,dimx);
G(:,4)=G(:,3);
Gx=G;N=dimp;
[C,Ns,Nt,step]=edmondkarp(1,dimp,Gx);
%[Gx] = graforesiduo(x,C);
while(~isempty(C))
    %calcolo residui
    C=[C,zeros(size(C,1),1)];
    for i=1:size(C,1)
        ind=cercariga(Gx(:,[1,2]),C(i,[1:2]));  %cerco arco C nel grafo dei residui
        C(i,3)=Gx(ind,4);
    end
    residui=C(:,3);
    teta=min(residui);
    v=teta+v;
    dire=dire+"\subsection{}"+step+"$$"+matrivetlate(C(:,[1:2]),"\text{A aumentanti}",0)+"\quad "+matrivetlate(C(:,3),"Residui",0)+"\quad "+matrivetlate(teta,"\delta",0)+"\quad "+matrivetlate(v,"v",0)+"$$";
    C=C(:,[1,2]);
    %aggiorno flusso
    for i=1:size(Gx,1)
        if(~isempty(cercariga(C,Gx(i,[1:2]))))
            ind=cercariga(G(:,[1,2]),Gx(i,[1:2]));
            if(~isempty(ind))
                G(ind,5)=G(ind,5)+teta;  %aggiorno soluzione finale
                x(ind)=x(ind)+teta;
            end
            Gx(i,5)=Gx(i,5)+teta;           %aggiorno step intermedio
        end
        if(~isempty(cercariga(C,Gx(i,[2,1]))))
            ind=cercariga(G(:,[1,2]),Gx(i,[1:2]));
            if(~isempty(ind))
                G(ind,5)=G(ind,5)-teta;  %aggiorno soluzione finale
                x(ind)=x(ind)-teta;
            end
            Gx(i,5)=Gx(i,5)-teta;           %aggiorno step intermedio
        end
    end
    dire=dire+matrivetlate(x',"x",1);
    [Gx,G] = graforesiduo(x,G);
    [C,Ns,Nt,step]=edmondkarp(1,dimp,Gx);
end

dire=dire+"\subsection{}"+step;

elementi=[x,G(:,3)];
elemparl=[];
for i=1:size(elementi,1)
    elemparl=[elemparl;"("+num2str(elementi(i,1))+","+num2str(elementi(i,2))+")"];
end


figure;
immagine=digraph(G(:,1)',G(:,2)');
h=plot(immagine,'Layout','force');
h.EdgeLabel=elemparl;
%layout(h,'layered','Direction','right','Sources',1,'Sinks',dimp);
%h.LineStyle='-';
title("Taglio di capacita minima a Flusso ottimo $v="+num2str(v)+"$",Interpreter="latex");
end