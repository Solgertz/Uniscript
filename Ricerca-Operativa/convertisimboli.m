function [simb] = convertisimboli(simb,direzione)
    %Converte il vettore dei simboli <,=,> in -1,0,1 o viceversa

    %direzione=0 -> ottieni -1,0,1
    %direzione=1 -> ottieni <=,=,>=

    %zara=zeros(length(simb),1);
    if(direzione==1)
        zara=strings(length(simb),5);
        for i=1:length(simb)
            switch (simb(i))
                case -1
                    %zara(i)='<';
                    zara(i)='\leq ';
                case 0
                    zara(i)='=    ';
                case 1
                    %zara(i)='>';
                    zara(i)='\geq ';
            end
        end
    end
    if(direzione==0)
        zara=zeros(length(simb),1);
        for i=1:length(simb)
            switch (simb(i))
                case '\leq '
                    %zara(i)='<';
                    zara(i)=-1;
                case '=    '
                    zara(i)=0;
                case '\geq '
                    %zara(i)='>';
                    zara(i)=1;
            end
        end
    end
    simb=zara;
    
end