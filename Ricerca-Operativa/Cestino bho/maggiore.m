function [i,j] = maggiore(A,vett)
%ricava l'arco con peso maggiore (attenzione la matrice di adiacenza ha la diagonale con 10^7)

max=-inf;
ora=0;
for i=1:(length(vett)-1)
    prova=A(vett(i),vett(i+1));
    if(prova>max)
        ora=[vett(i),vett(i+1)]; %arco
        max=prova;
    end 
end
i=ora(1);
j=ora(2);
end