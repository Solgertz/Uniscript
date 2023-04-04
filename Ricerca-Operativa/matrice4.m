function [A] = matrice4(v1,v2,v3,v4)
%prende 4 vettori di diversa lunghezza e trasforma il tutto in una matrice
%in realtà può usare 2,3 o 4 vettori se gli altri sono segnalati con il
%valore 0

%calcolo il numero di righe necessarie
if (v1==0) %devono esserci almeno 2 vettori
    disp('errore sul numero di vettori inseriti');
    return;
end
if(v2==0)
    disp('errore sul numero di vettori inseriti');
    return;
end

if (v3==0)
    r=2;
end

if(v4==0)
    r=3;
else
    r=4;
end

%calcolo il numero di colonne necessarie
c=[length(v1),length(v2),length(v3),length(v4)];

%pre-alloco la matrice
A=zeros(r,max(c));

%riempio la matrice
A(1,1:length(v1))=v1;
A(2,1:length(v2))=v2;

if(r==3)
    A(3,1:length(v3))=v3;
end
if(r==4)
    A(4,1:length(v4))=v4;
end


end