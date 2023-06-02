function Frankwolfe(f,A,b,xk,iter,tipo,punti)
%FUNZIONE PRESA IN PRESTITO DA https://github.com/Guray00/IngegneriaInformatica/blob/master/SECONDO%20ANNO/II%20SEMESTRE/Ricerca%20operativa/RicOp.m
%SI RINGRAZIA IL REALIZZATORE
%LA SEGUENTE FUNZIONE è STATA MODIFICATA


%INPUT:
%- f  funzione in linguaggio simbolico con variabili xi
%- iter:    numero di iterazioni da far fare all'algoritmo al massimo
%- attenzione:    Ax<=b  
%- xk:    vettore colonna
%- punti: solo nel caso il dominio sia espresso con un poliedro va riempito
%                   [x1,y1;x2,y2...]
%- A in forma primale (<=)
%- tipo:   max(1) o  min(0)

%ESEMPIO COME DEFINIRE f:
		% syms x1 x2
	    % f = - 2*x1^2 - x2^2 + 4*x1 + 2*x2


dire="\section{FRANK-WOLF}";
syX = sym('x', size(xk));
syms t;
res = [];

n_iter = 0; % Numero di iterazione
while iter > 0

	iter = iter - 1;
	
    
    %CALCOLO GRADIENTE IN xk:   
    % - subs sostituisce una variabile in una funzione
	grd = double(subs(gradient(f),syX,xk));  %è necessaria una conversione perchè si ottengono valori simbolici   
    
    aux=grd;
    if(tipo==1)     %in questo caso parto da problema di massimo
        aux=-aux;
    end
    %CALCOLO yk
    if(isempty(punti))
	    yk = linprog(transpose(aux),A,b,[],[],[],[],optimoptions('linprog','Display','none'));
    else
        %considero sempre il minimo perchè converto il gradiente
        yk=inf;
        yaux=inf;
        for i=1:size(punti,1)
            ypunto=punti(i,:)*aux;
            if(ypunto<yaux)
                yk=punti(i,:)';
                yaux=ypunto;
            end
        end
    end
    dk=yk-xk;
    dire=dire+"$$"+matrivetlate(n_iter,"K",0)+"\quad "+matrivetlate(xk,"x_k",0)+"\quad "+matrivetlate(grd,"\triangledown f(x_k)",0)+"\quad "+matrivetlate(yk,"y_k",0)+"\quad "+matrivetlate(dk,"d_k",0);
    
    %CONDIZIONE DI STOP
	if transpose(grd)*(dk) == 0
        dire=dire+"\quad \text{STOP}"+"$$";
		break;
	end
    
    %CALCOLO tk
    if(tipo==0)
        usami=subs(f,syX,xk+t*(yk-xk));
    else
        usami=-1*subs(f,syX,xk+t*(yk-xk));
    end
    tet = matlabFunction(usami); %creazione di f per minimo come funzione anonima
    pmin = fminbnd(tet,0,1);        %cerca il minimo in ]0,1[
    vals = [tet(0), tet(pmin), tet(1)];     %calcola i valori minimi in 0,minimo ipotetico centrale,1
    ts = [0,pmin,1];                % tk candidati: 0,min_ipotetico,1

    [~, index] = min(vals);        
    tk = ts(index);    %minimo in [0,1]

	xk = xk+tk*(yk-xk);     %prossimo punto candidato
    
    dire=dire+"\quad "+matrivetlate(tk,"t_k",0)+"\quad "+matrivetlate(xk,"x_{k+1}",0)+"$$";
    
    n_iter = n_iter + 1;

end

stampalatex(dire);
		
end
