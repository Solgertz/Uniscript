function [x,y,basef] = solDuale(A,b,c,base,tipo,simplesso)
clc

%FUNZIONI USATE: pausiliario()

%variabile che mi dice se applicare il simplesso
sei=0;%non applico simplesso
signaldeg=0; %mi segnala che devo verificare casi degenere


if(tipo=='p')
    [situ]=pausiliario(A',c');
else
    [situ]=pausiliario(A,b);
end

if(situ==1)%il problema non è vuoto

    %TEST OTTIMALITA' DUALE
    %partendo da un primale 
    if(tipo=='p')
        Aprec=A;
        cprec=c;
        A=A';%la trasposta mi riporta al Duale
        bprec=b;
        b=c';%in realtà questo è il c del primale
        c=bprec';
    end 
    %partendo dal duale
    
    
    l=length(base);%2
    
    n=size(A,1);%2
    m=size(A,2);%6
    vinN=m-l;% |N|=m-n
    
    N=(1:m);
    N(:,base)=[];
    
    if(l~=n) %più B abbiamo meno N abbiamo
        disp('errore, ci devono essere almeno m-n 0 di An');
        return;
    end
    controllo=0;%mi dice che non siamo all'ottimo
    
    Ab=zeros(n,l);
    for i=1:l
        Ab(:,base(i))=A(:,base(i));
    end
    Ab( :, ~any(Ab,1) ) = [];%elimina colonne di zeri
    Ab=Ab';%%%%%%%
    
    Ab1=inv(Ab);
    y1=(b')*Ab1;
    
    y=zeros(1,m);
    for i=1:l
        y(base(i))=y1(i);
    end
    
    z=0;
    nega=0;
    for i=1:m
       
    %verifico se è degenere
    if(y(i)==0)
        z=z+1;
    end
    %verifico se non ammissibile
    if(y(i)<0)
        nega=nega+1;
    end
    end
    
    if(z>vinN)
        disp('y degenere');
        signaldeg=1;
    else
        disp('y non degenere');
    end
    
    if(nega>0)
        disp('y non ammissibile');
        sei=1;
        signaldeg=8;
    else
        disp('y ammissibile');
        controllo=controllo+1;
        signaldeg=signaldeg+1;
    end
    
    
    %TEST OTTIMALITà PRIMALE
    
    if(tipo=='d')%nel caso parta dal duale  
        A=A';%la trasposta mi riporta al Duale
        bprec=b;
        b=c';%in realtà questo è il c del primale
        c=bprec';
    else %nel passo precedente gli avevo modificati
        
        c=cprec;
        
        A=Aprec;
        b=bprec;
    end
    
    
    %Aperdop=Ab;
    
    Ab=A;
    Ab(N, : ) = [];
    bb=b;
    bb(N,:)=[];
    
    Ab1=inv(Ab);
    x=Ab1*bb;
    
    An=A;
    An( base, :)=[];
    
    V=An*x;
    bn=b;
    
    bn(base,:) = [];
    k=0;
    %k=V==bn;%restituisce 1 dove ci sono uguali
    for i=1:length(bn)
        if(string(V(i))==string(bn(i)))
            k=1;
        end
    end

    %K=zeros(vinN,1);
    
    %if(isequal(k,K))%nemmeno 1 degenere
    if(k~=1)
        disp('x non degenere');
    else
        disp('x degenere');
        signaldeg=signaldeg+10;
    end
    
    
    sor=V>bn;
    somma=sum(sor); %se è 0 significa che sono tutti <=
    
    if(somma==0)
        disp('x ammissibile');
        controllo=controllo+1;
        signaldeg=signaldeg+10;
    else
        disp('x non ammissibile');
        signaldeg=signaldeg+1;
        if(sei==1)
            sei=3;
        else
            sei=2;
        end
    end
    
    
    %verifico che le soluzioni indichino stesso valore per T.dualità
    
    fox=c*x;
    foy=y*b;
    if(fox==foy)
        controllo=controllo+1;
    end
    
    %5 signaldeg 0,1,2,4,5
    if(signaldeg==3)%y
        disp('dovresti cercare con simplesso duale un altra base con x ammissibile');
    end
    if(signaldeg==28)%x degenere ammissibile, y non ammissibile
        disp('dovresti cercare con simplesso primale un altra base con y ammissibile')
    end


    if(controllo==3)
        disp('Siamo all ottimo');
    else
        disp('Non siamo all ottimo');
    end
    
    basef=base;
    
    switch sei
        case 1
            disp('  ');
            disp('Applicare simplesso primale:');
            disp('  ');
            if(simplesso=='s')
                [basef]=simp(A,Ab,An,b,bn,c,x,y,base,N,'p');
            end
        case 2
            disp('  ');
            disp('Applicare simplesso duale:');
            disp('  ');
            if(simplesso=='s')
                [basef]=simp(A,Ab,An,b,bn,c,x,y,base,N,'d');
            end
        case 3
            disp('base inutile e da scartare');
        otherwise
    end
    
    
    dire='Il valore di f.o: ';
    [foxs]=frazionamelo(fox);
    dire=[dire,foxs];
    dire=string(strjoin(dire));
    disp(dire);
    
    format rat;
else 
    if(situ==2)
        disp('errore di programmazione nell ausiliario');
    else
        disp('il problema è vuoto');
    end
end
end