function gradienteproiettato(f,x0,A,b,iter)

%INPUT
%   -Ax<=b  primale standard
%   -x0 vettore colonna

dire="\section{Gradiente proiettato}";
primo=" ";
k=0;
xk=x0;
syX = sym('x', size(xk));
syms t;
procedi=true;segnala=false;
step=1;
while(step<=iter)
%CALCOLO INSIEME VINCOLI PER M
    Alfa=A*xk==b;
%CALCOLO M
    M=A(Alfa,:);
    
    while(procedi)
        procedi=false;
%CALCOLO H
        auxM=inv((M*M'));
        aux=M'*auxM*M;
        H=eye(size(aux,1))-aux;
%CALCOLO DIREZIONE
        grd = double(subs(gradient(f),syX,xk));  
        dk=-H*grd;
        primo=primo+"$$"+matrivetlate(step-1,"K",0)+"\quad "+matrivetlate(M,"M",0)+"\quad "+matrivetlate(H,"H",0)+"\quad "+matrivetlate(grd,"\triangledown f(x_k)",0)+"\quad "+matrivetlate(dk,"d_k",0);
        
        if(~isequal(dk,zeros(length(dk),1)))
%CALCOLO tk cappuccio
            tkmax = linprog(-1,A*dk,b-A*xk,[],[],[],[],optimoptions('linprog','Display','none'));

%CALCOLO tk             
				tet = matlabFunction(subs(f,syX,xk+t*dk));

				pmin = fminbnd(tet,0,tkmax);
				vals = [tet(0), tet(pmin), tet(tkmax)];
				ts = [0,pmin,tkmax];
				[mi, index] = min(vals);

				tk = ts(index);
%CALCOLO xk+1
				xk = xk+tk*dk;
                primo=primo+"$$ $$"+matrivetlate(tkmax,"\hat{t}_k",0)+"\quad "+matrivetlate(tk,"t_k",0)+"\quad "+matrivetlate(xk,"x_{k+1}",0)+"$$ $$";
        else
            lam=-auxM*M*grd;
            primo=primo+"\quad "+matrivetlate(lam,"\lambda",0);
            if(lam>=0)  %trovata soluzione LKKT
                segnala=true;
                primo=primo+"$$";
                break;
            else
                [~,i]=min(lam);
                M(i,:)=[];
                procedi=true;  %ritorno al passo 3 (aggiornamento di M)
            end
        end
        primo=primo+"$$";
    end
    if(segnala) %STOP (per uscire da due nested loop bisogna per forza usare 1 var di appoggio)
        break;
    end
step=step+1;
procedi=true;segnala=false;  %ripristino condizioni inziali per prossimo punto
end


dire=dire+primo;
stampalatex(dire);

end