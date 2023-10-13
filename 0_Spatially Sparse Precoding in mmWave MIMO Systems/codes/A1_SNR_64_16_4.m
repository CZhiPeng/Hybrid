%SNR_64_16_4()，原文图3
clc;clear;
% # of antennas
Nt = 64;
Nr = 16;
sqrtNt = sqrt(Nt);%显然，是正方形的UPA阵列
sqrtNr = sqrt(Nr);

% #射频链个数
NtRF = 4; %发射端
NrRF = 4; %接收端

% 离开（到达）射线数,共80条子径
Ncl = 8;
Nray = 10;

std = pi/24; %角度扩展： 7.5

% SNR
sigma_n = 1;                       % 0dB
rhodB = -40 : 4 : 0;%SNR
rho = 10.^(rhodB/10); %平均功率(rho)

I1 = zeros(1000, length(rho));     % SS (Spatially Sparse) / Ns = 1时的信道容量
I2 = zeros(1000, length(rho));     % SS (Spatially Sparse) / Ns = 2
I3 = zeros(1000, length(rho));     % Unconstrained / Ns = 1
I4 = zeros(1000, length(rho));     % Unconstrained / Ns = 2

for i = 1 : length(rho)
    for l = 1 : 1000
        Atcell = ArrayResponse_cell(sqrtNt, Ncl, Nray, std); %Atcell是元胞数组，元素有Ncl个。每个元素(簇)有64(天线个数)*10(子径个数)
        Arcell = ArrayResponse_cell(sqrtNr, Ncl, Nray, std); %接收端导向矢量
        
        At = cell2mat(Atcell); %发射端导向矢量，因此有64(天线个数)行，10(子径个数)*8(簇的个数)共80列。论文中列的个数只有一个，但是其中两个角度都是变量，在matlab中要用有限的数字来表示变量，因此会有80列
        Ar = cell2mat(Arcell); %元胞数组转换为普通数组
        
        % CHANNEL Formation (Lines 39 ~ 51)
        H = zeros(Nr, Nt);
        
        for p = 1 : Ncl
            Atmat = Atcell{1,p};
            Armat = Arcell{1,p};
    
            for q = 1 : Nray
                alpha = sqrt(1/2) * (randn(1,1) + 1i * randn(1,1));
        
                H = H + alpha * Armat(:,q) * Atmat(:,q)';
            end
        
        end
        
        H = (sqrt(Nt * Nr) / norm(H, 'fro')) * H; %整体信道矩阵，公式4
        
        % SS - Spatial Sparse Precoding / Decoding
        I1(l,i) = SS(1, NtRF, NrRF, H, At, Ar, sigma_n, rho(i));
        I2(l,i) = SS(2, NtRF, NrRF, H, At, Ar, sigma_n, rho(i));
        
        % unconstrained - Unconstrained Precoding / Decoding
        I3(l,i) = unconstrained (1, H, sigma_n, rho(i));
        I4(l,i) = unconstrained (2, H, sigma_n, rho(i));    
    end
end

I1mean = mean(I1); %如果 A 为矩阵，那么 mean(A) 返回包含每列均值的行向量。
I2mean = mean(I2); %固定SNR，求解1000次下信道容量的平均值
I3mean = mean(I3);
I4mean = mean(I4);

x = plot(rhodB, I1mean, rhodB, I2mean, rhodB, I3mean, rhodB, I4mean);

x(1).LineWidth = 2; 
x(2).LineWidth = 2;
x(3).LineWidth = 2;
x(4).LineWidth = 2;

x(1).Marker = 'o';
x(2).Marker = 'o';
x(3).Marker = 's';
x(4).Marker = 's';

legend('SS Precoding & Combining, N_{s}=1', 'SS Precoding & Combining, N_{s}=2', 'Optimal Unstrained Precoding, N_{s}=1', 'Optimal Unstrained Precoding, N_{s}=2', 'Location', 'northwest');
title('Spatially Sparse Precoding  vs Unconstrained Optimum Precoding');
xlabel('SNR (dB)');
ylabel('Spectral Efficiency (bits/s/Hz)');
grid on;
