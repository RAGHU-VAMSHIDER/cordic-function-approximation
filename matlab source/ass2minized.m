



WI = 8;
WF = 8;
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

 %% Example script for reference design
port_list = instrfindall;
    if(~isempty(port_list))
        fclose(port_list) 
    end
 data_in = 0:360/256:360;%generating in put values
 %data_in = 0:10:360;for verilog testbench

LOOP_INPUTS = numel(data_in);% total lenght 
looplim = 512;% elemets in loop limit to 512
 loopleft=LOOP_INPUTS; % left over elements to send
 varloop=0; % vareable 
 var=0;
 minized_output = [];
load('HW1_Input.mat', 'sample_data')
%Find open serial ports and close them
while (loopleft>0)
     if (loopleft > looplim ) % varloop = min (looplim, loopleft)
         varloop = looplim ;
     else 
         varloop=loopleft;
     end
	loopleft=loopleft-looplim;

    

    %Define the serial port of the minized device
    device = serial('COM4', 'BaudRate', 115200, 'InputBufferSize', 65536);
    %device = serial('COM4', 'BaudRate', 115200);
    
    
    %Make the values char array
    
    expected_bytes = varloop * 8;
    
    %data_in = [];
    %data_in = int32([sample_data(1+var:varloop+var) zeros(1, looplim - varloop)]); 
    %filling gap to make multiple of 512 elements 
    
    %Convert them to character vectors
    data_char = [];
    data_char = vec2char(fi(data_in, 1, 32, 16));
    % input sent is sign extended to 32 bit filling extra 16 bits with sign
    % where module only takes first 16 bits
    
    %Open the device
    fopen(device);
    
    %Send the data to the device
    writechar2device(device, data_char);
    
    %
    %Check if there are bytes available in the read buffer
    while(device.BytesAvailable < expected_bytes)
    end
    %bytesAvail = device.BytesAvailable;
    
    
    %Read the data as chars
    hex_digits = char(fread(device, expected_bytes))';
    %hex_digits = char(fread(device, bytesAvail))';
    %Here we simply reshape into 8xnumel(data_in) and then transpose it so that
    %we end up at numel(data_in) number of rows and  m  m
    hex_digits = reshape(hex_digits, [4,numel(data_in)*2])';%%%%%%%%%%%%%%%%%%%%made change in hex2fi.m
    %hex_digits = reshape(hex_digits, 4,[])';
    
    
    %%Converting the hex digits to a value
    minized_output = [minized_output hex2fi(hex_digits, 16, 8, 1)];

    var = var+ varloop; % count variable 
    
    port_list = instrfindall;
    if(~isempty(port_list))
        fclose(port_list) 
    end
end

minized_output = reshape(minized_output, 2,[])';
  
cordsincos = [];
for i = data_in 
cordsincos = [cordsincos ass2fi(i)];
end
cordsincos = reshape(cordsincos, 2,[])';



%%%%%%%%%%%%%%%%%  minized vs cordic fix (2,8)
figure();
%cos
subplot(3,1,1);
plot (minized_output(:,1), '-b', 'LineWidth', 2);

subplot(3,1,2);
plot( cordsincos(:,1), '-r', 'LineWidth', 2 );

subplot(3,1,3);
plot(cordsincos(:,1)-minized_output(:,1));



figure();
%sin
subplot(3,1,1);
plot (minized_output(:,2), '-b', 'LineWidth', 2);

subplot(3,1,2);
plot( cordsincos(:,2), '-r', 'LineWidth', 2 );

subplot(3,1,3);
plot(cordsincos(:,2)-minized_output(:,2));
 


truesincos = [];
for i = data_in 
truesincos = [truesincos cos(i*(pi/180)), sin(i*(pi/180))];
end
truesincos = reshape(truesincos, 2,[])';



%%%%%%%%%%%%%%%%% minized vs true
figure();
%cos
subplot(3,1,1);
plot (minized_output(:,1), '-b', 'LineWidth', 2);

subplot(3,1,2);
plot( truesincos(:,1), '-r', 'LineWidth', 2 );

subplot(3,1,3);
plot(truesincos(:,1)-minized_output(:,1));



figure();
%sin
subplot(3,1,1);
plot (minized_output(:,2), '-b', 'LineWidth', 2);

subplot(3,1,2);
plot( truesincos(:,2), '-r', 'LineWidth', 2 );

subplot(3,1,3);
plot(truesincos(:,2)-minized_output(:,2));



%%%%%%%%%%%%%%%%%  true vs cordic fix (2,8)
figure();
%cos
subplot(2,1,1);
plot(truesincos(:,1)-cordsincos(:,1));


%sin
subplot(2,1,2);
plot(truesincos(:,2)-cordsincos(:,2));