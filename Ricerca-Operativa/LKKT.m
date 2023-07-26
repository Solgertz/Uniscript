function LKKT(f,g,h)
%FUNZIONE PRESA IN PRESTITO DA https://github.com/Guray00/IngegneriaInformatica/blob/master/SECONDO%20ANNO/II%20SEMESTRE/Ricerca%20operativa/RicOp.m
%SI RINGRAZIA IL REALIZZATORE
%LA SEGUENTE FUNZIONE è STATA MODIFICATA

varx=symvar(f);
syL = sym('l', size(g));
syM = sym('m', size(h));
syX = symvar([f;g;h]);

eqs = gradient(f,varx);
for i=1:size(g,1)
	eqs = eqs + syL(i)*gradient(g(i),varx);
end
for i=1:size(h,1)
	eqs = eqs + syM(i)*gradient(h(i),varx);
end
eqs = [eqs == 0];

for i=1:size(g,1)
	eqs = [eqs; syL(i)*g(i) == 0];
end 

eqs = [eqs; g<=0;h==0];

sol = solve(eqs,'Real', true);
x=[];l=[];m=[];
for i=1:length(syX)
	x = [x, sol.(string(syX(i)))];
end
for i=1:length(syL)
	l = [l, sol.(string(syL(i)))];
end
for i=1:length(syM)
	m = [m, sol.(string(syM(i)))];
end


dire="\section{Soluzione LKKT}";
sistemalkkt=latex(eqs);
sistemalkkt(1:6)=[];sistemalkkt=sistemalkkt(1:7)+"cases"+sistemalkkt(13)+sistemalkkt(17:length(sistemalkkt)-14)+"{cases}";
soluzlkt="Le soluzioni (per riga) sono: $$"+matrivetlate(x,"x^*",0)+"\quad "+matrivetlate(l,"\lambda^*",0)+"\quad "+matrivetlate(m,"\mu^*",0)+"$$";
dire=dire+"$$"+sistemalkkt+"$$"+soluzlkt;
stampalatex(dire);

end