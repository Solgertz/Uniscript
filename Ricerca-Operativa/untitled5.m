clear
clc

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


%}
