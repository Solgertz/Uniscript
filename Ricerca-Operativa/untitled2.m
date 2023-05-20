clear;clc;

A = [1,2;2,3;1,0;1,0;2,2;1,3];
b = unique(A(:));


%{
a=nodoalbero(0,1,13,15,1,2,2,[],4);
b=nodoalbero(1,1,11,19,7,8,3,a.albero,[]);
c=nodoalbero(1,2,2,4,2,1,1,b.albero,[]);
d=nodoalbero(2,1,2,1,4,2,4,c.albero,[]);
uzi=d.vincoli;
%}
%a={zeros(1,3)};


%{
%mod(2500,1)
x=[1/2;1/2];
for i=1:2
    u(i)=sym(x(i));
end
u
%}

%{
a={{1,2,4;1,2,4},{1;2},{0;0}};

v=[];
v=num2cell(v);
a{1}=[a{1};v];
a{2}=[a{2};{0}];

size(a{2},2)
%}

p = [2 4 2 0 6 4 6]; % ogni cella indica il padre (cella 2 ha come padre il nodo 4)
%s=[4,2,6,1,3,5,7];
%q={[],[1,3],[],[2,6],[],[5,7],[]};

%{
figure;
treeplot(p);

[x,y] = treelayout(p); 
text(x + 0.02,y,{1,2,3,4,5,6,7});  %il numero del nodo corrisponde a l'ordine canonico
figure;
padri=[4,4,2,2,6,6];
figli=[2,6,1,3,5,7];
G=digraph(padri,figli);
%plot(G, 'ShowArrows', false);mi piace più con le frecce
plot(G);
%}

%}
%{
x = optimvar('x','LowerBound',-1,'UpperBound',1.5);%  -1<=x<=1.5
y = optimvar('y','LowerBound',-1/2,'UpperBound',1.25);
prob = optimproblem('Objective',x + y/3,'ObjectiveSense','max');  %max x+y/3
prob.Constraints.c1 = x + y <= 2;
prob.Constraints.c2 = x + y/4 <= 1;
prob.Constraints.c3 = x - y <= 2;
prob.Constraints.c4 = x/4 + y >= -1;
prob.Constraints.c5 = x + y >= 1;
prob.Constraints.c6 = -x + y <= 2;
prob.Constraints.c7 = x + y/4 == 1/2;

problem = prob2struct(prob);  %problema effettivo (converte in automatico in minimize)
show(prob); %per mostrarlo



options = optimoptions('linprog','Display','iter');
[x,fval,exitflag,output] = linprog([13,12],[3,5;6,7],[35;70],[],[],[0;0],[],[],options);
output.basis
%}

%{
x=6.1429;
coeff=sym(x,'r');
latex(coeff)
%}
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
