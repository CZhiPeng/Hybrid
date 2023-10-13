function [Acell] = ArrayResponse_cell(N, Ncl, Nray, std)

% Generates Tx and Rx Array Response Vector Matrix 
%生成 Tx 和 Rx 阵列响应向量矩阵，角度是子径的方位角和俯仰角

% I/O
% N     square root of # of transmit antennas (Nt = N^2) %翻译：发射天线数量的平方根 (Nt = N^2)
% Ncl   # of clusters %翻译：簇数
% Nray  # of rays per cluster %翻译：每个簇的子径数

Acell = cell(1, Ncl); %gpt分析：创建一个单元格数组，其中包含1行和簇数列的单元格，用于存储各种类型的数据。 
PHI = zeros(1, Nray);  %簇中子径的方位角
THETA = zeros(1, Nray); %簇中子径的俯仰角

for i = 1 : Ncl  %Ncl是簇
    j = 1;
    k = 1;
    
    phimean = (2*pi) * rand(1,1); %每个簇中的平均方位角。rand(1,1)的作用是生成一个包含一个随机数的1x1矩阵（实际上是一个标量），这个随机数是在区间[0, 1)内均匀分布的
    thetamean = (pi) * rand(1,1); %每个簇中的俯仰角
    
    while j <= Nray
        phi = phimean + (std) * randl(1,1);   %子径的方位角= 簇中的平均方位角+偏移        
        
        if phi >= phimean - pi/6 && phi <= phimean + pi/6          % azimuth angle range = 60 deg  %翻译：方位角范围 = 60 度
            PHI(j) = phi;
            j = j + 1;
        end
    end
    
    while k <= Nray
        theta = thetamean + (std) * randl(1,1);    
        
        if theta >= thetamean - pi/18 && theta <= thetamean + pi/18   % elevation angle range = 20 deg %翻译：仰角范围 = 20 度
            THETA(k) = theta;
            k = k + 1;
        end
    end
    
    Amat = zeros(N.^2, Nray); %问：为什么是N的平方？ 答：因为这里的N的平方才是天线个数，导向矢量的行是Nt行。
    
    for l = 1 : Nray
        Amat(:,l) = ArrayResponse_vec(N, PHI(l), THETA(l)); %求每个子径的阵列响应。因为 每个子径的方位角和俯仰角不同，对应的天线阵列不同
    end
    
    Acell{1,i} = Amat;
    
end

end