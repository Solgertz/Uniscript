function [cridotto] = costoridotto(pi,c,archi,ind)
%calcola il costo ridotto

%INPUT
%-pi  vettore riga dei potenziali
%-c  vettore riga dei costi
%-archi:  vettore colonna degli indici degli archi [i1,i2...;j1,j2...]
%-ind:   indice del vettore degli archi (quello di cui si vuole calcolare il costo ridotto)

%cridotto=cij+pii-pij
cridotto=c(ind)+pi(archi(1,ind))-pi(archi(2,ind));

end