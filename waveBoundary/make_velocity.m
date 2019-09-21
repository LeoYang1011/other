function output = make_velocity(omega,freeSurface_z,zCoordinate)
%% declare
waterDepth = freeSurface_z - zCoordinate(1); 
lengthNum = length(omega)/2;
rU = zeros(length(zCoordinate),lengthNum);
rW = zeros(length(zCoordinate),lengthNum);
waveNum = ones(lengthNum,1);
%% calculate wave number
for i = 1:lengthNum
    waveNum_temp = 0;
    while abs(waveNum(i) - waveNum_temp) > 0.00001
        waveNum_temp = waveNum(i);
        period = 2 * pi / omega(i);
        waveLength = 9.81 * period^2 / (2*pi)* tanh(waveNum_temp * waterDepth);
        waveNum(i) = 2 * pi / waveLength;
    end
end
%% calculate rU and rW
for i = 1:length(zCoordinate)
    for j = 1:lengthNum
        numeratorCosh = cosh(waveNum(j) * zCoordinate(i));
        numeratorSinh = sinh(waveNum(j) * zCoordinate(i));
        denominatorSinh = sinh(waveNum(j) * waterDepth);
        rU(i,j) =  numeratorCosh / denominatorSinh * omega(j);
        rW(i,j) =  numeratorSinh / denominatorSinh * omega(j);
    end
end
%% return
output = {rU,rW,waveNum};
end

