clear


y= [];
y(1)=atan(1);

for i=1:100
    y=[y atan(2^(-i))];
end

x= y.*(180/(pi));

Q=58;
q=Q*(pi/180);

as=sin(q);
ac=cos(q);

nl=10
k=[];
k(1)=(1/((2)^(1/2)))

for i=2:nl+1
    k(i)=k(i-1)*((1/((1+(double(2^(-i+1)))^2)^(1/2))));
end
rx=0.607252935
ry=0;

d=1;

lq=0;
rxn=0;
ryn=0;


for i=1:(nl)
    if lq<Q
        d=1;
        rxn=rx-(ry/(pow2(i-1)));
        ryn=ry+(rx/(pow2(i-1)));
        lq=lq+x(i);
    elseif lq >= Q
        d=-1;
        rxn=rx+(ry/(pow2(i-1)));
        ryn=ry-(rx/(pow2(i-1)));
        lq=lq-x(i);
    end
    rx=rxn;
    ry=ryn;
end

rx=rx;
ry=ry;



als=sin(lq*(pi/180));
alc=cos(lq*(pi/180));



