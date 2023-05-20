function [ottimo] = simplesso(c,A,b,simb,base,tipologia)
%chiama il test di ottimalità su una base e se possibile svolge uno step
%del simplesso

%REQUISITO: Deve essere in forma standard

% FUNZIONI USATE: indagasoluzione(),
% simp(),pausiliario()
ragionamento=" ";

if(tipologia==1)
    %simb=ones(length(b),1); simb=-1*simb;
    [~,verbA,verb,~,simb,~]=convOdual(2,c,A,simb,b,1,0);
    [situa]=pausiliario(verbA,verb,simb); %ricavo duale standard
    situa=1; % questo controllo non funziona bene
else
    [situa]=pausiliario(A,b);
    situa=1; % questo controllo non funziona bene
end
if(situa==0)
    ragionamento=" \section{PROBLEMA VUOTO} ";
else
    if(situa==2)
        disp("Errore algorimto Pausiliario");
        return;
    end

    ottimo=base; %caso in cui la base di partenza è già ottima
    [Ab,An,bn,x,y,funz_ob,N,tipo]=indagasoluzione(c,A,b,base,tipologia,0); %mi interessano solo i risultati del test
    
    
    if(tipo=='s')  %Base da scartare
        ragionamento=ragionamento+"Base da scartare";
    end
    if(tipo=='o')
        ragionamento=ragionamento+"Siamo già all'ottimo";
    end
    
    if(tipo~='s' && tipo~='o')
        [ottimo,stringa] = simp(A,Ab,An,b,bn,funz_ob,x,y,base,N,tipo);
        ragionamento=ragionamento+" "+stringa+" ";
    end
end



stampalatex(ragionamento);

end