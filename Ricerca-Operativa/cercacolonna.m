function [indice] = cercacolonna(A,b)
%cerca l'indice di colonna in cui compare una determinata colonna
[~,indice]=ismember(A',b','rows');
indice=find(indice);

end