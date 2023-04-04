function [basef] = prova(A,Ab,An,b,bn,c,x,y,base,N,tipo)
% fa uno step del simplesso

l=length(base);
%base,x,y,fo,h,rapporti,k
if(tipo=='p')
    
    W=-(inv(Ab));%1,2 -> 3,5 della base
    lisa=y;
    lisa(N)=[];
    P=1;
    for i=1:l
        if(P==1 && lisa(i)<0)
            h=base(i);
            hprima=i;
            P=P+1;
        end
    end
    Wparticolare=W(:,hprima);
    ra=An*Wparticolare;%6*2 per 2*1 = 6*1
    %An*w
    j=1;
    for i=1:length(An)
        if (ra(i,:)>0)
            rindex(j)=N(i);%mi salvo gli indici rispetto a N
            rapper(j)=ra(i,:);%mi salvo i valori
            j=j+1;
        end
    end
    j=j-1;%numero di moltiplicatori
    for i=1:j
        r(i)=(b(rindex(i))-(A(rindex(i),:)*(x)))/rapper(i);
    end

    
    [F,k]=min(r);
    k=rindex(k);

    for i=1:length(base)
        if(base(i)~=h)
            vero=base(i);
        end
    end
   
else

    V=(An*x)>bn;
    j=1;
    for i=1:length(V)
        if (j==1 && V(i)==1)
            k=N(i);
            j=j+1;
        end
    end


    W=-(inv(Ab));%1,2 -> 3,5 della base
    Ak=A(k,:);
    veh=Ak*W;%1*2 per 2*2=1*2


    j=1;
    for i=1:length(veh)
        if (veh(:,i)<0)
            disel(j)=veh(i);
            rindex(j)=base(i);%mi salvo gli indici rispetto
            j=j+1;
        end
    end
    if(j==1)%fo(min)=-inf
        disp('fo(min)=-inf');
    end
    
    j=j-1;%numero di moltiplicatori
    for i=1:j
        r(i)=(-y(rindex(i)))/disel(i);
    end

    
    [F,h]=min(r);%il primo minimo
    h=rindex(h);

    for i=1:length(base)
        if(base(i)~=h)
            vero=base(i);
        end
    end
   
end


basef=[k,vero];

dire='la nuova base: B={';
dire=[dire,string(basef(1))];
dire=[dire,','];
dire=[dire,string(basef(2))];
dire=[dire,'}'];
dire=string(strjoin(dire));
disp(dire);

dire='h=';
dire=[dire,string(h)];
dire=[dire,'   k='];
dire=[dire,string(k)];
dire=string(strjoin(dire));
disp(dire);

dire='';
for i=1:j
    dire=[dire,'r'];
    dire=[dire,string(rindex(i))];
    dire=[dire,'='];
    [coeff]=frazionamelo(r(i));
    dire=[dire,coeff];
    dire=[dire,'='];
    dire=[dire,string(r(i))];
    dire=[dire,'  '];
end
dire=string(strjoin(dire));
disp(dire);




end