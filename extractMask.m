function N = extractMask(orig, mask)
pixels = size(orig,1);
N = zeros(pixels, 1);
for i=1:pixels,
    if (mask(i,1) == 0),
        N(i,1) = orig(i,1);
    else
        N(i,1) = 0;
    end
end