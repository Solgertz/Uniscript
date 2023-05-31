function [Gx,G] = graforesiduo(x,G)
%G(x) è definito come [A,u,r,x] con A=[i,j]

Gx=[];
for i=1:size(G,1)
    if(x(i)<G(i,4))
        residuo=G(i,4)-x(i);
        Gx=[Gx;G(i,[1:3]),residuo,x(i)];
        G(i,4)=residuo;
    end
    if(x(i)>0)
        Gx=[Gx;G(i,[2,1,3]),x(i),x(i)];
    end
end

%ordine lessicografico
Gx=sortrows(Gx,[1:2]);


end