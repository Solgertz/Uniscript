function [Amod,bmod] = gomory(A,N,B,x,b)
%Amod e bmod sono per <=

%~A
Ab=A;
An=A;
Ab(:,N)=[];
An(:,B)=[];
sym Ab;
Ab1=inv(Ab);
Ati=Ab1*An;

Amod=zeros(length(B),length(N));
bmod=zeros(length(B),1);
disp('Piani di Taglio:');
for j=1:length(B)
    dire="piano per r="+string(B(j));
    for i=1:length(N)
        [ziza]=partefraz(Ati(j,i));
        Amod(j,i)=ziza;
        [frenk]=frazionamelo(ziza);
        dire=dire+frenk+" x"+string(N(i))+"  ";
    end
    [xr]=partefraz(x(B(j)));
    bmod(j,1)=xr;
    [fxr]=frazionamelo(xr);
    dire=dire+">= "+ fxr;
    disp(dire);
end


%riscrivo i vincoli(caso a 2 tagli)

bab=length(B);
bvs=length(N);
h=zeros(size(A,1),1+bab);
h(:,1)=b;

for i=1:size(A,1)
    h(i,2:bab+1)=-Ab(i,:); %variabili N
end

tagl=zeros(size(Amod,1),1+bab);
btagl=bmod;
for i=1:size(Amod,1)
    for j=1:size(Amod,2)
        tagl(i,:)=tagl(i,:)+(Amod(i,j)*h(j,:));
    end
end

btagl=btagl-tagl(:,1);
tagl(:,1)=[];
btagl=-btagl;
tagl=-tagl;

format rat;
disp("  ");
disp('Vincoli di Taglio:')
var=(1:length(B));
for j=1:length(B)
    dire="taglio per r="+string(B(j))+"  ";
    for i=1:length(N)
        [chepasa]=frazionamelo(tagl(j,i));
        dire=dire+chepasa+" x"+string(var(i))+"  ";
    end
    cheposa=frazionamelo(btagl(j));
    dire=dire+"<= "+ cheposa;
    disp(dire);
end



end