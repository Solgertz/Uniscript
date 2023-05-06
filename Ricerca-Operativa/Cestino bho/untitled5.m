clear
clc
a=[1,2,3;1,2,3];
u=find(a==5)

disp(str2num(y));

%a={[1,2,3];[2,1];[1]};
%C=vertcat([3,3],a)
%{
a=[1,2,3,4];
A=perms(a);
disp(A);
%}
%{
a = [1 2 3 4 5];   % ciclo a
b = [7 8 9 10 11]; % ciclo b
i = 2; j = 3;      % arco i,j
k = 9; l = 10;     % arco k,l

vali=2; valj=3;
valk=3; vall=4;

a1=a;b1=b;
z = [a b];         % unione dei due cicli
a1(a1==j)=l;
b1(b1==l)=j;

a2=[a1(1:valj),b(vall:length(b1))];
a2=unique(a2);
a2=[a2,b(1:valk),a(valj:length(a))];

disp(v);
%}
%{
C={[3];[2,1,1];[2,2]};
l=length(C)
a=cell2mat(C(3));
disp(C);
disp(a);
%}
%v=[1,2,3,4,5,6,7,8,9];
%A = reshape(v, 3, 3)
%{
A=[0,33,13,25,33;33,0,46,58,76;39,33,0,12,30;35,29,12,0,23;60,54,30,23,0];
%G=graph(A);
G = digraph([1 2 3],[2 4 5],[10,2,30]) ;
plot(G,'EdgeLabel',G.Edges.Weight);
%}




%{
inf=10^7;
A=[inf,33,13,25,33;33,inf,46,58,76;39,33,inf,12,30;35,29,12,inf,23;60,54,30,23,inf];
%A=[33,13,25,33;33,46,58,76;39,33,12,30;35,29,12,23;60,54,30,23];
n=size(A,1);
m=n;
f = reshape(A',1,[]);
Aeq = kron(eye(size(A)),ones(1,size(A,1)));
beq = ones(2*size(A,1),1);
lb = zeros(size(f));
ub = ones(size(f));
Aeq_row = repmat(eye(n),1,m); % Crea la matrice per i vincoli di riga
%options = optimoptions('linprog','Algorithm','interior-point','Display','off');
Aeq=[Aeq;Aeq_row];
[x, lower_bound] = linprog(f,[],[],Aeq,beq,lb,ub);
x
lower_bound
%}
%{
%LINEA TRA DUE PUNTI A,B, infinitizzata
%4x+2y=3, 18 8 55
mat=[18,8,55;14,18,61;1,0,0];

for i=1:size(mat,1)
    if(mat(i,1)==0 || mat(i,2)==0)    %rette verticali e orizzontali
        if(mat(i,1)==0) %3y=5
            A=[0,mat(i,3)/mat(i,2)];
            B=[3,mat(i,3)/mat(i,2)];
        else
            A=[mat(i,3)/mat(i,1),0];
            B=[mat(i,3)/mat(i,1),3];
        end

    else
        A= [0,mat(i,3)/mat(i,2)];
        B= [mat(i,3)/mat(i,1),0];
    end
    
    line([A(1), B(1)], [A(2), B(2)]);
end

%}
%{


%4x+2y=3
A=100;
A(2)=solve(4*A+2y==3,y);

B=[-100,]

xlim = get(gca,'XLim');
m = (B(2)-B(1))/(A(2)-A(1));
n = B(2)*m - A(2);
y1 = m*xlim(1) + n;
y2 = m*xlim(2) + n;
hold on
line([xlim(1) xlim(2)],[y1 y2])
hold off

%}
%{
r = -5:0.01:5;  % plotting range from -5 to 5
[x, y] = meshgrid(r);  % Get 2-D mesh for x and y based on r
condition1 = x+y+x.^2 < 3;
condition2 = y+x+y.^2 < 3;
output = ones(length(r)); % Initialize to 1
output(~(condition1 & condition2)) = 0; % Zero out coordinates not meeting conditions.
imshow(output, 'xdata', r, 'ydata', r); % Display
axis on;




l = length(r);
colored_output = zeros(l,l,3);
colored_output(:,:,1) = output * 64;  % 0 remains 0, 1 is amplified to 64
colored_output(:,:,2) = output * 128;
colored_output(:,:,3) = output * 192;
output1 = output;
output1(output1 == 0) = 300;
colored_output(:,:,2) = output1;
colored_output = uint8(colored_output);  % Convert double to uint8 values
imshow(colored_output, 'xdata', r, 'ydata', r);
axis on


%}


%{
A=[3,1,2;1,1,1;2,1,2];
x=[2;1;1];
b=A*x;
b(2)=0;

z=A*x==b;
k=find(z);
z=~z;
u=find(z)
%}


%{
%s=[1 1 2 2 3 3 4 4 5 5];
%t=[2 5 3 4 4 5 3 1 1 6];
s=[1,3,3,5];
t=[2,4,5,6];
names=['alpha','beta','gamma','delta','epsilon','zeta'];




%G=digraph(s',t,weight,names)
G=graph(s,t,t);
%G = digraph([1 2],[2 3],[100 200]);

nodi=[1,2,3,4,5,6];


tuttounito=0;
events={'startnode'};
buba=bfsearch(G,nodi(1),events,'Restart',true);   
disp(buba);




plot(G);


%connesso se i nodi interni




function plot_polyhedron(A,b,gino)
% A: matrice dei coefficienti dei vincoli (disequazioni)
% b: vettore dei termini noti dei vincoli (disequazioni)
% gino: estensione del riquadro

% esempio di input:
% A = [1 0; -1 0; 0 1; 0 -1];
% b = [1; 1; 1; 1];
% gino = 50;

m = size(A,1); % numero di vincoli (disequazioni)
n = size(A,2); % numero di variabili

% Genero una griglia di punti nel riquadro delimitato dai vincoli
x1 = linspace(0,gino,gino+1); % coordinate x dei punti
x2 = linspace(0,gino,gino+1); % coordinate y dei punti
[X1,X2] = meshgrid(x1,x2); % griglia di punti
X = [X1(:) X2(:)]; % vettore dei punti

% Verifico quali punti soddisfano tutti i vincoli
soddisfa_tutti = all(A*X' <= b,1); % vettore di booleani
X_pol = X(soddisfa_tutti,:); % punti che soddisfano tutti i vincoli

% Disegno il poliedro
figure
patch(X_pol(:,1),X_pol(:,2),'g')
hold on
plot(X(:,1),X(:,2),'k.')
axis([0 gino 0 gino])
xlabel('x_1')
ylabel('x_2')
title('Poliedro dei vincoli')
end




%}
