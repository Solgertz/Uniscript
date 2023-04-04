function [stringa] = matrivetlate(A,nome,separatori)
%produce una stringa latex convertendo la variabile matrice o vettore di
%Mathlab

%viene gestito anche il caso di valori di tipo simbolico e numerico

%INPUT
    %- A: valore
    %- nome: nome del valore
    %- separatori: indica se si vuole separare tra $$ $$ la formula

if(separatori==1) 
    stringa="$$";
else
    stringa=" ";
end

stringa=stringa+nome+"= "+latex(sym(A))+" ";

%{
if(size(A,2)==1 && size(A,1)==1) %caso scalare 
    if(~isnumeric(A))
        A=latex(A);
    end
    stringa=stringa+nome+"=("+A+ ")";
end

if(size(A,1)==1 && size(A,2)>1)  %vettore riga
stringa=stringa+nome+"=(";
for i=1:size(A,2)
    stringa=stringa+A(i);
    if(i~=size(A,2))
        stringa=stringa+",\;";
    end
end
stringa=stringa+")";
end

if(size(A,2)==1 && size(A,1)>1)  %vettore colonna
stringa=stringa+nome+"=\left(\begin{array}{c}";

for i=1:size(A,1)
    stringa=stringa+A(i);
    if(i~=size(A,1))
        stringa=stringa+"\\ ";
    end
end

stringa=stringa+"\end{array}\right)";

end

if(size(A,2)>1 && size(A,1)>1)
stringa=stringa+nome+"=\begin{pmatrix} ";
for i=1:size(A,1)
    for j=1:size(A,2)
        stringa=stringa+A(i,j)+" ";
        if(j~=size(A,2))
            stringa=stringa+" & ";
        end
    end
    if(i~=size(A,1))
            stringa=stringa+" \\ ";
    end
end
stringa=stringa+" \end{pmatrix}";
end
%}

if(separatori==1)
    stringa=stringa+"$$";
end

end