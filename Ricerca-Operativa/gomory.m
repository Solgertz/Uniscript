function [Aw,bnew,dire] = gomory(A,N,B,x,b)
%fa uscire fuori i vincoli di taglio

%Funzioni usate:partefraz(), frazionamelo()

dire="\section{Calcolo dei piani}";


Ab=A(:,B);
An=A(:,N);
Ainv=inv(Ab);
Amod=Ainv*An; %B*N
bmod=x(B);
r=mod(bmod,1)~=0; %mi restituisce gli indici che hanno valore
r=find(r);

if(~isempty(r))
    %escludo le righe non frazionarie secondo r
    Amodfraz=Amod(r,:);
    bmodfraz=bmod(r);
    %calcolo la parte frazionaria
    Amodfraz=partefraz(Amodfraz);
    bmodfraz=partefraz(bmodfraz);
end

%ricavo i vincoli
        %Piccola spiegazione matematica: A_m è quella dei piani di taglio
        %-  Ax=b    ->      (A_b x_b)+(A_n x_n)=b      ->       x_n=(b-(A_b x_b))/(A_n)
        %-  A_m x_n>=b_m     ->      ((A_m b)-(A_m A_b x_b))/(A_n)>=b_m
        %-  (A_m b)-(A_m A_b x_b)>=b_m A_n  ->      (A_m b)-(b_m A_n)>=A_m A_b x_b
%{
Anew=Amodfraz*Ab;
bnew=(Amodfraz*b)-(Anext*bmodfraz);
%}

for i=1:size(Amodfraz,1)
    for j=1:size(Amodfraz,2)
        if(j==1)
            Anew(i,:)=Amodfraz(i,j)*Ab(j,:);
            bnew(i,:)=Amodfraz(i,j)*b(j);
        else
            Anew(i,:)=Anew(i,:)+(Amodfraz(i,j)*Ab(j,:));
            bnew(i,:)=bnew(i,:)+(Amodfraz(i,j)*b(j));
        end 
    end
    bnew(i,:)=bnew(i,:)-bmodfraz(i);
end

%semplifico l'espressiones
for i=1:size(Anew,1)
    s=[Anew(i,:),bnew(i)];
    [numi,dumi]=rat(s);
    l=dumi(1);
    for j=2:length(dumi)  
        l = lcm(l,dumi(j))%mcm
    end
    emi=l./dumi;

    s=numi.*emi;
    g=s(1);
    for j=2:length(s)  
        g = gcd(g,s(j))%MCD
    end
    s=s/g;
    Anew(i,:)=s(1:length(s)-1);
    bnew(i)=s(length(s));
end

dire=dire+"$$"+matrivetlate(B,"B",0)+"\qquad "+matrivetlate(N,"N",0)+"$$";
dire=dire+"$$"+matrivetlate(A,"A",0)+"\qquad "+matrivetlate(Ab,"A_B",0)+"\qquad "+matrivetlate(An,"A_N",0)+"$$";
dire=dire+"$$"+matrivetlate(Ainv,"A^{-1}_B",0)+"\qquad "+matrivetlate(Amod,"\tilde{A}",0)+"\qquad "+matrivetlate(bmod,"\tilde{b}",0)+"$$";


dire=dire+"\section{Piani di taglio}";
%mostro i piani di taglio
m=size(Amod,1);
n=size(Amod,2);
for i=1:m
    dire=dire+" $r="+r(i)+" \quad ";
    for j=1:n
        if(Amod(i,j)<0)
            dire=dire+latex(sym(Amod(i,j)))+"x_{"+N(j)+"}";
        else
            if(Amod(i,j)~=0)
                dire=dire+" + "+latex(sym(Amod(i,j)))+"x_{"+N(j)+"}";
            end
        end
    end
    dire=dire+" \geq "+latex(sym(bmod(i)));
    dire=dire+" $\\";
end

dire=dire+"\section{Vincoli di taglio}";

%mostro i vincoli di taglio
m=size(Anew,1);
n=size(Anew,2);
for i=1:m
    dire=dire+" $r="+r(i)+" \quad ";
    for j=1:n
        if(Anew(i,j)<0)
            dire=dire+latex(sym(Anew(i,j)))+"x_{"+B(j)+"}";
        else
            if(Anew(i,j)~=0)
                dire=dire+" + "+latex(sym(Anew(i,j)))+"x_{"+B(j)+"}";
            end
        end
    end
    dire=dire+" \leq "+latex(sym(bnew(i)));
    dire=dire+" $\\";
end

%aggiungo gli zeri delle variabili non di base
Aw=zeros(size(Anew,1),size(A,2));
Aw(:,B)=Anew;


%{
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
dire="\section{Piani di Taglio} ";

for j=1:length(B)
    dire=dire+"$\text{piano per }r="+string(B(j))+" \quad";
    for i=1:length(N)
        [ziza]=partefraz(Ati(j,i));
        Amod(j,i)=ziza;
        [frenk]=frazionamelo(ziza);
        if(ziza>=0)
            dire=dire+"+"+frenk+" x_"+string(N(i))+"  ";
        else
            dire=dire+frenk+" x_"+string(N(i))+"  ";
        end
    end
    [xr]=partefraz(x(B(j)));
    bmod(j,1)=xr;
    [fxr]=frazionamelo(xr);
    dire=dire+">= "+ fxr+"$\\ ";
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
dire=dire+"\section{Vincoli di Taglio}";
var=(1:length(B));

for j=1:length(B)
    dire=dire+"$\text{taglio per }r="+string(B(j))+" \quad";
    for i=1:length(N)
        [chepasa]=frazionamelo(tagl(j,i));
        if(tagl(j,i)>=0)
            dire=dire+"+"+chepasa+" x_"+string(var(i))+"  ";
        else
            dire=dire+chepasa+" x_"+string(var(i))+"  ";
        end
    end
    cheposa=frazionamelo(btagl(j));
    dire=dire+"<= "+ cheposa+"$ \\";
end

%stampalatex(dire);
%}
%stampalatex(dire);
end