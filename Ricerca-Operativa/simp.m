function [basef,ragionamento] = simp(A,Ab,An,b,bn,funz_ob,x,y,base,N,tipo)
%tipo indica se algoritmo primale('p') o duale ('d')

%Funzioni usate: matrivetlate()

ragionamento=" \section{Ragionamento: } ";

emerit=sym(inv(Ab));
W=-(emerit);%1,2 -> 3,5 della base 

l=length(base);
%base,x,y,fo,h,rapporti,k
if(tipo=='p')
    
    
    ragionamento=ragionamento+" $$ "+matrivetlate(Ab,"A_b",0)+" \quad "+matrivetlate(emerit,"A_b^{-1}",0)+" \quad W=\overset{"+latex(sym(base))+"}{"+latex(sym(W))+"} $$ ";
    
    lisa=y;
    lisa(N)=[]; %y di base (tanto gli altri sono 0)
    P=1;
    for i=1:l
        if(P==1 && lisa(i)<0) %prendo y_i<0 con i minimo
            h=base(i);
            hprima=i;
            P=P+1;
        end
    end
    Wparticolare=W(:,hprima); meme="w^"+h;
    ra=An*Wparticolare;%6*2 per 2*1 = 6*1
    ragionamento=ragionamento+" $$ "+matrivetlate(x,"x",0)+" \quad "+matrivetlate(y,"y",0)+" \quad "+matrivetlate(Wparticolare,meme,0)+" $$ ";
    
    meme1="A_n \cdot "+meme;
    ragionamento=ragionamento+" $$ "+matrivetlate(ra,meme1,0)+" $$ ";

    %An*w
    j=1;
    for i=1:size(An,1)
        if (ra(i,:)>0)
            rindex(j)=N(i);%mi salvo gli indici rispetto a N
            rapper(j)=ra(i,:);%mi salvo i valori
            j=j+1;
        end
    end
    j=j-1;%numero di moltiplicatori
    ragionamento=ragionamento+" $$ ";
    for i=1:j
        par1=b(rindex(i));
        par2=A(rindex(i),:)*(x);
        par3=rapper(i);
        r(i)=(par1-par2)/par3;

        meme2=" r_"+i+"=\frac{";
        ragionamento=ragionamento+meme2+latex(sym(par1))+"-"+latex(sym(par2))+"}{"+latex(sym(par3))+"}="+latex(sym(r(i))) +" \quad ";

    end
    ragionamento=ragionamento+" $$ ";
    
    [~,k]=min(r);
    k=rindex(k);

    for i=1:length(base)
        if(base(i)~=h)
            vero=base(i);
        end
    end
    
   
else

    %V=(An*x)>bn;
    V=(An'*x);
    j=1;
    for i=1:length(V)
        if (j==1 && V(i)>bn(i))
            k=N(i);
            j=j+1;
        end
    end

    Ak=(A(:,k))'; meme3="A^"+k;
    veh=Ak*W;%2*1 per 2*2=1*2
    ragionamento=ragionamento+" $$ "+matrivetlate(Ab,"A_b",0)+" \quad "+matrivetlate(emerit,"A_b^{-1}",0)+" \quad W=\overset{"+latex(sym(base))+"}{"+latex(sym(W))+"} $$ ";
    ragionamento=ragionamento+" $$ "+matrivetlate(An,"A_n",0)+" \quad " +matrivetlate(x,"x",0)+" \quad "+matrivetlate(bn,"b_n",0)+" \quad "+matrivetlate(Ak,meme3,0)+" $$ ";
    ragionamento=ragionamento+" $$ "+matrivetlate(x,"x",0)+" \quad "+matrivetlate(y,"y",0)+" $$ ";

    meme4=meme3+" \cdot w^i";
    ragionamento=ragionamento+" $$ "+matrivetlate(veh,meme4,0)+" $$ ";

    j=1;
    for i=1:length(veh)
        if (veh(:,i)<0)
            disel(j)=veh(i);
            rindex(j)=base(i);%mi salvo gli indici rispetto
            j=j+1;
        end
    end
    if(j==1)%fo(min)=-inf
        disp('fo(min)=-inf');
        ragionamento=ragionamento+" $$\forall i\; "+meme4+"\geq 0 \rightarrow fo=-\infty$$ ";
    end
    
    j=j-1;%numero di moltiplicatori
    ragionamento=ragionamento+" $$ ";

    for i=1:j
        par1=y(rindex(i));
        par2=disel(i);
        r(i)=(-par1)/par2;
        meme5=" r_"+i+"=\frac{";
        ragionamento=ragionamento+meme5+"-"+latex(sym(par1))+"}{"+latex(sym(par2))+"}="+latex(sym(r(i))) +" \quad ";
    end
    ragionamento=ragionamento+" $$ ";

    
    [~,h]=min(r);%il primo minimo
    h=rindex(h);

    for i=1:length(base)
        if(base(i)~=h)
            vero=base(i);
        end
    end

end
gnamgnam="Primale ";
if(tipo=='d')
    gnamgnam="Duale ";
end

ragionamento=ragionamento+" \section{Simplesso "+gnamgnam+" } ";
ragionamento=ragionamento+" Indici di base: $"+matrivetlate(base,"B",0)+"$ \\";
ragionamento=ragionamento+matrivetlate(x,"x",1)+" \\ ";
ragionamento=ragionamento+" Valore F.O:  $"+latex(sym(funz_ob))+"$ \\ ";
ragionamento=ragionamento+matrivetlate(y,"y",1)+" \\ ";
ragionamento=ragionamento+" k(entrante):  $"+latex(sym(k))+"$ \\ ";
ragionamento=ragionamento+" h(uscente):  $"+latex(sym(h))+"$ \\ ";
basef=[k,vero];
ragionamento=ragionamento+" Nuova Base: $"+ matrivetlate(basef,"B_f",0) + "$ \\ ";

end