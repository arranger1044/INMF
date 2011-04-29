function V = orldata
% orldata - read face image data from orl database
%

%global 
imloadfunc = 'pgma_read';
    
% Reduces the size of the images (by a factor 0.5) 
% Set to 0 to avoid reducing. Set to 1 to reduce.
reducesize = 1; 
    
% This is where the cbcl face images reside
thepath = '../data/orl-faces/';

% Step through each subject and each image
fprintf('Reading in the images...\n');
i = 0;

% Get the number of directories
dirs = dir(thepath);
ndir = -2;

for i = 1:numel(dirs),
    if (dirs(i).isdir)
        ndir = ndir + 1;
    end
end

fprintf('%d\n', ndir);

totImgs = 0;
for subj=1:ndir,
    dirname = [thepath 's' num2str(subj) '/'];
    dirregex = [dirname '*.pgm'];
    imgNames = dir(dirregex);
    fprintf('%d ', numel(imgNames));
    totImgs = totImgs + numel(imgNames);
end
fprintf('\n Tot imgs %d tot dir %d\n', totImgs, ndir);


% Create the data matrix
if reducesize, 
    V = zeros(46*56,totImgs); 
else
    V = zeros(92*112,totImgs);
end

i = 0;
for subj=1:ndir,
    dirname = [thepath 's' num2str(subj) '/'];
    dirregex = [dirname '*.pgm'];
    imgNames = dir(dirregex);
    fprintf('i %d, subj %d, num %d', i, subj, numel(imgNames));
    for imag=1:numel(imgNames),
	i = i+1;
	fname = [dirname num2str(imag) '.pgm'];
	switch imloadfunc,
	 case 'pgma_read',
	  I = pgma_read(fname);
	 otherwise,
	  I = imread(fname);
	end
	if reducesize,
	    V(:,i) = reshape(imresize(I,0.5,'bilinear'),[46*56, 1]);
	else
	    V(:,i) = reshape(I,[92*112, 1]);
	end
    end
    fprintf('[%d/40]\n',subj);
end

fprintf('\n');

% Same preprocessing as Stan Li et al
minval = min(V);
V = V - ones(size(V,1),1)*minval;
maxval = max(V);
V = (V*255) ./ (ones(size(V,1),1)*maxval);

% Additionally, this is required to avoid having any exact zeros:
% (divergence objective cannot handle them!)
V = max(V,1e-4);

% Finally, divide by 10000 to avoid too large values for nmfsc algorithm
V = V/10000;

% Done!
