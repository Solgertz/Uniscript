function [costi] = recuperacosti(grafo,archi)
%formato [i1,i2;j1,j2]
[idxOut, ~] = findedge(grafo, archi(1,:), archi(2,:));
costi=grafo.Edges.Weight(idxOut)';
end