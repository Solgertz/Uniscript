function [ris] = risxy(A,b,c,base,N,tipo)
 




    
    
l=length(base);%2

n=size(A,1);%2
m=size(A,2);%6
vinN=m-l;% |N|=m-n    
    

if(tipo=='d')
    
    Ab=A;
    Ab(:,N) = [];
    Ab=Ab';%%%%%%%
    

    sym Ab;
    Ab1=inv(Ab);
    y1=(b')*Ab1;
    %c(:,[3,4])=[];
    
    %y1=c*Ab1;

    y=zeros(1,m);
    for i=1:l
        y(base(i))=y1(i);
    end
    ris=y;

else
    Ab=A;
    Ab(N, : ) = [];
    bb=b;
    bb(N,:)=[];
    
    Ab1=inv(Ab);
    x=Ab1*bb;
    ris=x;
end 
    

end
