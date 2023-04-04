function [stringa] = vincolatex(vett,simb,b)
%dato un vettore contenente i coefficienti ordinati del vincolo, ricava il
%latex del vincolo

stringa=" ";
for i=1:length(vett)
    if(i>1)
        if(vett(i)>=0)
            stringa=stringa+" + ";
        end
    end
    if(vett(i)==1 || vett(i)==-1)
        stringa=stringa+"  x_{"+i+"} ";
    else
        if(vett(i)==0 || vett(i)==-0)
            stringa=stringa+" ";
        else
            stringa=stringa+" "+latex(sym(vett(i)))+" x_{"+i+"} ";
        end
    end
    
end
stringa=stringa+simb+" "+latex(sym(b));

end