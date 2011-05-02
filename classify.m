function res = classify(W, H, TR, TE, measure, mode, epsilon, show)

testN = size(TE, 2);
trainN = size(H, 2);
pixels = size(TR, 1);

%let's project the TE in the subspace formed by W
P = project_on_subspace(TE, W, mode, epsilon);

res = zeros(1, testN);
%for each projected sample
for i=1:testN,
    
    max = -1;
    %using the cosine similarity on with each h
    for j=1:trainN,
        if strcmp(measure, 'cos'),
            cos = (P(:, i)' * H(:, j))/(norm(P(:, i),2)*norm(H(:,j), 2));
            if cos > max,
                max = cos;
                res(i) = j;
            end
        end
    end
end

if show,
    %creating a finalvisualization matrix
    F = zeros(pixels, testN * 2);
    for i=1:testN,
        F(:, i*2 - 1) = TE(:, i);
        F(:, i*2) = TR(:, res(i));
    end
    figure(10);
    visual2(F, 1, 2, 56);
end