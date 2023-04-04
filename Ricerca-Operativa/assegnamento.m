function [T] = assegnamento(T,rifiuti)
clc
% FUNZIONI USATE: linprog

% INPUT:
% - T è la matrice del problema
% - rifiuti: vettore 2*n che indica gli indici i,j delle "persone che
% rifiutano lavori"  (normalmente è vuota)

%Vale per Cooperativo e non perchè hanno soluzioni a valori interi (PLI è un caso particolare di PL)
    %nc -> {} -> PLI
    %c -> []  -> PL


    %CASO PARTICOLARE -> per i calcoli usare 2 perchè non da risultato
    %vuoto
%1)rifiuto di un lavoro con possibilità: x_ij=0 come vincolo in più
%2)rifiuto di un lavoro senza possibilità: aggiungo c_ij=valore_altissimo (in caso non ci siano possibilità, si va in perdita)

ragionamento="$$"+matrivetlate(T,"T",0)+"\qquad "+matrivetlate(rifiuti,"rifiuti",0)+"$$";


l=size(T,1);
if(l==size(T,2)) %il problema si risolve con matrici quadrate
    
c=zeros(1,l^2);

Aeq=zeros(2*l,l^2);

k=1;
for i=1:l
    for j=k:k+l-1
        Aeq(i,j)=1;
    end
    k=k+l;
end

k=1;
for i=l+1:2*l
    for j=0:l-1
        m=k+j*l;
        Aeq(i,m)=1;
    end
    k=k+1;
end


beq=ones(2*l,1);
LB=zeros(l^2,1);
UB=[];
c=reshape(T',1,[]);
A=[];
b=[];

k=1;

% RIFIUTO DI LAVORI
rifui=size(rifiuti,1);
rifuj=size(rifiuti,2);
if (rifui>0 && rifuj==2)
    ragionamento=ragionamento+" Siccome ci sono lavoratori che rifiutano i progetti, bisogna impostare $C_{ij}$ molto elevati per permettere la risoluzione con Linprog \\ ";
    for i=1:rifui
        c(rifiuti(i,1)+((rifiuti(i,2)*size(T,2))-1))=10^7;
    end
end
% c11 c12 c13 c14 c21 c22 c33 c34 c31 c32 c33 c34...
% riuj mi accede a i,j di rifiuti
% i+((j*size(T,2))-1)
[x,v]=linprog(c,A,b,Aeq,beq,LB,UB);

ragionamento=ragionamento+" $$"+matrivetlate(x,"x",0)+"\qquad"+matrivetlate(v,"v",0)+"$$ ";


if(v>=10^7)
    ragionamento=ragionamento+" Problema Impossibile \\ ";
end

% COMANDI A SCHERMO
ragionamento=ragionamento+"\section{Comandi:} ";
scritto='Aeq=[';
for i=1:2*l
    for j=1:l^2
        scritto=[scritto,' '];
        scritto=[scritto,string(Aeq(i,j))];
    end
    if i~=2*l
        scritto=[scritto,';'];
    end
end
scritto=[scritto,']'];

scritto=string(strjoin(scritto));
ragionamento=ragionamento+scritto + " \\ ";

ragionamento=ragionamento+" A=[\quad] \\ ";
ragionamento=ragionamento+" b=[\quad] \\ ";
ragionamento=ragionamento+" UB=[\quad]\\ ";

scritto='LB=[';

for j=1:l^2
    scritto=[scritto,string(LB(j))];
    if(j~=l^2)
        scritto=[scritto,';'];
    end
end
scritto=[scritto,']'];

scritto=string(strjoin(scritto));
disp(scritto);


scritto='beq=[';

for j=1:2*l
    scritto=[scritto,' '];
    scritto=[scritto,string(beq(j))];
end
scritto=[scritto,']'];

scritto=string(strjoin(scritto));
ragionamento=ragionamento+scritto + " \\ ";

scritto='c=[';

for j=1:l^2
    scritto=[scritto,' '];
    scritto=[scritto,string(c(j))];
end
scritto=[scritto,']'];

scritto=string(strjoin(scritto));
ragionamento=ragionamento+scritto + " \\ ";
ragionamento=ragionamento+" \text{ [x,v]=linprog(c,A,b,Aeq,beq,LB,UB) } \\ ";

    
else
    disp('la matrice non è quadrata!');
    return;
end

    stampalatex(ragionamento);

end