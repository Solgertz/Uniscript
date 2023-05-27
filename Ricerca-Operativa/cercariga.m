function [indice] = cercariga(A,c)
%cerca l'indice di riga in cui compare una determinata riga
[~,indice]=ismember(A,c,'rows');
indice=find(indice);

end