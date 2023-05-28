function [C] = diffmatrice(A,B,mod)
%ricava la differenza tra le colonne (o le righe) di una matrice A rispetto
%a una matrice B

%INPUT
%-mod(0)= righe   mod(1)=colonne

%CONTROLLI
if(isempty(A))
    C=[];
    return;
end
if(isempty(B))
    C=A;
    return;
end

C=A;

%MODALITà RIGHE
if(mod==0)
    for i=1:size(B,1)
        indice=cercariga(C,B(i,:));
        if(~isempty(indice))
            C(indice,:)=[];
        end
    end
else
%MODALITà COLONNE
    for i=1:size(B,2)
        indice=cercacolonna(C,B(:,i));
        if(~isempty(indice))
            C(:,indice)=[];
        end
    end
end

 


end