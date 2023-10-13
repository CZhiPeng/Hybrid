%返回最优预编码矩阵
function [V1] = Fopt (Ns, H)

% Calculates Unconstrained Unitary Precoder

[~, Nt] = size(H); %计算H的列数，即发射天线个数
V1 = zeros(Nt, Ns);

[~, ~, V] = svd(H);

for i = 1 : Ns
    V1(:,i) = V(:,i);
end

end