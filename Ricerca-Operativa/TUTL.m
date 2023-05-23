function [xw,pimu,ridottiL,ridottiU,xammis,xdeg,piammis,pideg] = TUTL(ET,EU,b,cTT,cLT,cUT,uU,uL,uT,dimT,dimU,dimL,T,L,U)
%controlla l'ammissibilità della base fornita


%conversione in triangolare inferiore (visita per foglie)

%{
dimAlb=size(T,2)-1;
dim2=size(ET,1);
albe=T;
ordine=[2:dim2+1];
for i=1:dimAlb
    %ricavo riga e colonna da traslare
    [archetto,nodetto]=foglia(albe);
    albe(:,archetto)=[];
    j=find(ordine==nodetto);
    %sposto la riga
    if(i==1)
        mat=ET;
        mat(j,:)=[];
        ET=[ET(j,:);mat];

        ord=ordine;
        ord(j)=[];
        ordine=[ordine(j),ord];
    else
        mat=ET;
        mat(j,:)=[];
        mat(1:i-1,:)=[];
        ET=[ET(1:i-1,:);ET(j,:);mat];

        ord=ordine;
        ord(j)=[];
        ord(1:i-1)=[];
        ordine=[ordine(1:i-1),ordine(j),ord];
    end
    %sposto la colonna
    if(i==1)
        mat=ET;
        mat(:,archetto)=[];
        ET=[ET(:,archetto),mat];
    else
        mat=ET;
        mat(:,i-1+archetto)=[];
        mat(:,1:i-1)=[];
        ET=[ET(:,1:i-1),ET(:,i-1+archetto),mat];
    end
end
%}
dimAlb=size(T,2)-1;
dim2=size(ET,1);
albe=T;
ordine=[2:dim2+1];ordinarc=[];
for i=1:dimAlb
    %ricavo riga e colonna da traslare
    [archetto,nodetto]=foglia(albe);
    ordinarc=[ordinarc,albe(:,archetto)];
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
%disp(ET);
ordinarc=[ordinarc,albe];
out=zeros(dim2,dimAlb+1);
    
for i=1:(dimAlb+1)
    o1=find(ordine==ordinarc(1,i));
    o2=find(ordine==ordinarc(2,i));
    out(o1,i)=-1;
    out(o2,i)=1;
end
ET=out;

%(x,w)
ETinv=inv(ET);
xT=ETinv*(b-EU*uU);
xL=zeros(dimL,1);
xU=uU;
wT=uT-ETinv*(b-EU*uU);
wL=uL;
wU=zeros(dimU,1);

xw=[xT;xL;xU;wT;wL;wU];

%(pi,mu)  è una riga
piT=cTT*ETinv; pi=piT';
muT=zeros(1,dimT);
muL=zeros(1,dimL);
muUT=cUT-piT*EU;muU=muUT';

piT=[0,piT];pi=[0;pi]; %il primo potenziale è sempre 0

pimu=[piT,muT,muL,muU];

%ammissibilità 
    %x
xammis=all(xT>=0 & xT<=uT);
xdeg=~all(xT>0 & xT<uT);

     %pi
            %calcolo costi ridotti
ridottiL=[]; ridottiU=[];
for i=1:dimL
    ridottiL=[ridottiL,costoridotto(pi,cLT,L,i)];
end
for i=1:dimU
    ridottiU=[ridottiU,costoridotto(pi,cUT,U,i)];
end

piammis=all(ridottiL>=0 & ridottiU<=0);
pideg=~all(ridottiL>0 & ridottiU<0);


end