function [tipo,A,b,c,simb,VO] = convOdual(tipo,c,A,simb,b,risultato,stampa)
%Funzioni usate:matrixadder,convOdual,mostrasistema,convertisimboli

%Prende in ingresso:
% -tipo (tipo di partenza): 1 (minimo), tipo 2 (massimo)
% - VO: -1 (se sono passato da max a min o viceversa) altrimenti 1
% -c (coefficienti funzione obiettivo)
% -A (la matrice)
% -simb (i simboli di A): -1 (<=), 0(=), 1(>=)
% -b (i termini noti)
% -risultato (come lo vogliamo convertire): 0 (forma standard), 1(cambio forma), 2(dualizza)
% -stampa (vogliamo stampa a schermo): 0 (No), 1 (Si)

%Uscita: tipo(tipo di uscita), il resto degli elementi del sistema nella
%nuova conversione

% Deve essere costruita così perchè verrà utilizzata anche all'interno di
% altre funzioni (stampa non serve)


% GESTIONE ERRORI
        %tipo
if(~(tipo==1 || tipo==2))
    disp('errore: tipo compreso deve essere compreso in [1-2]');
    return;
end
        %risultato
if(~(risultato>=0 && risultato<=2))
    disp('errore: risultato compreso deve essere compreso in [0-2]');
    return;
end
        %stampa
if(~(stampa==1 || stampa==0))
    disp('errore: stampa compreso deve essere compreso in [0-1]');
    return;
end
VO=1;
check0=0;
if(risultato==0)%la standardizzazione segue il tipo
    if(tipo==1)%DUALE
         for i=1:length(simb)
            %controllo x_i>=0
            [check0,~]=unsolovalore(A(i,:));
            if(check0==1 && b(i)==0)
                if(simb(i)==-1)
                   simb(i)=1;
                   A(i,:)=-1*A(i,:);
                end
            else
                check0=0; %x_i>=3
            end

            if(simb(i)~=0 && check0~=1)%<= o >= 
                if(simb(i)==1) %>= diventa <=
                    A(i,:)=-1*A(i,:);
                    b(i)=-1*b(i);
                end
                simb(i)=0;%3x<=5   3x1+x2=5 x2>=0
                %aggiungo una nuova colonna ad A
                zam=zeros(size(A,1),1);
                zam(i,1)=1;
                [A]=matrixadder(A,zam,2);
                [c]=matrixadder(c,[0],2);
           
                %aggiungo una nuova riga
                zam=zeros(1,size(A,2));
                zam(1,size(A,2))=1;
                [A]=matrixadder(A,zam,1);
                %aggiungo una riga a b
                [b]=matrixadder(b,[0],1);
                %aggiungo il segno
                [simb]=matrixadder(simb,[1],1);
            end
            check0=0;
        end
    else%PRIMALE 
        for i=1:length(simb)
            if(simb(i)==1)%cambio >= con <=
                A(i,:)=-1*A(i,:);
                b(i)=-1*b(i);
                simb(i)=-1;
            end
            if(simb(i)==0)%cambio = con <=
                simb(i)=-1;
                %aggiungo una nuova riga ad A,b,simb
                usl1=-1*A(i,:);
                [A]=matrixadder(A,usl1,1);
                [b]=matrixadder(b,-1*b(i),1);
                [simb]=matrixadder(simb,-1,1);
                
            end
        end
    end
end

if(risultato==1)
    switch(tipo)
        case 1
            tipo=2;
        case 2
            tipo=1;
    end
    c=-1*c;
    
    [tipo,A,b,c,simb,~]=convOdual(tipo,c,A,simb,b,0,0);
    VO=-1;
end

if(risultato==2)
    if(tipo==2)%partendo dal primale
        
        %sistemo il tipo
        tipo=1;

        %sistemo b e c
        aux=c;
        c=b';
        b=aux';

        %sistemo A
        A=A';
        simb=zeros(size(A,1),1);%sistemo i simboli in =
        %sistemo y
        numvar=size(A,2);
        zepsi=eye(numvar,numvar);
        [A]=matrixadder(A,zepsi,1);
        %sistemo i simboli (aggiungo i >=)
        altersimb=ones(size(zepsi,1),1);
        [simb]=matrixadder(simb,altersimb,1);
        %sistemo b aggiungendo 0
        altare=zeros(size(zepsi,1),1);
        [b]=matrixadder(b,altare,1);

    else%partendo dal duale
        [tipo,A,b,c,simb,VO]=convOdual(tipo,c,A,simb,b,1,0);%inverto nella forma primale
        [tipo,A,b,c,simb]=convOdual(tipo,c,A,simb,b,2,0);%faccio il primale seguendo la prima strategia
    end
end

if(stampa==1)
    simb=convertisimboli(simb,1);

    mostrasistema(VO,tipo,c,A,simb,b);
end


end