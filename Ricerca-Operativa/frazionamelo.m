function [fra] = frazionamelo(numero)

dire='';
coeff=numero;
coeff=sym(coeff,'r');
[numera,denomina]=numden(coeff);
dire=[dire,string(numera)];
if(denomina ~=1)
    dire=[dire,'/'];
    dire=[dire,string(denomina)];
end

dire=string(strjoin(dire));
fra=dire;

end