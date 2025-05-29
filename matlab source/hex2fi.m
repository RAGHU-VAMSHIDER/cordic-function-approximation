function [fiValues] = hex2fi(hex_digits, WL, WF, SIGNED)
%HEX2FI converts a set of hex_digits into its corresponding WL-bit fi
%representation
    N = size(hex_digits, 1);
    fiValues = fi(zeros(1, N), SIGNED, WL, WF);
    for k = 1 : N
		%bin_str = dec2bin(hex2dec(hex_digits(k, :)), 32);%%%%%%%%%%%%%%%this line is changed
        bin_str = dec2bin(hex2dec(hex_digits(k, :)), WL);
        bin_str = bin_str(end-(WL-1):end);
        temp_fi = fiValues(k);
        temp_fi.bin = bin_str;
        fiValues(k) = temp_fi;
    end

end


