function [val] = approssima(val,mod)
%USO: fa vari tipi di approssimazioni
%INPUT: 
%       -mod 0 verso sinistra (difetto), mod 1 verso destra (eccesso)
%       -mod 2   vicino a 0,  mod 3 lontano da 0

%ESEMPI:
%       mod=0   x=-3,4  y=3,4   ->   x=-4   y=3
%       mod=1   x=-3,4  y=3,4   ->   x=-3   y=4
%       mod=2   x=-3,4  y=3,4   ->   x=-3   y=3
%       mod=3   x=-3,4  y=3,4   ->   x=-4   y=4

m=size(val,1);
n=size(val,2);

if(m==1 && n==1) %scalare
    if(mod==0)
       val=floor(val); 
    end
    
    if(mod==1)
        val=ceil(val);
    end
    
    if(mod==2)
        val=fix(val);
    end
    
    if(mod==3)
        if(floor(val)~=ceil(val))
            if(val>=0)
                val=ceil(val);
            else
                val=floor(val);
            end
        end
    end
else %versione matriciale
    if(mod==0)
        for i=1:m
            for j=1:n
                val(i,j)=floor(val(i,j));
            end
        end
         
    end
    
    if(mod==1)
        for i=1:m
            for j=1:n
                val(i,j)=ceil(val(i,j));
            end
        end
    end
    
    if(mod==2)
        for i=1:m
            for j=1:n
                val(i,j)=fix(val(i,j));
            end
        end
    end
    
    if(mod==3)
        for i=1:m
            for j=1:n
                if(floor(val)~=ceil(val))
                    if(val>=0)
                        val(i,j)=ceil(val(i,j));
                    else
                        val(i,j)=floor(val(i,j));
                    end
                end
            end
        end
        
    end

end

end