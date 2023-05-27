function [dire,albero] = dijsktra(info,nodi,r)


%Controllo costi (colonna 3) : devono essere tutti positivi
for i=1:size(info,1)
    if(info(i,3)<0)
        dire="Non si usa Dijsktra perchè i costi devono essere positivi";
        albero=[];
        return;
    end
end


%start
p=-ones(1,nodi);p(r)=0; 
t=Inf*ones(1,nodi);t(r)=0;
U=[1:nodi];
nomi=num2cell(1:nodi);

dire="\section{Cammini minimi:} $$"+matrivetlate(U,"N",0)+"\quad "+matrivetlate(p,"p",0)+"\quad "+matrivetlate(t,"\pi",0)+" $$";
f=[];
fake=t;
while(~isempty(U))
    [~,u]=min(fake);
    elem=find(info(:,1)==u);
    if(isempty(elem))
        U(U==u)=[];
        f=[f,u];
        fake(f)=Inf;
        continue;
    end
    uv=info(elem,:);
    for i=1:size(uv,1)
        v=uv(i,2);
        if(t(v)>t(u)+uv(i,3))
            p(v)=u;
            t(v)=t(u)+uv(i,3);
        end
    end   
    dire=dire+"$$"+matrivetlate(U,"N",0)+"\quad "+matrivetlate(p,"p",0)+"\quad "+matrivetlate(t,"\pi",0)+" $$";
    U(U==u)=[];
    f=[f,u];
    fake=t;
    fake(f)=Inf;    
end

%stampalatex(dire);
albero = digraph(p(p~=0),find(p));
albero=albero.Edges;
albero=table2array(albero);
figure;
treeplot(p);
[x,y] = treelayout(p);
text(x + 0.02,y,nomi);
title("Flusso Minimo secondo Dijsktra");

end