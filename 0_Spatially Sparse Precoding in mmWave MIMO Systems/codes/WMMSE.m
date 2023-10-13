function [Wmmse] = WMMSE(Ns, H, FRF, FBB, sigma_n, rho)

% Calculate Wmmse for SS combining  %翻译：计算 SS 组合的 Wmmse
%公式20

[Nr, ~] = size(H * FRF * (FBB * FBB') * FRF' * H');

Esy = (sqrt(rho)/Ns) * FBB' * FRF' * H';
Eyy = (rho/Ns) * H * FRF * (FBB * FBB') * FRF' * H' + sigma_n.^2 * eye(Nr);

Wmmse = (Esy / Eyy)';

end