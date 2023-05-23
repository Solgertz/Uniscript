function [indice,elemento] = foglia(albero)
%restituisce l'indice della foglia in albero direzionato


nodi=unique(albero);
occorrenze=zeros(1,length(nodi));
for i=1:size(albero,2)
    primo=albero(1,i);
    secondo=albero(2,i);
    pos1=find(nodi==primo);
    pos2=find(nodi==secondo);
    occorrenze(pos1)=occorrenze(pos1)+1;
    occorrenze(pos2)=occorrenze(pos2)+1;
end

trovati=find(occorrenze==1);
mas=length(trovati);

[~,indice]=find(albero==nodi(trovati(mas)));
elemento=nodi(trovati(mas));


%{
trovati=find(occorrenze==1);

if(nodi(trovati(1))==1)
    [~,indice]=find(albero==nodi(trovati(2)));
    elemento=nodi(trovati(2));
else
    [~,indice]=find(albero==nodi(trovati(1)));
    elemento=nodi(trovati(1));
end
%}

end