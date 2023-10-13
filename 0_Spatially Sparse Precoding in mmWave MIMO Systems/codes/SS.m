function [I] = SS(Ns, NtRF, NrRF, H, At, Ar, sigma_n, rho)

% Spatially Sparse 

[FRF, FBB] = SSprecoder(Ns, NtRF, H, At);
[WRF, WBB] = SScombiner(Ns, NrRF, H, Ar, FRF, FBB, sigma_n, rho);

Rn = sigma_n.^2 * WBB' * (WRF' * WRF) * WBB;
I = log(det(eye(Ns) + (rho/Ns) * (Rn \ WBB' * WRF' * H * FRF * (FBB * FBB') * FRF' * H' * WRF * WBB)))/log(2);
% 公式3，信道容量公式

end