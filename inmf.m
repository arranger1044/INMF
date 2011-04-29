function [W, H, V] = inmf(V, v_k, W, H, maxiter, epsilon)

% Dimensions
vdim = size(V,1);
samples = size(V,2);
rank = size(W,2);
H_eight = size(H,1);

% Checking if W number of columns matches H number of rows
if rank ~= H_eight,
    %diff = rank - H_eight;
    newH = zeros(rank, samples);
    newH(1:H_eight,:) = H(1:H_eight,:);
    H = newH;
    %fill
%     E = [V, v_k] - W * H;
% else
%     E = V - W * H;
end

%v_k = V(:, end);
VH = V * H';
HH = H * H';

% Calculate initial objective

objhistory = 0;%0.5 * sum(diag( (E)' * (E)));

%h_k = zeros(rank , 1);
h_k = abs(randn(rank,1));
iter = 0;
keepGoing = 1;
while keepGoing,
    
    % Show progress
%     fprintf('[%d]: %.5f \n',iter,objhistory(end));    
    
    % Update iteration count
    iter = iter+1;    
    
%     % Save old values
%     Wold = W;
%     Hold = H;
    
    h_k = h_k .* ((W' * v_k)./(W' * W * h_k + 1e-9 ));
    W = W .* ((VH + v_k * h_k') ./ (W * (HH + h_k * h_k') + 1e-9));
    
%     % Calculate objective
%     e = v_k - W * h_k;
%     newobj = objhistory(1) + 0.5 * sum(diag( (e)' * (e)));
%     objhistory = [objhistory newobj];
    
    if iter >= maxiter,
        keepGoing = 0;
    end
end

V = [V, v_k];
H = [H, h_k];