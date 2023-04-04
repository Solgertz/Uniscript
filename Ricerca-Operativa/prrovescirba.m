clc
clear
%A=[1,1;2,2];
%fprintf('A=');
%disp(sprintf(A));
%disp(A);

%xlabel('$\varphi$','Interpreter','latex');

%{
figure
set(gcf, 'color', 'white'), axis off     %Remove axes and set white background
my_text = '$$f_n={x \over \sqrt{2}}$$';  %formula Latex
text('units', 'inch', 'position', [-0.5 3.5], 'fontsize', 14, 'color', 'k', ...
    'interpreter', 'latex', 'string', my_text);


s="ciao"+"a"+" "+b;
disp(s);
%}

%latex_table = latex(sym(A))
%\pmatrix{1 & 2 \cr 3 & 4}  -> matrici classiche

%{
figure
set(gcf, 'color', 'white'), axis off     %Remove axes and set white background
my_text = '$$\begin{equation} \left\{ \begin{array}{@{}l@{}} a=3\\ b=3 \end{array}\right.\end{equation}$$';  %formula Latex
text('units', 'inch', 'position', [-0.5 3.5], 'fontsize', 14, 'color', 'k','interpreter', 'latex', 'string', my_text);

%}
%{
% Creazione della matrice
A = [1 2; 3 4];

% Creazione della stringa da visualizzare
% Creazione del sistema di equazioni
a11 = 2; a12 = 3; a21 = 4; a22 = 5; b1 = 1; b2 = 2;
latex_string = ['$$\begin{bmatrix}a & b \\c & d \end{bmatrix}$$'];


% Creazione della figura
figure();
text(0.5, 0.5, latex_string, 'Interpreter', 'latex');


%}

%{
H = tf([1],[1 2 2]);
nyquist(H)
%}

%setenv('PATH', ['C:\texlive\2023\bin\windows;' getenv('PATH')]);

%open("provina.pdf")

%{
dfile ='temp.tex';
if exist(dfile, 'file')  
    delete(dfile); 
end

diary temp.tex

disp("\documentclass[]{article}"+...
      "\begin{document}"+...
        "\begin{equation}"+...
            "\left\{"+...
                "\begin{array}{@{}l@{}}"+...
                    "a=3\\"+...
                    "b=n"+...
                 "\end{array}"+...
            "\right."+...
        "\end{equation}"+...
        "\end{document}");

diary off
!pdflatex temp.tex
open("temp.pdf");
%}
%{
A=sym([1,1;1,2]);

var=latex(A)
%}

l=7/3;
latex(sym(l,'d'))


