function [] = mostrasistema(tipo,fo,A,simb,b)
%mostra a schermo il sistema
clc

dfile ='temp.txt';
if exist(dfile, 'file')  
    delete(dfile); 
end

diary temp.txt
x='';
disp('\left\{\begin{matrix}');

%scrivo il tipo di problema
switch tipo
    case 1
        x=[x,'max '];
    case 2
        disp('min ');
    case 3
        disp('-max ');
    case 4
        disp('-min ');
    otherwise
        disp('errore di tipo\n');
        return
end
%scrivo la funzione obiettivo

for i=1:size(fo,2)
    
    coeff=fo(1,i);
    coeff=sym(coeff,'r');
    [n,d]=numden(coeff);
    if(d==1)
        z=string(fo(1,i));
    else
        l=['\frac{',char(n),'}{',char(d),'}'];
        z=string(l);
    end
    
    %[n,d]=numden(sym(coeff,'r'));
    %q=[];
    %z=string(strjoin(q));
    if(fo(1,i)~=0)
        
        if(fo(1,i)>0)
            x=[x,'+'];
        end
        if(fo(1,i)~=1 && fo(1,i)~=-1)
            x=[x,z];
        end
        if(fo(1,i)==-1)
            x=[x,'-'];
        end
        x=[x,'x_{'];
        x=[x,string(i)];
        x=[x,'}'];
        
    end
end
x=[x,'  \\'];
x=string(strjoin(x));
disp(x);

%scrivo la matrice a e b
y='';
for i=1:length(simb)
    for j=1:size(A,2)
        z=string(A(i,j));
        if(A(i,j)~=0)
            if(A(i,j)>0)
                y=[y,'+'];
            end
            if(A(i,j)~=1 && A(i,j)~=-1)
                y=[y,z];
            end
            if(A(i,j)==-1)
                y=[y,'-'];
            end
            y=[y,'x_{'];
            y=[y,string(j)];
            y=[y,'}'];
            
        end
    end
    
    y=[y,char(simb(i,1))];
    y=[y,b(i,1)];
    y=[y,'   \\'];
    y=[y,char(newline)];
    y=strjoin(y);
end
y=string(strjoin(y));
disp(y);

disp('\end{matrix}\right.');
diary off
end