function [Wmmse] = Wopt (Ns, H, FrfFbb, sigma_n, rho)

% Calculate Wmmse for Unconstrained %翻译：计算无约束的 Wmmse
%

Esy = (sqrt(rho)/Ns) * FrfFbb' * H';

[Nr, ~] = size(H * (FrfFbb * FrfFbb') * H');
Eyy = rho/Ns * H * (FrfFbb * FrfFbb') * H' + sigma_n.^2 * eye(Nr);

Wmmse = (Esy / Eyy)';

end