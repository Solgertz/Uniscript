
clear;
clc;



%{
T=[1,2,3,4;2,3,5,5];
ET=[1,-1,0,0;0,1,-1,0;0,0,0,-1;0,0,1,1];
Falso=ET;
dimAlb=size(T,2)-1;
dim2=size(ET,1);
albe=T;
ordine=[2:dim2+1];ordinarc=[];
for i=1:dimAlb
    %ricavo riga e colonna da traslare
    [archetto,nodetto]=foglia(albe);
    ordinarc=[ordinarc,albe(:,archetto)];
    albe(:,archetto)=[];
    j=find(ordine==nodetto);
    %sposto la riga
    if(i==1)
        mat=ET;
        mat(j,:)=[];
        ET=[ET(j,:);mat];

        ord=ordine;
        ord(j)=[];
        ordine=[ordine(j),ord];
    else
        mat=ET;
        mat(j,:)=[];
        mat(1:i-1,:)=[];
        ET=[ET(1:i-1,:);ET(j,:);mat];

        ord=ordine;
        ord(j)=[];
        ord(1:i-1)=[];
        ordine=[ordine(1:i-1),ordine(j),ord];
    end
    %sposto la colonna
    if(i==1)
        mat=ET;
        mat(:,archetto)=[];
        ET=[ET(:,archetto),mat];
    else
        mat=ET;
        mat(:,i-1+archetto)=[];
        mat(:,1:i-1)=[];
        ET=[ET(:,1:i-1),ET(:,i-1+archetto),mat];
    end
end
disp(ET);
ordinarc=[ordinarc,albe];

out=zeros(dim2,dimAlb+1);
    
for i=1:(dimAlb+1)
    o1=find(ordine==ordinarc(1,i));
    o2=find(ordine==ordinarc(2,i));
    out(o1,i)=-1;
    out(o2,i)=1;
end

disp(out);

%}
%{
T=[1,2,3,4;2,3,5,5];
ET=[1,-1,0,0;0,1,-1,0;0,0,0,-1;0,0,1,1];
dimAlb=size(T,2)-1;
dim2=size(ET,1);
albe=T;
ordine=[2:dim2+1];ordinarc=[];
for i=1:dimAlb
    %ricavo riga e colonna da traslare
    [archetto,nodetto]=foglia(albe);
    ordinarc=[ordinarc,albe(:,archetto)];
    albe(:,archetto)=[];
    j=find(ordine==nodetto);
    %sposto la riga
    if(i==1)
        ord=ordine;
        ord(j)=[];
        ordine=[ordine(j),ord];
    else
        ord=ordine;
        ord(j)=[];
        ord(1:i-1)=[];
        ordine=[ordine(1:i-1),ordine(j),ord];
    end
end
disp(ET);
ordinarc=[ordinarc,albe];

out=zeros(dim2,dimAlb+1);
    
for i=1:(dimAlb+1)
    o1=find(ordine==ordinarc(1,i));
    o2=find(ordine==ordinarc(2,i));
    out(o1,i)=-1;
    out(o2,i)=1;
end

disp(out);
%}



