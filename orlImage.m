function s = orlImage(fname)

imloadfunc = 'pgma_read';

reducesize = 1; 

% Create the data matrix
if reducesize, 
    s = zeros(46*56,1); 
else
    s = zeros(92*112,1);
end

switch imloadfunc,
	case 'pgma_read',
	  I = pgma_read(fname);
	otherwise,
	  I = imread(fname);
end

if reducesize,
	s = reshape(imresize(I,0.5,'bilinear'),[46*56, 1]);
else
	s = reshape(I,[92*112, 1]);
end


% Same preprocessing as Stan Li et al
minval = min(s);
s = s - ones(size(s,1),1) * minval;
maxval = max(s);
s = (s*255) ./ (ones(size(s,1),1) * maxval);

% Additionally, this is required to avoid having any exact zeros:
% (divergence objective cannot handle them!)
s = max(s,1e-4);

% Finally, divide by 10000 to avoid too large values for nmfsc algorithm
s = s/10000;

% Done!
