classdef nodoalbero
    % definisce un nodo di un albero bipartito
    properties
        id
        variabile   %indice della variabile del problema
        sx      %id del figlio sinistro
        dx
        ardx    %in standard contiene uno scalare, in hemilton una coppia di indici
        arsx
        vi      %valutazione del problema
        vs
        marco   %standard (non è una terminazione), terminazione, foglia,vuoto
        stato   %standard,tagliato,non esistente,aggiornato,vuoto
        vincoli  %contiene tutti i vincoli da aggiungere al figlio successivo
        albero  %contiene tutti i nodi aggiunti finora
        dima    %dimensione matrice A
        tipologia %indica il tipo di BeB (standard,Hamilton,binario)
        scelta   %nel caso binario indica la variabile per i figli
    end

    methods
        function obj = nodoalbero(i,j,vals,vali,arco1,arco2,vari,ulb,di,tips)
            %   Quando creo un nodo
            obj.id=[i,j];
            obj.sx=[i+1,2*j-1];
            obj.dx=[i+1,2*j];
            obj.vi=vali;      
            obj.vs=vals;
            obj.arsx=arco1;
            obj.ardx=arco2;
            obj.stato=0;
            obj.marco=0;
            obj.variabile=vari;
            obj.dima=di;
            obj.tipologia=tips;
            obj=obj.vincolifinqui(ulb);
            obj.albero=[ulb,obj];
        end
        function [mat,parlato] = costruiscitabella(albero,controllo)
            parlato=[];
            dimensione=length(albero);
            retrica=length(controllo);
            mat=zeros(length(albero));
            unstoppable=1;
            for i=1:dimensione
                a=albero(i);
                if(a.stato==2)
                    unstoppable=unstoppable+2;
                    continue;
                end
                figlio1=a.sx;
                figlio2=a.dx;
                cond1=false;
                cond2=false;
                for j=1 : retrica  %controllo l'esistenza dei figli
                    u=controllo(j);
                    if(u.id==figlio1)
                        cond1=true;
                    end
                    if(u.id==figlio2)
                        cond2=true;
                    end
                
                end
                if(unstoppable+1<dimensione) %escludo le foglie
                    if(cond1)
                        mat(i,unstoppable+1)=1;%a.arsx;%nodo sinistro
                        if(a.tipologia==0)
                            uno=string("$x_{"+num2str(a.scelta)+"}= "+num2str(a.arsx))+"$";
                        end
                        if(a.tipologia==2)
                            uno=string("$x_{"+num2str(a.variabile)+"}\leq "+num2str(a.arsx))+"$";
                        end
                        if(a.tipologia==1)
                            uno=string("$("+num2str(a.variabile(1))+","+num2str(a.variabile(2))+")=0 $");
                        end
                        parlato=[parlato,uno];
                    end
                    if(cond2)
                        mat(i,unstoppable+2)=1;%a.ardx;%nodo destro
                        if(a.tipologia==0)
                           due=string("$x_{"+num2str(a.scelta)+"}= "+num2str(a.ardx))+"$";
                        end
                        if(a.tipologia==2)
                            due=string("$x_{"+num2str(a.variabile)+"}\geq "+num2str(a.ardx))+"$"; 
                        end
                        if(a.tipologia==1)
                            due=string("$("+num2str(a.variabile(1))+","+num2str(a.variabile(2))+")=1 $");
                        end
                        parlato=[parlato,due];
                    end
                    unstoppable=unstoppable+2;
                end
            end


        end
        function [father,obj] = padre(obj,i,j,albero)
            % i,j sono gli indici del nodo creato
            father=[];
            for z=1:length(albero)
                if(albero(z).id==[i-1,ceil(j/2)])
                    father=albero(z);
                end
            end
            if(~isempty(father) && father.stato>0)
                obj.stato=2;  %figlio che non esiste
            end
        end
        function obj = vincolifinqui(obj,ulb)
            %cerco il padre
            [s,obj]=obj.padre(obj.id(1),obj.id(2),ulb);
            
            if(isempty(s)) %solo la radice
                if(obj.tipologia==0)
                    obj.scelta=obj.variabile;
                end
            else
                obj.tipologia=s.tipologia;
                if(obj.tipologia==0 || obj.tipologia==2)
                    if(obj.tipologia==0)
                        obj.variabile=s.scelta;
                    end
                    obj.dima=s.dima;
                    obj.vincoli=s.vincoli;
                    vett=zeros(1,obj.dima);
                    %vett(s.variabile)=1;
                    vett(obj.variabile)=1;
                    vett=num2cell(vett);
                    if(isempty(s.vincoli))
                        if(rem(obj.id(2),2)~=0) %numero dispari
                            altera1=-1;
                            altera2=s.arsx;
                        else
                            altera1=1;
                            altera2=s.ardx;
                        end
                        obj.vincoli={vett,altera1,altera2};
                    else
                        obj.vincoli{1}=[obj.vincoli{1};vett];
                        if(rem(obj.id(2),2)~=0) %numero dispari
                            obj.vincoli{2}=[obj.vincoli{2};{-1}];
                            obj.vincoli{3}=[obj.vincoli{3};{s.arsx}];
                        else
                            obj.vincoli{2}=[obj.vincoli{2};{1}];
                            obj.vincoli{3}=[obj.vincoli{3};{s.ardx}];
                        end
                    end
                else
                    obj.dima=s.dima;
                    obj.vincoli=s.vincoli;
                    if(isempty(s.vincoli))
                        if(rem(obj.id(2),2)~=0) %numero dispari
                            altera1=0;
                            altera2=s.arsx;
                        else
                            altera1=1;
                            altera2=s.ardx;
                        end
                        obj.vincoli={altera1,altera2};
                    else
                        if(rem(obj.id(2),2)~=0) %numero dispari
                            obj.vincoli{1}=[obj.vincoli{1};{0}];
                            obj.vincoli{2}=[obj.vincoli{2};{s.arsx}];
                        else
                            obj.vincoli{1}=[obj.vincoli{1};{1}];
                            obj.vincoli{2}=[obj.vincoli{2};{s.ardx}];
                        end
                    end

                end
            end

            %cellarray così definito {presenza,archi}
            
        end

    end
end