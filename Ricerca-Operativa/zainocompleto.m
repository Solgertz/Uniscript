function zainocompleto(valore,peso,P)
    dire="\section{ZAINO INTERO} ";
    [~,~,~,~,intero] = zaino(valore,peso,P,'i');
    dire=dire+" "+intero+"\section{ZAINO BINARIO}";
    [~,~,~,~,binario] = zaino(valore,peso,P,'b');
    dire=dire+" "+binario;
    stampalatex(dire);
end