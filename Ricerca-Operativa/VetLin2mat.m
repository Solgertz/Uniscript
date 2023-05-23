function [out] = VetLin2mat(vet,mod)
%converte un vettore o una matrice (per PLR)
% - mod=1  : vet=[1,2,1,3,1,4...] in out=[1,1,1...;2,3,4...]
% - mod=2  : vet=[1,1,1;2,3,4...]  in out=matrice di adiacenza nodi*archi

out=[];
if(mod==1)
    a=[];
    b=[];
    
    i=1;
    j=2;
    k=1;
    while(j<=length(vet))
        a(k)=vet(i);
        b(k)=vet(j);
        i=i+2;
        j=j+2;
        k=k+1;
    end
    out=[a;b];
end
if(mod==2)
    nodi=max(vet,[],'all');
    archi=size(vet,2);
    out=zeros(nodi,archi);
    
    for i=1:archi
        out(vet(1,i),i)=-1;
        out(vet(2,i),i)=1;
    end

    %elimino riga del primo nodo (sistema sovradeterminato)
    out(1,:)=[];
end

end