function [fract] = partefraz(number)
if(number>=0)
    integ = fix(number);
else
    integ=fix(number)-1;
end
fract = number - integ;
%format rat;

end