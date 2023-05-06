function [finale] = unisci(per1,arc1,per2,arc2)
%dati due path di un grafo, gli unisce secondo l'algoritmo delle toppe e
%secondo i due archi indicati

%INPUT:
%       - per: sono i percorsi per scorrimento, [2,5,6] è 2->5->6->2
%       - arc: sono gli indici degli archi, [partenza,arrivo]

i = find(per1==arc1(1)); j = find(per1==arc1(2));      % arco i,j
k = find(per2==arc2(1)); l = find(per2==arc2(2));     % arco k,l

a1=per1;b1=per2;
a1(a1==arc1(2))=arc2(2);
b1(b1==arc2(2))=arc1(2);

finale=[a1(1:j),per2(l:length(b1))];
finale=unique(finale);
finale=[finale,per2(1:k),per1(j:length(per1))];

end