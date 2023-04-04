function [T] = Hemilton(nodi,T,tipo,alb,piccolo)
%T va riempita come quella vista in tabella(non aggiungere colonne o righe)
%nodi è il numero di nodi totali
%tipo a (asimmetrico), tipo s (simmetrico)
%alb è il numero del k-albero
%piccolo è il nodo di partenza per la vs



%c è una matrice di archi
if(tipo=='a')%versione asimmetrica
%vi -> assegnamento non cooperativo    
    l=size(T,1);
    if(l==size(T,2)) %il problema si risolve con matrici quadrate
        
    c=zeros(1,l^2);
    
    Aeq=zeros(2*l,l^2);
    
    k=1;

    for i=1:l
        for j=k:k+l-1
            if(j-((i-1)*l)~=i)
                Aeq(i,j)=1;
            end
        end
        k=k+l;
    end
    
    k=1;
    kkk=1;
    for i=l+1:2*l
        for j=0:l-1
            m=k+j*l;
            if(m~=(kkk+((kkk-1)*l)))
                Aeq(i,m)=1;
            end
        end
        k=k+1;
        kkk=kkk+1;
    end
    
    
    beq=ones(2*l,1);
    LB=zeros(l^2,1);

    fumo=(1:l+1:l^2);
    j=1;
    for i=1:l^2
        if(i==fumo(j))
            LB(i)=-inf;
            j=j+1;
        end
    end

    UB=[];
    c=reshape(T',1,[]);
    A=[];
    b=[];
    
    k=1;
    
    
    [x,v]=linprog(c,A,b,Aeq,beq,LB,UB)
    
    
    disp("COMANDI");
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
    disp(scritto);
    
    disp('A=[]');
    disp('b=[]');
    disp('UB=[]');
    
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
    disp(scritto);
    
    scritto='c=[';
    
    for j=1:l^2
        scritto=[scritto,' '];
        scritto=[scritto,string(c(j))];
    end
    scritto=[scritto,']'];
    
    scritto=string(strjoin(scritto));
    disp(scritto);
    disp('[x,v]=linprog(c,A,b,Aeq,beq,LB,UB)');


    %output degli archi soluzione

    dimmi='Archi cammino minimo: ';
    k=1;
    for i=1:l
        for j=1:l
            %infd(k)=strcat(string(i),',',string(j));
            infd(k)=string(i)+","+string(j);
            k=k+1;
        end
    end

    for i=1:l^2
        if(x(i)==1)
            %dimmi=strcat(dimmi,'x',infd(i),'');
            dimmi=dimmi+"x"+infd(i)+"   ";
        end
    end
    disp(dimmi);
    
    else
        disp('la matrice non è quadrata!');
        return;
    end

    %la valutazione si trova con le toppe --> scrivi i nodi degli archi orizzontalmente


else
    %vi fatta con k albero
    
    %K=[24,21,20,9;0,23,40,13;0,0,30,25;0,0,0,28];

    %V=[0,24,21,20,9;24,0,23,40,13;21,23,0,30,25;20,40,30,0,28;9,13,25,28,0];
    %l=5;
    
    %ricavo la matrice simmetrica
    l=nodi;
    G=zeros(l);
    G(1:l-1,2:l)=T;
    G=G+G';
    T=G;
    
    
    kalbero=zeros(1,l);
    kalbero(1)=alb;
    k=1;
    val=zeros(1,l);
    inde=zeros(1,l);
    jinde=inde;
    vecchio=2;
    for i=1:l
        wufi=0;
        for j=1:l
            if((~ismember(i,kalbero)) && j~=kalbero(1) && T(i,j)~=0)
                if(val(k)==0 || T(i,j)<val(k))
                    val(k)=T(i,j);
                    inde(k)=i;
                    jinde(k)=j;
                    wufi=1;%significa che in questo nodo ho fatto un collegamento diretto
                end
            end
        end
        if(wufi==1)
            if(~ismember(inde(k),kalbero))
                kalbero(vecchio)=inde(k);
                vecchio=vecchio+1;
            end
            if(~ismember(jinde(j),kalbero))
                kalbero(vecchio)=jinde(k);
                vecchio=vecchio+1;
            end
            k=k+1;
        end
    end
    temp=0;
    for i=1:l
        if(T(kalbero(1),i)~=0 && (temp==0 || T(kalbero(1),i)<temp))
            temp=T(kalbero(1),i);
            inde(l-1)=i;
            jinde(l-1)=kalbero(1);
        end
    end
    val(l-1)=temp;
    
    temp=0;
    for i=1:l
        if(i~=inde(l-1) && T(kalbero(1),i)~=0 && (temp==0 || T(kalbero(1),i)<temp))
            temp=T(kalbero(1),i);
            inde(l)=i;
            jinde(l)=kalbero(1);
        end
    end
    
    val(l)=temp;


    %mostro archi e vi
    vi=0;
    dire="Gli archi del "+string(kalbero(1))+"-albero sono: ";
    for i=1:l
        dire=dire+"("+string(inde(i))+","+string(jinde(i))+")   ";
        vi=vi+val(i);
    end
    disp(dire);
    dire="La Vi="+string(vi);
    disp(dire);


    %vs
    %piccolo
    i=1;
    pic=piccolo;
    tontolo=zeros(1,l);
    cattivi=zeros(1,l);
    while i<=l
        for j=1:l
            if(T(piccolo,j)~=0 && (~ismember(j,cattivi)) && (tontolo(i)==0 || T(piccolo,j)<tontolo(i)))
                tontolo(i)=T(piccolo,j);
                inde(i)=piccolo;
                jinde(i)=j;
            end
        end
        cattivi(i)=inde(i);
        piccolo=jinde(i);
        i=i+1;
    end

    inde(l)=jinde(l-1);
    jinde(l)=inde(1);
    tontolo(l)=T(inde(l),jinde(l));

    vs=0;
    dire="Gli archi del nodo più vicino da "+string(pic)+" sono: ";
    for i=1:l
        dire=dire+"("+string(inde(i))+","+string(jinde(i))+")   ";
        vs=vs+tontolo(i);
    end
    disp(dire);
    dire="La Vs="+string(vs);
    disp(dire);


end
end