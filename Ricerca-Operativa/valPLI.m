function [xs,vs,xi,vi] = valPLI(c,A,b,simb,tipo)

%FUNZIONI USATE: matrixadder,unsolovalore,gomory,approssima(),ricavBase()


%partendo dal primale standard (o quasi)

format rat;
    %Vs
if(tipo=='p')
    c=-c;       %trasformo in Minimo
end
    Aeq=[];
    beq=[];
    LB=zeros(length(c),1);%nei minimi LB>=0 almeno
    UB=inf(length(c),1);
    m=size(A,1);n=size(A,2);j=1;k=1;t=1;
    for i=1:m
        [sit,burp]=unsolovalore(A(i,:));
        if((sit==1 && simb(i)==0) || sit==0) %VINCOLI
            if(simb(i)==0)    %=
                Augu(t,:)=A(i,:);
                bugu(t)=b(i);
                Aeq(j,:)=A(i,:);
                beq(j)=b(i);
                j=j+1;
                t=t+1;
            else
                if(simb(i)==1)%>= diventano <=
                    Augu(t,:)=-A(i,:);
                    bugu(t)=-b(i);
                    nA(k,:)=-A(k,:);
                    nb(k)=-b(k);
                else
                    Augu(t,:)=A(i,:);
                    bugu(t)=b(i);
                    nA(k,:)=A(k,:);
                    nb(k)=b(k);
                end
                simbugu(t)=simb(i); 
                t=t+1;
                k=k+1;
            end
        else        %BOUND
            if(A(i,burp)<0)
                A(i,burp)=-A(i,burp);
                b(i)=-b(i);
                simb(i)=-simb(i);
            end
            if(simb(i)==1) %LB di x_i>=2
                LB(burp,1)=b(i)/A(i,burp);
            else            %UB di x_i<=5
                UB(burp,1)=b(i)/A(i,burp);
            end
        end
    end
    [x,v]=linprog(c,nA,nb',Aeq,beq,LB,UB);
    %calcolo la soluzione con inlinprog
    I=1:length(c);
    [xin,vin]=intlinprog(c,I,nA,nb',Aeq,beq,LB,UB);

    if(tipo=='p')
        %approssimazioni per difetto
        vs=approssima(-v,0);
        xs=x;
    
        xi=approssima(x,0); 
        vi=-c*xi;
        vi=approssima(vi,0);
        vin=-vin;
    else
        %approssimazione per eccesso
        vi=approssima(v,1);
        xi=x;
        xs=approssima(x,1);
        vs=c*xs;
        vs=approssima(vs,1);
    end

    %GOMORY

    %Conversione vincoli

    for i=1:size(Augu,1)
        if(simbugu(i)~=0)
             %CONVERSIONE IN = dei vincoli
             %aggiungo var di resto
             zam=zeros(size(Augu,1),1);
             zam(i,1)=1;
             [Augu]=matrixadder(Augu,zam,2);
        end
    end

    %max,Augu,x>=
    LB=zeros(size(Augu,2),1);
    UB=inf(size(Augu,2),1);
    cugu=c;
    cugu((size(A,2)+1):(size(Augu,2)))=0; %var di scarto (essendo di minimo si usano variabili di slack)
    [izi,bizi]=linprog(cugu,[],[],Augu,bugu',LB,UB);

    [base,N]=ricavBase(Augu,bugu',izi,'d');

    [Ag,bg,dire] = gomory(Augu,N,base,izi,bugu');
    dire=dire+" \section{Valutazioni} $$ "+matrivetlate(xi,"x_i",0)+ "\quad "+matrivetlate(xs,"x_s",0)+"\qquad "+latex(sym(vi))+"\leq v \leq"+latex(sym(vs))+" $$";
    
    
    %calcolo la soluzione con Gomory
    
    [xg,vg]=linprog(cugu,Ag,bg,Augu,bugu',LB,UB);
    if(tipo=='p')
        vg=approssima(-vg,0);
    else
        vg=approssima(vg,1);
    end
    dire=dire+" \section{Riprove} $$ \text{Soluzione intlinprog: }"+matrivetlate(xin,"x_{int}",0)+"\qquad "+matrivetlate(vin,"v_{int}",0)+"$$";
    dire=dire+" $$\text{Soluzione con gomory: }"+matrivetlate(xg,"x_{g}",0)+"\qquad "+matrivetlate(vg,"v_{g}",0)+"$$";

    stampalatex(dire);

end