%无约束信道容量
function [I] = unconstrained (Ns, H, sigma_n, rho)

FrfFbb = Fopt(Ns, H); %FrfFbb是最优预编码矩阵
Wmmse = Wopt(Ns, H, FrfFbb, sigma_n, rho); %接收端使用Wmmse

Rn = sigma_n.^2 * (Wmmse' * Wmmse);
I = log(det(eye(Ns) + (rho/Ns) * (Rn \ Wmmse' * H * (FrfFbb * FrfFbb') * H' * Wmmse)))/log(2);

end