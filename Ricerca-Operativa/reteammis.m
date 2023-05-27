function [dire,ottimo,ridottiL,ridottiU,x,pi,xtot] = reteammis(nodi,T,L,U,dimT,dimL,dimU,b,cTT,cLT,cUT,uT,uU)
%verifica se la rete capacitata è ammissibile

dire="\section{Ammissibilità del Flusso}";

figure;
d=digraph(T(1,:),T(2,:));
plot(d);
title("Flusso T");

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

%POTENZIALE MANUALE
pi=zeros(1,dimT+1);

start=T(1,1);%di solito è 1
potenziali_fatti=T(1,1);
for i=1:dimT
    if(~isempty(find(potenziali_fatti==T(1,i))) && isempty(find(potenziali_fatti==T(2,i))))
        pi(T(2,i))=cTT(i)+pi(T(1,i));
        potenziali_fatti=[potenziali_fatti,T(2,i)];
    end
    if(~isempty(find(potenziali_fatti==T(2,i))) && isempty(find(potenziali_fatti==T(1,i))))
        pi(T(1,i))=pi(T(2,i))-cTT(i);
        potenziali_fatti=[potenziali_fatti,T(1,i)];
    end
end


%ammissibilità 
    %x
xammis=all(x'>=0 & x'<=uT);
xdeg=~all(x'>0 & x'<uT);

     %pi
            %calcolo costi ridotti
ridottiL=[]; ridottiU=[];
for i=1:dimL
    ridottiL=[ridottiL;costoridotto(pi,cLT,L,i)];
end
for i=1:dimU
    ridottiU=[ridottiU;costoridotto(pi,cUT,U,i)];
end

piammis=all(ridottiL>=0 & ridottiU<=0);
pideg=~all([ridottiL;ridottiU]);


ottimo=false;
if(piammis && xammis)
    ottimo=true;
end

%I RISULTATI
xtot=[x,zeros(1,dimL),uU'];
amendola=[T,L,U]';
[alba,amen]=sortrows(amendola,[1,2]);
xtot=xtot(amen);
dire=dire+matrivetlate(T',"T",1)+matrivetlate(x,"x_T",1)+matrivetlate(xtot,"x",1)+matrivetlate(pi,"\pi_T",1)+matrivetlate(ridottiL,"C_L^{\pi}",1)+matrivetlate(ridottiU,"C_U^{\pi}",1);

if(xammis)
    dire=dire+" $x_T$ ammissibile ";
else
    dire=dire+" $x_T$ NON ammissibile ";
end
if(xdeg)
    dire=dire+" degenere $\quad$ ";
else
    dire=dire+" NON degenere $\quad$ ";
end
if(piammis)
    dire=dire+" $\pi_T$ ammissibile ";
else
    dire=dire+" $\pi_T$ NON ammissibile ";
end
if(pideg)
    dire=dire+" degenere $\quad$ \\";
else
    dire=dire+" NON degenere $\quad$ \\";
end

if(ottimo)
    dire=dire+" FLUSSO OTTIMO ";
else
    dire=dire+" FLUSSO NON OTTIMO ";
end




end