function [xtot] = smartflux(nodi,T,L,dimT,dimL,b)

%verifica se la rete capacitata è ammissibile


%VISITA PER FOGLIE
dimAlb=size(T,2)-1;
dim2=nodi-1;
albe=T;
ordine=[2:dim2+1];ordinarc=[];ordinodi=[];
for i=1:dimAlb
    %ricavo riga e colonna da traslare
    [archetto,nodetto]=foglia(albe);
    ordinarc=[ordinarc,albe(:,archetto)];
    ordinodi=[ordinodi,nodetto];
    albe(:,archetto)=[];
    j=find(ordine==nodetto);
    %sposto la riga
    if(i==1)
        ord=ordine;
        ord(j)=[];
        ordine=[ordine(j),ord];
    else
        ord=ordine;
        ord(j)=[];
        ord(1:i-1)=[];
        ordine=[ordine(1:i-1),ordine(j),ord];
    end
end
[archetto,nodetto]=foglia(albe);
ordinarc=[ordinarc,albe(:,archetto)];
ordinodi=[ordinodi,nodetto];


%CALCOLO MANUALE PER X

    %ordine di istanziazione di x
indX=[];

for i=1:dimT
    [~,temp]=ismember(T',ordinarc(:,i)','rows');
    temp=find(temp);
    %[~,temp]=find(ordinarc==T(:,i));
    indX=[indX,temp];
end
    %
x=zeros(1,dimT);
for i=1:dimT
    if(ordinarc(2,i)==ordinodi(i))  %la foglia è un arrivo
        x(indX(i))=b(ordinodi(i)); 
        b(ordinarc(1,i))=b(ordinarc(1,i))+b(ordinodi(i));%aggiorno bilancio collegato
    else
        x(indX(i))=-b(ordinodi(i)); 
        b(ordinarc(2,i))=b(ordinarc(2,i))+b(ordinodi(i));%aggiorno bilancio collegato
    end
end


%I RISULTATI
xtot=[x,zeros(1,dimL)];
amendola=[T,L]';
[~,amen]=sortrows(amendola,[1,2]);
xtot=xtot(amen);

end
