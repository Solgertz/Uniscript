
clear;
clc;

%{
% Definizione della funzione
funzione = @(x) x(1)^2 + x(2)^2 +x(1)*x(2); % Esempio di una funzione a due variabili

% Vettore di input
x = [2, 3]; % Esempio di un vettore di input

% Calcolo della soluzione
soluzione = funzione(x);

% Visualizzazione della soluzione
disp(soluzione);
%}


% Definizione della funzione anonima
funzione_anonima = @(x) 0.5*x(1)^2+x(2)^2-2*x(1)*x(2)+x(1);

% Punto in cui calcolare il gradiente
punto = [0, 1];

% Creazione delle variabili simboliche
syms x y

% Conversione delle variabili simboliche in un vettore
variabili = [x, y];

% Conversione della funzione anonima in una funzione simbolica
funzione_simbolica = symfun(funzione_anonima(variabili), variabili);

% Calcolo del gradiente
gradiente_simbolico = gradient(funzione_simbolica, variabili);

% Valutazione del gradiente nel punto specificato
gradiente = double(subs(gradiente_simbolico, variabili, punto));

% Visualizzazione del gradiente
disp(gradiente);




%{
T=[1,2,3,4;2,3,5,5];
ET=[1,-1,0,0;0,1,-1,0;0,0,0,-1;0,0,1,1];
Falso=ET;
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
disp(ET);
ordinarc=[ordinarc,albe];

out=zeros(dim2,dimAlb+1);
    
for i=1:(dimAlb+1)
    o1=find(ordine==ordinarc(1,i));
    o2=find(ordine==ordinarc(2,i));
    out(o1,i)=-1;
    out(o2,i)=1;
end

disp(out);

%}
%{
T=[1,2,3,4;2,3,5,5];
ET=[1,-1,0,0;0,1,-1,0;0,0,0,-1;0,0,1,1];
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
disp(ET);
ordinarc=[ordinarc,albe];

out=zeros(dim2,dimAlb+1);
    
for i=1:(dimAlb+1)
    o1=find(ordine==ordinarc(1,i));
    o2=find(ordine==ordinarc(2,i));
    out(o1,i)=-1;
    out(o2,i)=1;
end

disp(out);
%}



syms x1 x2
f = - 2*x1^2 - x2^2 + 4*x1 + 2*x2
A = [	
-1  0; 
0 -1; 
1  2;
-2 -1; 
]
b = [0;0;8;-2]
xk = [0;3]
iter = 1

res = provafrank(f,A,b,xk,iter)
