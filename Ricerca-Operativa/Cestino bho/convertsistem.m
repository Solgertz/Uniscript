function [tipo,A,b,c,simb] = convertsistem(tipo,c,A,simb,b,risultato,stampa)
%Prende in ingresso:
% -tipo di partenza: 1 (minimo), tipo 2 (massimo);3 (-minimo),4 (-massimo) 
% -coefficienti funzione obiettivo
% -la matrice di sinistra(A)
% -i simboli di A: -1 (<=), 0(=), 1(>=)
% -i termini noti
% -come lo vogliamo convertire: 0 (forma standard), 1(cambio forma), 2(cambio formato)
% -vogliamo stampa a schermo: 0 (No), 1 (Si)

if(risultato==0)%la standardizzazione segue il tipo
    if(tipo==1 || tipo==3)%DUALE
         for i=1:length(simb)
            if(simb(i)~=0 && b(i)~=0)%<= o >= che non sono x>=0
                if(simb(i)==-1)%3x<=5   3x1+x2=5 x2>=0
                    simb(i)=0;
                    %aggiungo una nuova colonna ad A
                    zam=zeros(size(A,1),1);
                    zam(i,1)=1;
                    [A]=matrixadder(A,zam,2);
                    %aggiungo una nuova riga
                    zam=zeros(1,size(A,2));
                    zam(1,size(A,2))=1;
                    [A]=matrixadder(A,zam,1);
                    %aggiungo una riga a b
                    [b]=matrixadder(b,[0],1);
                    %aggiungo il segno
                    [simb]=matrixadder(simb,[1],1);
                else%>=
                    simb(i)=0;
                    A(i,:)=-1*A(i,:);
                    b(i)=-1*b(i);
                    %aggiungo una nuova colonna ad A
                    zam=zeros(size(A,1),1);
                    zam(i,1)=1;
                    [A]=matrixadder(A,zam,2);
                    %aggiungo una nuova riga
                    zam=zeros(1,size(A,2));
                    zam(1,size(A,2))=1;
                    [A]=matrixadder(A,zam,1);
                    %aggiungo una riga a b
                    [b]=matrixadder(b,[0],1);
                    %aggiungo il segno
                    [simb]=matrixadder(simb,[1],1);
                end
            end
          if(simb(i)==-1)
                simb(i)=1;
                A(i,:)=-1*A(i,:);
                b(i)=-1*b(i);
          end
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
            tipo=4;
        case 2
            tipo=3;
        case 3
            tipo=2;
        case 4
            tipo=1;
    end
    c=-1*c;
    [tipo,A,b,c,simb]=convertsistem(tipo,c,A,simb,b,0,0);
end

if(risultato==2)
    if(tipo==2 || tipo==4)%partendo dal primale
        
        %sistemo il tipo
        switch (tipo)
            case 2
                tipo=1;
            case 4
                tipo=3;
        end

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
        [tipo,A,b,c,simb]=convertsistem(tipo,c,A,simb,b,1,0);%inverto nella forma primale
        [tipo,A,b,c,simb]=convertsistem(tipo,c,A,simb,b,2,0);%faccio il primale seguendo la prima strategia
    end
end

if(stampa==1)
    zara=zeros(length(simb),1);
    for i=1:length(simb)
        switch (simb(i))
            case -1
                zara(i)='<';
            case 0
                zara(i)='=';
            case 1
                zara(i)='>';
        end
    end
    
    ztipo=5;
    switch (tipo)
        case 1
            ztipo=2;
        case 2
            ztipo=1;
        case 3
            ztipo=4;
        case 4
            ztipo=3;
    end


    mostrasistema(ztipo,c,A,zara,b);
end


end