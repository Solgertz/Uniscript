function [T] = BeBHem(nodi,T,tipo,alb,piccolo)
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
    

end
end