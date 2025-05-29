function [ans] = ass2fi(inQ)
if inQ < 90 
    Q=inQ;
elseif inQ < 180
    Q=inQ-90;
elseif inQ < 270
     Q=inQ-180;
else
    Q=inQ-270;
end

WI = 10;
WF = 20;
WL = WI + WF;

WImult = WI*2;
WFmult = WF*2;
WLmult = WImult + WFmult;

WIsum = WImult + 1;
WFsum = WFmult;
WLsum = WIsum + WFsum;

SIGNED = 1;

mathRules = fimath('ProductMode', 'SpecifyPrecision',...
                   'ProductWordLength', WLmult, ...
                   'ProductFractionLength', WFmult, ...
                   'SumMode', 'SpecifyPrecision', ...
                   'SumWordLength', WLsum, ...
                   'SumFractionLength', WFsum,...
                   'OverflowAction', 'Wrap', ...
                   'RoundingMethod', 'Floor');




angrad= [];
angrad(1)=atan(1);

for i=1:100
    angrad=[angrad atan(2^(-i))];
end
angdeg= angrad.*(180/(pi));
angrad= fi(angrad, SIGNED, WL, WF, mathRules);
angdeg= fi(angdeg, SIGNED, 22, 11, mathRules);


%Q=120;
q=Q*(pi/180);

as=sin(q);
ac=cos(q);

nl=10;
k=[];
k(1)=vpa(1/vpa((2)^(1/2)));

for i=2:nl
    k(i)=k(i-1)*(vpa((1/((1+(double(2^(-i+1)))^2)^(1/2)))));
end


rx=fi(0.607252935, SIGNED, 2+WF, WF, mathRules);
ry=fi(0, SIGNED, 2+WF, WF, mathRules);

%below commented code is used to write all required values for cordic module in verilog 

%{
cd C:\Users\rgankidi4464\Desktop\
cd memfile
fid=fopen("cordic.txt","w+")
fprintf(fid,'%s\n',bin(rx))
for i=1:10
fprintf(fid,'%s\n',bin(angdeg(i)))
end
fclose(fid)
%}

d=1;

lq=fi(0, SIGNED, WL, WF, mathRules);

rxn=0;
ryn=0;


for i=1:(nl) 
    if lq<Q
        d=1;
        rxn=rx-(ry/(pow2(i-1)));
        ryn=ry+(rx/(pow2(i-1)));
        lq=lq+angdeg(i);
    elseif lq >= Q
        d=-1;
        rxn=rx+(ry/(pow2(i-1)));
        ryn=ry-(rx/(pow2(i-1)));
        lq=lq-angdeg(i);
    end
    rx=rxn;
    ry=ryn;
end
%k=0.60725293;
rx=rx;
ry=ry;

if inQ < 90 
    ans =[rx, ry] ;
elseif inQ < 180
    ans =[-ry, rx] ;
elseif inQ < 270
     ans =[-rx, -ry] ;
else
    ans =[ry, -rx] ;
end


%bin(fi(Q, SIGNED, 32, 16, mathRules))



