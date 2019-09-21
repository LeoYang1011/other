clear;clc;
mkdir('boundaryData/inlet')
%% read measure data
dt = 0.05;
freeSurface_z = 0;
distance = 0;
waveMeasured_all = load('YU1_22.TSR');
waveMeasured_use = waveMeasured_all(:,1);
zCoordinate = csvread('inlet0.csv',1,0);
zCoordinate = sortrows(zCoordinate,3);
make_point(zCoordinate);
zCoordinate = zCoordinate(1:length(zCoordinate)/2,2);
%% resize measure data
numFFT_pow = 1;
while 1
    if 2^numFFT_pow < 6000%length(waveMeasured_use)
        numFFT_pow = numFFT_pow + 1;
    else
        break;
    end
end
numFFT_use = 2 ^ (numFFT_pow - 1) ;
waveMeasured_use = waveMeasured_use(87:numFFT_use+86);
waveMeasured_use = waveMeasured_use - mean(waveMeasured_use);
%% RMS of row measure data
%rmsRaw = sqrt(sum((waveMeasured_use - mean(waveMeasured_use)).^2) / numFFT_use);
%% frequency resolution
omega = (0:numFFT_use - 1) / numFFT_use * (2 * pi / dt);
%% calculate rU and rW
result = make_velocity(omega,freeSurface_z,zCoordinate);
rU = result{1};
rW = result{2};
waveNum = result{3};
%% Window function
fftWindow = ones(numFFT_use,1);
for i = 1:numFFT_use
    if i <= floor(0.05 * numFFT_use) - 1
        fftWindow(i) = 0.5 * (1 - cos(2 * pi * i / (0.2 * numFFT_use)));
%      elseif i >= ceil(0.9 * numFFT_use)
%          fftWindow(i) = 0.5 * (1 - cos(2* pi * (numFFT_use - i - 1)/(0.2 * numFFT_use)));
    end
end
% modified by window function and RMS of modified value
waveMeasured_use = waveMeasured_use .* fftWindow;
%rmsModified = sqrt(sum((waveMeasured_use - mean(waveMeasured_use)).^2) / numFFT_use);
rat = 1.0;
% if rmsModified > 0.0001
%     rat = sqrt(rmsRaw/rmsModified);
% end
%% FFT
fftValue = fft(waveMeasured_use) / numFFT_use;
%% º∆À„eta
eta = zeros(numFFT_use,1);
for i = 1:numFFT_use
    time = (i - 1) * dt;
    for j = 2:numFFT_use/2
%         eta(i) = eta(i) + (real(fftValue(j)) * cos(omega(j)*time) - imag(fftValue(j)) * sin(omega(j)*time)) * rat;
        eta(i) = eta(i) + (real(fftValue(j)) * cos(waveNum(j)*distance+omega(j)*time) - imag(fftValue(j)) * sin(waveNum(j)*distance+omega(j)*time)) * rat;
    end
    eta(i) = eta(i) * 2;
end
%% calculate U and W
U = zeros(length(zCoordinate),numFFT_use);
W = zeros(length(zCoordinate),numFFT_use);
for i = 1:length(zCoordinate)
    for j = 1:numFFT_use
        time = (j - 1) * dt;
        for k = 2:numFFT_use/2
            if zCoordinate(i) <= waveMeasured_use(j) + freeSurface_z
                etaU = (real(fftValue(k)) * cos(waveNum(k)*distance+omega(k)*time) - imag(fftValue(k)) * sin(waveNum(k)*distance+omega(k)*time)) * rat;
                etaW = (real(fftValue(k)) * sin(waveNum(k)*distance+omega(k)*time) + imag(fftValue(k)) * cos(waveNum(k)*distance+omega(k)*time)) * rat;
            else
                etaU = 0;
                etaW = 0;
            end
            U(i,j) = U(i,j) + etaU * rU(i,k);
            W(i,j) = W(i,j) + etaW * rW(i,k);
        end
        U(i,j) = U(i,j) * 2;
        W(i,j) = W(i,j) * 2;
    end
end

make_file(U,W,dt)

plot(eta,'b')
hold on
plot(waveMeasured_use,'r')
legend('Calculated','Measured')


