function visual2( W, mag, cols, ysize )
% visual - display a basis for image patches
%
% W        the basis, with patches as column vectors
% mag      magnification factor
% cols     number of columns (x-dimension of map)
% ysize    [optional] height of each subimage
%
    
%minW = min(W);
%maxW = max(W);
    

% This is the side of the window
if ~exist('ysize'), 
    ysize = sqrt(size(W,1)); 
    fprintf('ysize %d\n', ysize );
end

wcol = size(W,2);
wrow = size(W,1);
S = zeros(wrow, wcol);
for i=1:wcol,
    S(:,i) = scaledata(W(:,i), 0, 255);
end

bgval = 255/2;
xsize = size(W,1)/ysize;
fprintf('xsize %d ysize %d\n', xsize, ysize );

% Helpful quantities
xsizem = xsize-1;
xsizep = xsize+1;
ysizem = ysize-1;
ysizep = ysize+1;
rows = ceil(size(W,2)/cols);

% Initialization of the image
I = bgval*ones(2+ysize*rows+rows-1,2+xsize*cols+cols-1);

for i=0:rows-1
  for j=0:cols-1
    
    if i*cols+j+1>size(W,2)
      % This leaves it at background color
      
    else
      % This sets the patch
      I(i*ysizep+2:i*ysizep+ysize+1, ...
	j*xsizep+2:j*xsizep+xsize+1) = ...
          reshape(S(:,i*cols+j+1),[ysize xsize]);
    end
    
  end
end

% Make a black border
I(1,:) = 0;
I(:,1) = 0;
I(end,:) = 0;
I(:,end) = 0;

I = imresize(I,mag);

colormap(gray(256));
iptsetpref('ImshowBorder','tight'); 
subplot('position',[0,0,1,1]);
imshow(uint8(I));
%imwrite(H,'originale.png');
truesize;  
drawnow
