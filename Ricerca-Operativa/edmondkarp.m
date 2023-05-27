function [cammino,Ns,Nt,eccomi] = edmondkarp(start,dimp,Gx)
%calcola flusso aumentante


p=-ones(1,dimp);
p(start)=0; Q=start;t=dimp;
cammino=[];Ns=[];Nt=[];
eccomi=" ";
while(~isempty(Q))
    eccomi=eccomi+"$$"+matrivetlate(Q,"Q",0)+"\quad "+matrivetlate(p,"p",0)+"$$";
    i=Q(1);Q(1)=[]; %estraggo primo elemento

    if(~isempty(cercariga(Gx(:,[1:2]),[i,t])))
        p(t)=i;
        break;
    end
    indicioso=find(Gx(:,1)==i);
    Gristretto=Gx(indicioso,[1:2]);
    for j=1:size(Gristretto,1)
        J=Gristretto(j,2);
        if(p(J)==-1)
            p(J)=i;
            Q=[Q,J];
        end
    end

end

if(isempty(Q))
    eccomi=eccomi+"$$Q=\varnothing \quad "+matrivetlate(p,"p",0)+"$$";
end
%NORMALIZZAZIONE cammino aumentante/taglio

i=t;
if(p(i)~=-1) %controllo se esiste un cammino umentante
    listcam=[];
    while(p(i)~=0)
        listcam=[listcam,i];
        padre=p(i);
        us=[padre;i];
        cammino=[cammino,us];
        i=padre;
    end
    listcam=[listcam,start];
    listcam=flip(listcam);
    eccomi=eccomi+matrivetlate(listcam,"\text{Cammino aumentante}",1);
    cammino=cammino';
    cammino=sortrows(cammino);
else
    for i=1:length(p)
        if(p(i)==-1)
            Nt=[Nt,i];
        else
            Ns=[Ns,i];
        end
    end
    eccomi=eccomi+"$$"+matrivetlate(Ns,"N_s",0)+"\quad "+matrivetlate(Nt,"N_t",0)+"$$";
end

end