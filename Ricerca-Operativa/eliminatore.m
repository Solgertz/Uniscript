function [T,aux] = eliminatore(T,nodi,tipo)

%INPUT: la matrice può essere di diverse tipologie
%       -(tipo a)rettangolare semplificata con chiusura verso alto o verso sinistra
%       -(tipo a)quadrata 
%       -(tipo s)quadrata semplificata
%       -(tipo s)quadrata

%OUTPUT:    caso 1                  caso 2
%- T        diagonale 10^7          diagonale 10^7
%- aux      diagonale eliminata     diagonale aggiunta


%le modalità vengono dedotte dalla dimensione della matrice T e da nodi

%Note:
%   -si usa 10^7 come sostitutivo di int (infinito) perchè in linprog crea problemi con il vettore "c"

k=1;l=1;
m=size(T,1);
n=size(T,2);

if(tipo=='a')
    if(m==n) %versione quadrata
        aux=10*ones(m,n-1);
        for i=1:m
            for j=1:n
                if(i==j)
                    T(i,j)=10^7;
                end
                if(i~=j) %elimino diagonale
                    aux(k,l)=T(i,j);
                    if(l==n-1)
                        l=1;
                        k=k+1;
                    else
                        l=l+1;
                    end
                end
            end
        end
    end
    
    if(m~=n)%rettangolare semplificata
        if(m>n)%chiusura sinistra
            aux=10*ones(m,n+1);
            for i=1:m
                for j=1:n+1
                    if(i==j)
                        aux(i,j)=0;
                    else
                        aux(i,j)=T(k,l);
                        if(l==n)
                            l=1;
                            k=k+1;
                        else
                            l=l+1;
                        end
                    end
                end
            end 
        else %chiusura alta
            aux=10*ones(m+1,n);
            for i=1:m+1
                for j=1:n
                    if(i==j)
                        aux(i,j)=0;
                    else
                        aux(i,j)=T(k,l);
                        if(l==n)
                            l=1;
                            k=k+1;
                        else
                            l=l+1;
                        end
                    end
                end
            end 
        end
        T=aux;
        for i=1:nodi
            for j=1:nodi
                if(i==j)
                    T(i,j)=10^7;
                end
            end
        end
    end
else
    if(m~=nodi)%quadrata semplificata
        aux=10*ones(nodi);
        for i=1:nodi-1
            for j=1:nodi
                if(i==j)
                    aux(i,j)=0;
                else
                    aux(i,j)=T(k,l);
                    if(l==m)
                        l=1;
                        k=k+1;
                    else
                        l=l+1;
                    end
                end
            end 
        end
        aux(nodi,:)=0;
        T=aux;
        for i=1:nodi
            for j=1:nodi
                if(i==j)
                    T(i,j)=10^7;
                end
            end
        end
    else
        aux=ones(nodi-1);
        for i=1:nodi
            for j=1:nodi
                if(i==j)
                    T(i,j)=10^7;
                else
                    aux(k,l)=T(i,j);
                    if(l==nodi-1)
                        l=1;
                        k=k+1;
                    else
                        l=l+1;
                    end
                end
            end
        end
        aux(nodi,:)=[];
    end
end

end