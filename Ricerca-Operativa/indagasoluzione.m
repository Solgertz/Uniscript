function [Ab,An,bn,x,y,funz_ob,N,tipo] = indagasoluzione(c,A,b,base,tipologia,mostra)
%TEST OTTIMALITà
%   Devo trovare: soluzioni, ammissibilità, degenerabilità, ottimalità, valore
%   ottimo

%FUNZIONI USATE:stampalatex(stringa), matrivetlate(A,nome)

%FUNZIONI IN COMBO: simplesso()

%INPUT:
% - c,A,b:  sono le corrispondenti di una forma standard
% - base:  vettore riga della base  es: B=(1,3)  è [1,3]
% - tipologia:  1(primale), 2(il suo duale)
% - mostra: 0 (no), 1 (si) indica se stampare i risultati su latex

%ragionamento=ragionamento+"";
ragionamento=' ';%stringa che serve per stampare i calcoli in latex


if(tipologia<1 || tipologia>2)
    disp('Errore: tipologia vale 1(primale) o 2(duale)');
    return;
end

ragionamento=ragionamento+"\section{Ragionamento:} ";
ragionamento=ragionamento+"$$"+matrivetlate(A,"A",0)+"\quad "+matrivetlate(b,"b",0)+"$$ $$ "+matrivetlate(base,"Base",0)+"\quad ";

if(tipologia==1)
    N=(1:size(A,1));
    N(:,base)=[];
    %mi ricavo Ab e bb, An e bn
    Ab=zeros(size(A,1),size(A,2));
    bb=zeros(length(b),1);
    An=zeros(size(A,1),size(A,2));
    bn=zeros(length(b),1);
    %{
    for i=1:length(base)
        Ab(base(i),:)=A(base(i),:); %vi ricopio solo le righe di base
        bb(base(i),:)=b(base(i),:);
    end
    for i=1:length(N)
        An(N(i),:)=A(N(i),:); %vi ricopio solo le righe di base
        bn(N(i),:)=b(N(i),:);
    end
    Ab( ~any(Ab,2),: ) = [];%elimina righe di zeri
    bb( ~any(bb,2),: ) = [];

    An( ~any(An,2),: ) = [];%elimina righe di zeri
    bn( ~any(bn,2),: ) = [];
    %}

    Ab=A(base,:);
    bb=b(base);
    An=A(N,:);
    bn=b(N);
    %x=Ab^-1 bb
    ragionamento=ragionamento+matrivetlate(Ab,"A_b",0)+" \quad "+matrivetlate(bb,"b_b",0)+" \quad "+matrivetlate(An,"A_n",0)+" \quad "+matrivetlate(bn,"b_n",0)+" $$";
    
    lago=sym(inv(Ab));
    ragionamento=ragionamento+matrivetlate(lago,"A_b^{-1}",1);
    x=lago*bb;
    
    %y=cAb^-1,0
    ycon=c*sym(inv(Ab)); %versione senza zeri aggiunti
    y=zeros(1,size(A,1));
    for i=1:length(base)
        y(:,base(i))=ycon(:,i);
    end
    ragionamento=ragionamento+" $$"+matrivetlate(x,"x",0)+"\qquad"+matrivetlate(y,"y",0)+"$$ ";

    ragionamento=ragionamento+" \section{Test di Ottimalità}";
    %verifico ammissibilità X
    
    brutto=An*x;
    ragionamento=ragionamento+" $$"+matrivetlate(brutto,"A_n\cdot \overline{x}",0)+"\quad < ? \quad "+matrivetlate(bn,"b_n",0)+"$$";
    
    %Valori F.O
    gaus=c*x; 
    gauss=y*b;
    %ragionamento=ragionamento+"$V_x="+gaus+" \qquad V_y="+gauss+"$ \\";
    ragionamento=ragionamento+"$V_x="+latex(sym(gaus))+" \qquad V_y="+latex(sym(gauss))+"$ \\";


            %utilty calcoli
    sign1=0; %se è 1 la soluzione non è ammissibile
    sign2=0; %se è 1 la soluzione è degenere
    for i=1:length(bn)
        if(brutto(i)>bn(i))
            sign1=1;
        end
        if(brutto(i)==bn(i))
            sign2=1;
        end
    end
    if(sign1==1)
        ragionamento=ragionamento+" X non ammissibile \qquad ";
    else
        ragionamento=ragionamento+" X ammissibile \qquad ";
    end
    
    if(sign2==1)
        ragionamento=ragionamento+" X degenere ";
    else
        ragionamento=ragionamento+" X non degenere ";
    end
    ragionamento=ragionamento+" \\ ";

    signi1=0;
    signi2=0;
    %verfico ammissibilità Y
    for i=1: length(ycon)
        if(ycon(i)<0)
            signi1=1;
        end
        if(ycon(i)==0)
            signi2=1;
        end
    end

    if(signi1==1)
        ragionamento=ragionamento+" Y non ammissibile \qquad ";
    else
        ragionamento=ragionamento+" Y ammissibile \qquad ";
    end


    if(signi2==1)
        ragionamento=ragionamento+" Y degenere ";
    else
        ragionamento=ragionamento+" Y non degenere ";
    end
    ragionamento=ragionamento+" \\ ";

    %verifico se siamo all'ottimo
    coso=0;
    

    if(gaus~=gauss)
        coso=1;
    end
    if(signi1==0 && sign1==0 && coso==0)
        ragionamento=ragionamento+" Siamo all ottimo ";
    else
        ragionamento=ragionamento+" Non siamo all ottimo \\ ";
    end


%OUTPUT

    tipo=0;
    if(signi1==1 && sign1==0)
        tipo='p'; %SIMPLESSO PRIMALE
    else
        if(sign1==0 && signi1==0)%siamo all'ottimo
            tipo='o';
        else
            tipo='s';  %base da scartare
        end
    end
    funz_ob=gaus;


else %abbiamo già il duale
    N=(1:size(A,2));
    N(:,base)=[];

    %mi ricavo Ab e bb, An e bn
    Ab=zeros(size(A,1),size(A,2));
    cb=zeros(length(c),1);
    An=zeros(size(A,1),size(A,2));
    cn=zeros(length(c),1);
    mela=c';
    for i=1:length(base)
        Ab(:,base(i))=A(:,base(i)); %vi ricopio solo le colonne di base
        cb(base(i),:)=mela(base(i),:);
    end
    for i=1:length(N)
        An(:,N(i))=A(:,N(i)); %vi ricopio solo le colonne di base
        cn(N(i),:)=mela(N(i),:);
    end
    Ab( :,~any(Ab,1) ) = [];%elimina righe di zeri
    cb( ~any(cb,2),: ) = [];

    An( :,~any(An,1) ) = [];%elimina righe di zeri
    cn( ~any(cn,2),: ) = [];
    
    ragionamento=ragionamento+matrivetlate(Ab,"A_b",0)+" \quad "+matrivetlate(cb,"b_b",0)+" \quad "+matrivetlate(An,"A_n",0)+" \quad "+matrivetlate(cn,"b_n",0)+" $$";
   

    %x=Ab^-1 bb
    
    ustra=sym(inv(Ab));
    ragionamento=ragionamento+matrivetlate(ustra,"A_b^{-1}",1);
    x=sym(inv(Ab'))*cb;

    %y=cAb^-1,0
    
    ycon=ustra*b;
    ycon=ycon';
    y=zeros(1,size(A,2));
    for i=1:length(base)
        y(:,base(i))=ycon(:,i);
    end

    ragionamento=ragionamento+" $$"+matrivetlate(x,"x",0)+"\qquad"+matrivetlate(y,"y",0)+"$$ ";
    ragionamento=ragionamento+" \section{Test di Ottimalità}";
    
    %verifico ammissibilità X
    
    brutto=An'*x;
    ragionamento=ragionamento+" $$"+matrivetlate(brutto,"A_n\cdot \overline{x}",0)+"\quad < ? \quad "+matrivetlate(cn,"b_n",0)+"$$";

    gaus=b'*x; 
    gauss=y*c';
    ragionamento=ragionamento+"$V_x="+latex(sym(gaus))+" \qquad V_y="+latex(sym(gauss))+"$ \\";


    sign1=0; %se è 1 la soluzione non è ammissibile
    sign2=0; %se è 1 la soluzione è degenere
    for i=1:length(cn)
        if(brutto(i)>cn(i))
            sign1=1;
        end
        if(brutto(i)==cn(i))
            sign2=1;
        end
    end
   
    if(sign1==1)
        ragionamento=ragionamento+" X non ammissibile \qquad ";
    else
        ragionamento=ragionamento+" X ammissibile \qquad ";
    end

    if(sign2==1)
        ragionamento=ragionamento+" X degenere ";
    else
        ragionamento=ragionamento+" X non degenere ";
    end
    ragionamento=ragionamento+" \\ ";

    signi1=0;
    signi2=0;
    %verfico ammissibilità Y
    for i=1: length(ycon)
        if(ycon(i)<0)
            signi1=1;
        end
        if(ycon(i)==0)
            signi2=1;
        end
    end
    
    if(signi1==1)
        ragionamento=ragionamento+" Y non ammissibile \qquad ";
    else
        ragionamento=ragionamento+" Y ammissibile \qquad ";
    end

    if(signi2==1)
        ragionamento=ragionamento+" Y degenere ";
    else
        ragionamento=ragionamento+" Y non degenere ";
    end
    ragionamento=ragionamento+" \\ ";

    %verifico se siamo all'ottimo
    coso=0;
    

    
    if(gaus~=gauss)
        coso=1;
    end

    if(signi1==0 && sign1==0 && coso==0)
        ragionamento=ragionamento+" Siamo all ottimo ";
    else
        ragionamento=ragionamento+" Non siamo all ottimo \\ ";
    end


    %OUTPUT

    tipo=0;
    if(signi1==0 && sign1==1)
        tipo='d'; %SIMPLESSO DUALE
    else
        if(sign1==0 && signi1==0)%siamo all'ottimo
            tipo='o';
        else
            tipo='s';  %base da scartare
        end
    end
    bn=cn;
    funz_ob=gauss;
    

end

if(mostra==1)
    stampalatex(ragionamento);
end

end