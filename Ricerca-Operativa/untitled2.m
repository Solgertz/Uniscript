clear;clc;

x=6.1429;
coeff=sym(x,'r');
latex(coeff)

%{

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


%}













%{
v = -5:0.1:5;
[x,y] = meshgrid(v);  % create a grid
ineq = x + y >= 1;    % some inequality
f = double(ineq);
plot(f);
%surf(x,y,f);
%view(0,90)            % rotate surface plot to top view

%}

%{

%Generate data
[H,C] = meshgrid(0:0.1:10);
NB=H+2*C;

% Get True where condition aplies, false where not.
cond1=4*H+C<=20;
cond2=H+3*C<=10;
% Get boundaries of the condition
Cp1=20-4*H(1,:);
Cp2=(10-H(1,:))/3;

%Delete Areas whereCondition does not apply;
NB(~cond1)=NaN;
NB(~cond2)=NaN;

% Plot
[C,h]=contourf(H,C,NB,20);
clabel(C,h,'LabelSpacing',100) % optional
hold on


plot(H(1,:),Cp1,'r')

%text(H(1,45),Cp1(45), '\leftarrow Cond1'); %arbitrary location

plot(H(1,:),Cp2,'k')
%text(H(1,75),Cp2(75), '\leftarrow Cond2'); %arbitrary location


axis([0 10 0 10])
xlabel('H, Hydropower')
ylabel('C, Crops')

%}
