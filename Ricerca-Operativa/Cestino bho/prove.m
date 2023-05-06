clear
clc

%E nodi *archi

b=[-9;-2;3;4;-3;7];
pego=[0,5,7,23,8,24];
costi=[5,4,3,9,16,1,2,6,1];

%mettere in ordine lessicografico

%(1,2), (1,3), (2,3), (2,4) , (3,4) , (3,5) (4,5) (5,6) (4,6)
u=[1,2,1,3,2,3,2,4,3,4,3,5,4,5,4,6,5,6];
pi=u(1:2:length(u));
pf=u(2:2:length(u));

nodi=6;
archi=length(u)/2;

E=zeros(nodi,archi);

for i=1:nodi
    for j=1:archi
        if(i==pi(j))
            E(i,j)=-1;
        end
        if(i==pf(j))
            E(i,j)=1;
        end
    end
end


nomi=['a','b','c','d','e','f'];

G=digraph(pi,pf,costi,nomi);
plot(G);




    
 