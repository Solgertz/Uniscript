function [situa,ind] = unsolovalore(vett)
%verifica che nel vettore c'è un solo valore diverso da 0 e ne restituisce
%l'indice

%OUTPUT:
%       - situa:  0 se il vettore ha termini di diversi valori
%       - situa:  1 se il vettore ha un solo termine diverso da 0

ind=0;j=0;
for i=1:length(vett)
   if(vett(i)~=0)
      ind=ind+1;
      if(ind==1)
         j=i;   %salvo indice del primo non 0
      end
   end
end

if(ind==1)
    ind=j;
    situa=1;
else
    situa=0;
end

end