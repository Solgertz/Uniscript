function [xs,vs,xi,vi] = PLIsemp(c,A,b,tipo)

%partendo dal primale
if(tipo=='p')
    format rat;
    c=-c;
    Aeq=[];
    beq=[];
    LB=zeros(length(c),1);
    UB=[];
    
    [x,v]=linprog(c,A,b,Aeq,beq,LB,UB);
    vs=-fix(v);
    xs=x;

    xi=fix(x);
    vi=-c*xi;

    s=zeros(1,length(b));%mi dice la base
    for i=1:length(b)
        fgh=A(i,:)*x;
        if(string(fgh)==string(b(i)))
            s(i)=1;
        end
    end

    nu=length(s);
    k=1;
    B=zeros(1,length(c));
    for i=1:nu
        if(s(i)==1)
            B(k)=i;
            k=k+1;    
        end
    end
    for i=1:length(x)
        if(x(i)==0)
            B(k)=nu+i;
            k=k+1;
        end
    end
    N=(1:(length(c)+nu));
    N(B)=[];
    [birba,barba,burba]=trasformatore(A,b,-c,'p','d');

    [ycalc]=risxy(birba,barba,burba,B,N,'d');
    
    [Amod,bmod] = gomory(birba,N,B,ycalc,barba);
else
    Aeq=[];
    beq=[];
    LB=zeros(length(c),1);
    UB=[];
    A=-A;
    b=-b;
    
    [x,v]=linprog(c,A,b,Aeq,beq,LB,UB);
    
    if(v-fix(v)~=0)
        vs=fix(v)+1;
    else
        vs=v;
    end
    xs=x;
    
    for i=1:length(x)
        if(x-fix(x)~=0)
            xi(i)=fix(x(i))+1;
        else
            xi(i)=x(i);
        end
    end
    vi=c*xi;

    s=zeros(1,length(b));%mi dice la base
    for i=1:length(b)
        fgh=A(i,:)*x;
        if(string(fgh)==string(b(i)))
            s(i)=1;
        end
    end

    

    N=(1:(length(c)+nu));
    N(B)=[];
    [birba,barba,burba]=trasformatore(A,b,-c,'p','d');
    
    [ycalc]=risxy(birba,barba,burba,B,N,'d')

    [Amod,bmod] = gomory(birba,N,B,ycalc);
end

end