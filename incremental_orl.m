function [W,H] = incremental_orl(V, thresh, epsilon, maxiter, pixel_diff, fname, rnd)
samples = size(V,2);
pixels = size(V,1);

VE = [V(:,1)];
W = [V(:,1)];
H = 1;
iter = 0;
for i=2:samples,
    iter = iter + 1;
    fprintf('\n\niter: %d v %d w %d h %d\n\n', iter, size(VE,2), size(W,2), size(H,2));
    %this is the new sample
    v_new = V(:,i);
    Wold = W;
    Hold = H;
    %let's see what's in the basis
    [W, H, VE] = inmf(VE, v_new, W, H, maxiter, epsilon);
    %get its representation
    K = W * H(:, i);
    %create the mask
    mask = createmask(v_new, K, pixel_diff);
    %extract the common area
    n = extractMask(v_new, mask);
    %check the percentage of covered area
    perc = 0;
    for j=1:pixels,
        if (mask(j) == 255)
            perc = perc + 1;
        end
    end
    tot_perc = perc / pixels;
    fprintf('perc %f\n', tot_perc);
    if tot_perc <= thresh,
        W = Wold;
        H = Hold;
        VE = VE(:,1:iter);
        minW = min(W(:));
        maxW = max(W(:));
        if rnd,
            n = abs(randn(pixels, 1));
        end
        N = scaledata(n, minW, maxW);
        W = [W, N];
        [W, H, VE] = inmf(VE, v_new, W, H, maxiter, epsilon);
    end
    
    save(fname, 'W', 'H', 'VE');
    
end