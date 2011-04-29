function V = contrasten(V)

% Same preprocessing as Stan Li et al
minval = min(V);
V = V - ones(size(V,1),1)*minval;
maxval = max(V);
V = (V*255) ./ (ones(size(V,1),1)*maxval);