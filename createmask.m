function M = createmask(orig, res, tol)

pixels = size(orig, 1);

%scaling the original image and the residual in 0-255

O = scaledata(orig, 0,255);
R = scaledata(res, 0,255);

%creating the mask
M = zeros(pixels, 1);

for i=1:pixels,
    if abs(O(i, 1) - R(i, 1)) <= tol,
        M(i, 1) = 255;
    else
        M(i, 1) = 0;
    end
end