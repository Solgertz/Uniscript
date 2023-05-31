function [dire,situa,Tnew,Lnew,Unew] = passoSimplessorete(T,L,U,costiU,costiL,info,xtot)


%OUTPUT
%-situa:   0 se flusso -Inf   altrimenti 1 (e la partizione è stata aggiornata)

Tnew=T;Lnew=L;Unew=U;

dire="\section{Primo passo del Simplesso}";

%CALCOLO ARCO ENTRANTE
%{
minL=3;
for i=1:size(L,2)
    if(costiL(i)<0 && costiL(i)<minL)
        minL=costiL(i);
        indL=i;
    end
end
minU=Inf;
for i=1:size(U,2)
    if(costiU(i)>0 && costiU(i)<minU)
        minU=costiU(i);
        indU=i;
    end
end

if(minL~=3 && minU~=Inf)%minimo secondo l'ordine lessicografico
    if(L(1,indL)<U(1,indU)) 
        minimo=minL;
        stato=0;
    else
        if(L(1,indL)>U(1,indU))
            minimo=minU;
            stato=1;
        else
            if(L(2,indL)<U(2,indU))
                minimo=minL;
                stato=0;
            else
                minimo=minU;
                stato=1;
            end
        end
    end
else
    if(minL~=3)
        minimo=minL;
        stato=0;
    else
        minimo=minU;
        stato=1;
    end
end
%}

minL=3;
for i=1:size(L,2)
    if(costiL(i)<0)%primo negativo in ordine lessicografico
        minL=costiL(i);
        indL=i;
        break;
    end
end
minU=Inf;
for i=1:size(U,2)
    if(costiU(i)>0)  %primo positivo in ordine lessicografico
        minU=costiU(i);
        indU=i;
        break;
    end
end

if(minL~=3 && minU~=Inf)%minimo secondo l'ordine lessicografico
    if(L(1,indL)<U(1,indU)) 
        minimo=minL;
        stato=0;
    else
        if(L(1,indL)>U(1,indU))
            minimo=minU;
            stato=1;
        else %sono sicuramente in = per primo indice
            if(L(2,indL)<U(2,indU))
                minimo=minL;
                stato=0;
            else
                minimo=minU;
                stato=1;
            end
        end
    end
else
    if(minL~=3)
        minimo=minL;
        stato=0;
    else
        minimo=minU;
        stato=1;
    end
end

if(stato==0)
    pq=L(:,indL);
    dire=dire+"L'arco entrante per L vincente è $"+matrivetlate(pq,"(p,q)",0)+"$\\";
else
    pq=U(:,indU);
    dire=dire+"L'arco entrante per U vincente è $"+matrivetlate(pq,"(p,q)",0)+"$\\";
end



%CALCOLO CICLO C+ C-
    %stato=0 il senso è pq, altrimenti è contrario
astr=[T,pq];
astruso=graph(astr(1,:),astr(2,:));
C=allcycles(astruso);
C=cell2mat(C);
ordinato=[]; %contiene gli archi non direzionati del ciclo
for i=1:length(C)
    if(i==length(C))
        ordinato=[ordinato,[C(i);C(1)]];
    else 
        ordinato=[ordinato,[C(i);C(i+1)]];
    end
end

fake=astr;
for i=1:size(ordinato,2)
    ordinato(:,i)=sort(ordinato(:,i));
end
for i=1:size(fake,2)
    fake(:,i)=sort(fake(:,i));
end

fake2=[];
for i=1:size(ordinato,2)
    for j=1:size(fake,2)
        if(ordinato(:,i)==fake(:,j))
            s=j;
        end
    end
    fake2=[fake2,s];
end
assurdo=astr(:,fake2); %archi direzionati del ciclo
assurdissimo=fake(:,fake2); %archi non direzionati del ciclo

figure;
eccomi=digraph(assurdo(1,:),assurdo(2,:));
plot(eccomi);
title("Ciclo C");

start=pq(1);
i=find(C==start);
if(i==length(C)) %determino il senso di scorrimento del ciclo
    if(C(1)==pq(2))
        senso=true; %orario
    else
        senso=false; %antiorario
    end
else
    if(i==1)
        if(C(length(C))==pq(2))
            senso=false;
        else
            senso=true;
        end
    else  %caso interno
        if(C(i+1)==pq(2))
            senso=true;
        else
            senso=false;
        end
    end
end

if(stato==1)  %poichè si deve andare nel senso opposto a U
    senso=~senso;
end

if(senso)
    dire=dire+"Verso ORARIO $\curvearrowright$ \\";
else
    dire=dire+"Verso ANTIORARIO $\curvearrowleft$\\";
end

Cp=[];
Cm=[];

while((isempty(Cp) && isempty(Cm)) || C(i)~=start) 
    %gestiamo lo scorrimento ciclico
    if(senso)
        if(i==length(C))
            succ=1;
        else
            succ=i+1;
        end
        %ricerca dell'elemento
        ve=[C(i);C(succ)];      %arco con direzione rispettante il senso
        vect=sort(ve);         
        %[~,austria]=ismember(assurdissimo',vect','rows');
        %austria=find(austria);
        austria=cercacolonna(assurdissimo,vect);
        provola=assurdo(:,austria);%arco con direzione che effettivamente ha
        if(isequal(ve,provola))
            Cp=[Cp,provola];
        else
            Cm=[Cm,provola];
        end

        if(i==length(C))
            i=1;
        else
            i=i+1;
        end
    else
        if(i==1)
            succ=length(C);
        else
            succ=i-1;
        end
        %ricerca dell'elemento
        ve=[C(i);C(succ)];      %arco con direzione rispettante il senso
        vect=sort(ve);         
        %[~,austria]=ismember(assurdissimo',vect','rows');
        %austria=find(austria);
        austria=cercacolonna(assurdissimo,vect);
        provola=assurdo(:,austria);%arco con direzione che effettivamente ha
        if(isequal(ve,provola))
            Cp=[Cp,provola];
        else
            Cm=[Cm,provola];
        end
        if(i==1)
            i=length(C);
        else
            i=i-1;
        end
    end
end

dire=dire+" $"+matrivetlate(Cp,"C^{+}",0)+"\quad "+matrivetlate(Cm,"C^{-}",0)+" $\\";

%CALCOLO DEI THETA
tetap=Inf;
tetam=Inf;
teta=Inf;

insp=[];
for i=1:size(Cp,2)
    for j=1:size(info,1)
        if(isequal(Cp(:,i)',info(j,[1,2])))
            insp=[insp,info(j,4)-xtot(j)];
        end
    end
end
if(~isempty(insp))
    tetap=min(insp);
end

insm=[];
for i=1:size(Cm,2)
    for j=1:size(info,1)
        if(isequal(Cm(:,i)',info(j,[1,2])))
            insm=[insm,xtot(j)];
        end
    end
end

if(~isempty(insm))
    tetam=min(insm);
end

teta=min(tetap,tetam);

situa=1;
if(teta==Inf)
    situa=0;
    dire=dire+"$\theta=+\infty$  quindi il flusso di costo ottimo ha valore $-\infty$";
    return;
end

dire=dire+"$"+matrivetlate(tetap,"\theta^{+}",0)+"\quad "+matrivetlate(tetam,"\theta^{-}",0)+"\quad "+matrivetlate(teta,"\theta",0)+"$\\";

%CALCOLO ARCO USCENTE
xfin=xtot;
insperme=[];
for i=1:size(Cp,2)
    for j=1:size(info,1)
        if(isequal(Cp(:,i)',info(j,[1,2])))
            if(info(j,4)-xtot(j)==teta)
                insperme=[insperme,Cp(:,i)];
            end
            xfin(j)=xfin(j)+teta;
        end

    end
end

insperte=[];
for i=1:size(Cm,2)
    for j=1:size(info,1)
        if(isequal(Cm(:,i)',info(j,[1,2])))
            if(xtot(j)==teta)
                insperte=[insperte,Cm(:,i)];
            end
            xfin(j)=xfin(j)-teta;
        end
    end
end

    %minimo dell'ordine lessicografico
totins=[insperme,insperte];
totins=sortrows(totins');
rs=totins(1,:);rs=rs';

dire=dire+"L'arco uscente è $"+matrivetlate(rs,"(r,s)",0)+"$\\";
%AGGIORNAMENTO TRIPARTIZIONE

if(~isempty(cercacolonna(L,pq)))
    if(~isempty(cercacolonna(Cp,rs)))
        if(isequal(pq,rs))
            i=cercacolonna(L,pq);
            Lnew(:,i)=[];
            
            Unew=[Unew,pq];
        else
            i=cercacolonna(T,rs);
            Tnew(:,i)=[];
            Tnew=[Tnew,pq];
            
            i=cercacolonna(L,pq);
            Lnew(:,i)=[];

            Unew=[Unew,rs];

        end
    else
        i=cercacolonna(T,rs);
        Tnew(:,i)=[];
        Tnew=[Tnew,pq];
        
        i=cercacolonna(L,pq);
        Lnew(:,i)=[];
        Lnew=[Lnew,rs];
    end
else
    if(~isempty(cercacolonna(Cm,rs)))
        if(isequal(pq,rs))
            Lnew=[Lnew,pq];

            i=cercacolonna(U,pq);
            Unew(:,i)=[];
        else
            i=cercacolonna(T,rs);
            Tnew(:,i)=[];
            Tnew=[Tnew,pq];

            Lnew=[Lnew,rs];

            i=cercacolonna(U,pq);
            Unew(:,i)=[];
        end
    else
        i=cercacolonna(T,rs);
        Tnew(:,i)=[];
        Tnew=[Tnew,pq];
        
        i=cercacolonna(U,pq);
        Unew(:,i)=[];
        Unew=[Unew,rs];
    end
end

dire=dire+"La nuova tripartizione è: $"+matrivetlate(Tnew,"T",0)+"\quad "+matrivetlate(Lnew,"L",0)+"\quad "+matrivetlate(Unew,"U",0)+"$\\";
dire=dire+matrivetlate(xfin,"x_{\text{finale}}",1);

end