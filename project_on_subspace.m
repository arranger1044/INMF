function P = project_on_subspace(X, W, mode, epsilon)

if strcmp(mode, 'pinv'),
    % COmputo la pseudo inversa di Moore-Penrose della matrice delle basi
    P = max(0, pinv(W) * X);
elseif strcmp(mode, 'molt'),
    % Aggiorno H mantenendo W fissa
    keepGoing = 1;
    samples = size(X,2);
    factors = size(W,2);
    P = abs(randn(factors, samples));
    iter = 0;
    while keepGoing,
        Pold = P;
        P = P.*((W'*X)./(W' * W * P + 1e-9));
        %P = P.*(W'*(X./(W*P + 1e-9)))./(sum(W)'*ones(1,samples));
        absDIFF = abs(P - Pold);
        maxDIFF = max(absDIFF(:));
        iter = iter + 1;
        if (maxDIFF <= epsilon),
            keepGoing = 0;
            fprintf('iter: %d diff: %f\n', iter, maxDIFF);
        end
    end
end