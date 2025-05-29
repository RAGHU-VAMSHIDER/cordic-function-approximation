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




a = 0:10:360;
cd C:\Users\rgankidi4464\Desktop\
cd memfile
fid1=fopen("corditest.txt","w+")
for i= a
fprintf(fid1,'%s\n',bin(fi(i, SIGNED, 32, 16, mathRules)));
end
fclose(fid1);

expected_bytes = (numel(a))* 8;
cd C:\Users\rgankidi4464\Desktop\
cd memfile
fid2=fopen("cordicwrite.txt","r")
%hex_digits = char(fread(fid2, expected_bytes))';
hex_digits= fscanf(fid2,"%s\n");
fclose(fid2)
cd C:\Users\rgankidi4464\Desktop\'Home Work'\system\

hex_digits = reshape(hex_digits, 4,[])';

vlogout = [];
vlogout = [vlogout hex2fi(hex_digits, 16, 8, 1)]; %%%%%%%%%%%%%%%%%%%%5%made change in hex2fi.m
vlogout = reshape(vlogout, 2,[])';

cordsincos = [];
for i = a 
cordsincos = [cordsincos ass2fi(i)];%function call cordic fixed point
end
cordsincos = reshape(cordsincos, 2,[])';



figure();
%cos
subplot(3,1,1);
plot (vlogout(:,1), '-b', 'LineWidth', 2);

subplot(3,1,2);
plot( cordsincos(:,1), '-r', 'LineWidth', 2 );

subplot(3,1,3);
plot(cordsincos(:,1)-vlogout(:,1));



figure();
%sin
subplot(3,1,1);
plot (vlogout(:,2), '-b', 'LineWidth', 2);

subplot(3,1,2);
plot( cordsincos(:,2), '-r', 'LineWidth', 2 );

subplot(3,1,3);
plot(cordsincos(:,2)-vlogout(:,2));