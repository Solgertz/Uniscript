classdef matlabwizard
    %ALCUNE FUNZIONI MOSTRANO RISULTATI TRAMITE GRAFICI
    methods(Static)
        function Assegnamento(T,rifiuti)
            % INPUT:
            % - T è la matrice del problema
            % - rifiuti: vettore n*2 che indica gli indici i,j delle "persone che
            %            rifiutano lavori"  (se non ci sono, lascirlo vuoto con "[]")
            assegnamento(T,rifiuti);
        end
        function Standardizza(tipo,c,A,simb,b,risultato)
            %INPUT:
            % -tipo (tipo di partenza): 1 (minimo), tipo 2 (massimo)    
            % -c coefficienti funzione obiettivo come vettore riga
            %   Ax<=b  si descrive come A simb b
            % -A      la matrice dei moltiplicatori di x
            % -simb   i simboli di A:   -1 (<=), 0(=), 1(>=)
            % -b      i termini noti
            % -risultato (come lo vogliamo convertire): 0 (forma standard), 1(cambio forma), 2(dualizza)

            convOdual(tipo,c,A,simb,b,risultato,1);
        end

        function TSP(T,K_albero,nodovicino,esclusiva)
            %INPUT:
            % -T         la matrice ridotta del problema con 0 dove ci sono gli
            %            elementi simmetrici (la parte inferiore del triangolo)
            %            e se ci dovessero essere, 10 000 dove ci sono i trattini "-"
            %       
            % -K_albero      nodo di partenza per Vi 
            % -nodovicino    nodo di partenza per Vs 
            % -esclusiva:  vettore n*2 degli archi {(i1,j1),(i2,j2)...} 
            %              da istanziare per il BrenchEBound
            %                   nella forma  [i1,j1;
            %                                 i2,j2;
            %                                  ...]
            nodi=size(T,2)+1;
            Hemilton(nodi,T,'s',K_albero,nodovicino,esclusiva);

            %OUTPUT: risultati anche sulle tab dei plot matlab aperte
        end
        function Zaino(valore,peso,P)
            %INPUT:
            % - valore e peso sono due vettori riga
            % - P è uno scalare
            zainocompleto(valore,peso,P);
        end
        function TestOttimalit(c,A,b,base,tipologia)
            %INPUT:
                        % USARE PROBLEMI NEL FORMATO STANDARD
            % -c coefficienti funzione obiettivo come vettore riga
            %   Ax<=b  si descrive come A simb b
            % -A      la matrice dei moltiplicatori di x
            % -b      i termini noti
            % - base:  vettore riga della base  es: B=(1,3)  è [1,3]
            % - tipologia:  1(primale), 2(il suo duale)
            indagasoluzione(c,A,b,base,tipologia,1);
        end
        function Simplesso(c,A,b,simb,base,tipologia)
            %INPUT:
                        
            % -c coefficienti funzione obiettivo come vettore riga
            %   Ax<=b  si descrive come A simb b
            % -A      la matrice dei moltiplicatori di x
            % -simb   i simboli di A:   -1 (<=), 0(=), 1(>=)
            % -b      i termini noti
            % -base    vettore riga della base es: B=(1,3)  è [1,3]
            %-Tipologia: 1(primale), 2(il suo duale)

            simplesso(c,A,b,simb,base,tipologia);

            %OUTPUT:
            % Base inutile-> non è possibile nemmeno fare un passo del simplesso 
            % Siamo già all'ottimo -> la base era ottima
            % Negli altri casi viene mostrato un passo del simplesso

        end
        function valutazioniPLIeGomory(c,A,b,simb,tipologia)
            % -c coefficienti funzione obiettivo come vettore riga
            %   Ax<=b  si descrive come A simb b
            % -A      la matrice dei moltiplicatori di x
            % -simb   i simboli di A:   -1 (<=), 0(=), 1(>=)
            % -b      i termini noti
            % Tipologia: 1(max), 2(min)
            
            if(tipologia==1)
                tipo='p';
            else
                tipo='d';
            end
            valPLI(c,A,b,simb,tipo);
        end
        function ReteCapacitata(archi_c_u,b,r)
            %INPUT:
            %- archi_c_u     è una matrice (non per forza in ordine lessicografico) del
            %                formato : [1,2,4,10,T;  1,3,4,10,U;  i,j,c,u,tripartizione...]
            %                per la tripartizione: 1=T, 2=L, 3=U
            %                i,j descrivono arco (partenza,arrivo)
            %                c  è il costo
            %                u è la capacità superiore
            %- b   vettore colonna dei bilanci, IN ORDINE da 1 a n
            %- r   è il nodo di partenza per DIJSKTRA (cammini minimi)

            capacitata(archi_c_u,b,r);
            %OUTPUT: risultati anche sulle tab dei plot matlab aperte
        end
        function Frank_Wolfe(f,A,b,x0,iter,tipo,punti)
            
            %INPUT:
            %- f  funzione in linguaggio simbolico con variabili in x
            %- iter:    numero di iterazioni da far fare all'algoritmo al massimo
            %- ATTENZIONE:   da usare la forma Ax<=b  
            %- x0:    vettore colonna
            %- punti: solo nel caso il dominio sia espresso con un poliedro va riempito 
            %                       ALTRIMENTI LASCIARE VUOTO   "[]"                  
            %           P={(x1,y1), (x2,y2) ...}   diventa [x1,y1; x2,y2...]
   
            %- tipo:   max(1) o  min(0)

            Frankwolfe(f,A,b,x0,iter,tipo,punti);            
           
        end
        function GradienteProiettato(f,x0,A,b,iter)
            %INPUT:
            %- f  funzione in linguaggio simbolico con variabili in x
            %- iter:    numero di iterazioni da far fare all'algoritmo al massimo
            %- ATTENZIONE:   da usare la forma Ax<=b  
            % per dominio POLIEDRO, ricavare con GEOGEBRA i vincoli associati ai punti
            %- x0:    vettore colonna
            gradienteproiettato(f,x0,A,b,iter)
        end
        function LKKTsys(f,g,h)
            %INPUT:
            % - f  funzione in linguaggio simbolico con variabili in x
            % - g  vettore colonna di funzioni in linguaggio simbolico
            % - h  vettore colonna di funzioni in linguaggio simbolico
            
            % - g e h vanno portati nella forma  D(x)<=0 
            %   es:   x1+x2>=3   diventa  -x1-x2+3<=0

            % con vettore colonna si intende  [x1+x2-3;
            %                                   x2^2-5;]
            %  se non ci sono, indicare come vuoto "[]"
            LKKT(f,g,h);
        end
        function Zeasteregg
            %Chissà cosa farà  ^.^
            
            %usa ctrl+maiusc+M selezionando la command window per mettere e togliere il full-screen 
            segretodepulcinella();%non sbirciare, altrimenti ti rovini la sorpresa
        end
    end
end