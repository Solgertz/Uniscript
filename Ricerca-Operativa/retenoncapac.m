function [E] = retenoncapac(tipo,v,vincoli,bilanci,costi)
%v può essere il potenziale o la x
%tipo=1 verifica che la x sia ammissibile, di base, degenere, ottima
%tipo=2 verifica che pi sia ...
%vincoli è un vettore in ordine lessicografico degli archi orientati
%bilanci sono i bilanci in oridne di nodo
%costi sono in ordine di archi lessicografico

pi=vincoli(1:2:length(vincoli));
pf=vincoli(2:2:length(vincoli));

nodi=max(vincoli);
archi=length(vincoli)/2;

E=zeros(nodi,archi);


for i=1:nodi
    for j=1:archi
        if(i==pi(j))
            E(i,j)=-1;
        end
        if(i==pf(j))
            E(i,j)=1;
        end
    end
end

if(tipo==1)
    %controllo se è ammissibile
    segn=0;
    for i=1:length(v)
        if(v(i)<0)
            segn=1;
        end
    end


    
    %calcolo il potenziale associato
    pig=zeros(1,length(bilanci));
    visitati=zeros(1,length(v)+1);
    visitati(1)=1;
    counter=1;
    while counter<length(bilanci)
        for i=1:length(v)
            if(v(i)~=0)%sicuramente in base (nel caso degenere, potrebbe buggarsi)
                cs1=ismember(visitati,pf(i));
                cs2=ismember(visitati,pi(i));
                cs1=sum(cs1);
                cs2=sum(cs2);
                if(cs1 || cs2)
                    if(~ismember(visitati,pf(i)))
                        pig(pf(i))=costi(i)+pig(pi(i));
                        visitati(i+1)=pf(i);
                        counter=counter+1;
                    end
                    if(~ismember(visitati,pi(i)))
                        pig(pi(i))=pig(pf(i))-costi(i);
                        visitati(i+1)=pi(i);
                        counter=counter+1;
                    end
                end
            end
        end
    end
    

    disp("Potenziale: ");
    disp(pig);
    %calcolo il potenziale ottimo
    A=E';
    b=-bilanci';
    c=costi';
    Aeq=[];
    beq=[];
    LB=zeros(length(b),1);
    UB=[];
    [pigreco,valreid]=linprog(b,A,c,Aeq,beq,LB,UB);
    disp("Potenziale Ottimo:");
    disp(pigreco');

    %CREO IL GRAFO
        %cerco archi in base
    j=1;
    k=1;
    for i=1:length(pi)
        if(v(i)~=0)
            ni(j)=pi(i);
            nf(j)=pf(i);
            j=j+1;
        else
            nni(k)=pi(i);
            nnf(k)=pf(i);
            k=k+1;
        end
    end

    GIU=graph(ni,nf);
    GAU=digraph(ni,nf);


    %Di Base ? Non devono essere sottocicli o distaccamenti

    %cerco cicli
    ciclare=0;
    if(hascycles(GIU))
        ciclare=1;
    end

        %guardo se tutti i nodi sono toccati
    tuttounito=0;
    events={'startnode'};
    berska=bfsearch(GIU,1,events,'Restart',true);   

    if(length(berska)==1)
        tuttounito=1; 
    end

        

    
    %calcolo costi ridotti
    %cori=zeros(1,length(v));
    k=1;
    nonott=0;
    for i=1:length(v)
        if(v(i)==0)
            cori(k)=pig(pf(i))-pig(pi(i))+costi(i);
            corii(k)=string(pi(i))+","+string(pf(i));
            
            if(cori(k)<0)
                nonott=1;
            end
            k=k+1;
        end
    end
    
    if(segn==1)
        disp('Ammissibilita: No');
    else
        disp('Ammissibilita: Si')
    end
    
    nondib=0;
    %dico se è di base
    if(ciclare==0 && tuttounito==1)
        disp('Base: Si');
    else
        if(ciclare==0)
            disp('Base: potrebbe essere base degenere, cercare archi in L')
            nondib=2;
        else
            disp('Base: No');
            nondib=1;
        end
    end

    if(nondib==2)
        disp('Degenere: controlla se potrebbe essere di base, aggiungendo arco L');
    else
        disp('Degenere: No');
    end
    
    
    if(nondib==1)
        disp('Ottimo: No');
    else
        if(nondib==0)
            if(nonott==0)
                disp('Ottimo: Si');
            else
                disp('Ottimo: No');
            end
        end
        if(nondib==2)
            disp('Ottimo: potrebbe esserlo se base degenere');
        end
    end

    disp("   ");
    disp("Costi ridotti:");
    disp(corii);
    disp(cori);
    
    plot(GAU);
end
if(tipo==2)
    disp('Calcola tutti i possibili costi ridotti');
    

     %calcolo costi ridotti
    %cori=zeros(1,length(v));
    k=1;
    j=1;
    nonamm=0;
    albi=0;
    albf=0;
    for i=1:length(pf)
        
        cori(k)=v(pf(i))-v(pi(i))+costi(i);
        corii(k)=string(pi(i))+","+string(pf(i));
            
        if(cori(k)<0)
            nonamm=1;
        end

        if(cori(k)==0)
            albi(j)=pi(i);
            albf(j)=pf(i);
            j=j+1;
        end
        k=k+1;
    end

    %stampo tutti i costi
    disp('Tutti i possibili costi ridotti');
    disp(cori);
    disp(corii);

    %caso peggiore possibile -> non ammissibile, non di base, nulla di
    %nulla
    if(length(albi)<length(v))%non si può costruire una copertura
        nonamm=1;
        dibase=0;
        didegen=0;

    else

    

        %caso non degenere
        
        GIU=graph(albi,albf);
        GAU=digraph(albi,albf);
    
    
        %Di Base ? Non devono essere sottocicli o distaccamenti
    
        %cerco cicli
        ciclare=0;
        if(hascycles(GIU))
            ciclare=1;
        end
    
            %guardo se tutti i nodi sono toccati
        tuttounito=0;
        events={'startnode'};
        berska=bfsearch(GIU,1,events,'Restart',true);   
    
        if(length(berska)==1)
            tuttounito=1; 
        end
        sbannami=0;
        dibase=0;
        didegen=0;
        if(ciclare==0 && tuttounito==1)
            dibase=1;
        else
            sbannami=1;
            if(tuttounito==1)
             
        %devono esserci almeno archi pari al numero di nodi
                flaggalo=0;
                for j=1:(length(albi)-length(v))
                    if(flaggalo==0)
                       for i=0:length(albi)
                            if(flaggalo==0)
                                auxi=albi;
                                auxf=albf;
                                auxi(1,length(auxi)-j+1-i:length(auxi)-i)=[];
                                auxf(1,length(auxf)-j+1-i:length(auxf)-i)=[];
        
        
        
                                GIU=graph(auxi,auxf);
                                GAU=digraph(auxi,auxf);
                                
                                ciclare=0;
                                if(hascycles(GIU))
                                    ciclare=1;
                                end
        
                                tuttounito=0;
                                berska=bfsearch(GIU,1,events,'Restart',true);   
                            
                                if(length(berska)==1)
                                    tuttounito=1; 
                                end
        
                                if(ciclare==0 && tuttounito==1)
                                    dibase=1;
                                    didegen=1;
                                    flaggalo=1;
                                end
                            else
                                break;
                            end
                       end
                    else
                        break;
                    end
                end
                
            end
        end

    
                 %stampo la base
         
         if(sbannami)
            alberonei=auxi;
            alberonef=auxf;
         else
            alberonei=albi;
            alberonef=albf;
         end
            
         disp('Base di copertura: ');
         dicendolo=' ';
         for i=1:length(alberonei)
            dicendolo=dicendolo+"("+alberonei(i)+","+alberonef(i)+")  ";
         end
    
         plot(GAU);


    end
    if(nonamm)
        disp('Ammissibile: No');
    else
        disp('Ammissibile: Si');
    end
    
    if(dibase)
        disp('di Base: Si');
    else
        disp('di Base: No');
    end

    if(didegen)
        disp('Degenere: Si');
    else
        disp('Degenere: No');
    end
    
    if(nonamm==1 && dibase==1)
        disp('Ottimo: Si');
    else
        disp('Ottimo: No');
    end
    


end


end