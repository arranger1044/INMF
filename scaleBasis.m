function S = scaleBasis(W, H, V)
K = W * H;
maxV = max(V);
minV = min(V);
%maxK = max(K);
%minK = min(K);


cols = size(V, 2);
rows = size(V, 1);

S = zeros(rows, cols);
for j = 1:cols,
    S(:, j) = scaledata(K(:,j),minV(j), maxV(j));
end