function [W, H] = nmfEuc( V, rdim, fname, showflag, epsilon, maxiter)
%

% Check that we have non-negative data
if min(V(:))<0, error('Negative values in data!'); end

% Globally rescale data to avoid potential overflow/underflow
V = V/max(V(:));

% Dimensions
vdim = size(V,1);
samples = size(V,2);

% Create initial matrices
W = abs(randn(vdim,rdim));
H = abs(randn(rdim,samples));

% Initialize displays
if showflag,
   figure(1); clf; % this will show the energies and sparsenesses
   figure(2); clf; % this will show the objective function
   drawnow;
end

% Calculate initial objective
objhistory = sum(sum((V - W*H).^2));

timestarted = clock;

% Start iteration
iter = 0;
keepGoing = 1;
while keepGoing,

    % Show progress
    fprintf('[%d]: %.5f \n',iter,objhistory(end));    

    % Save every once in a while
    if rem(iter,5)==0,
	elapsed = etime(clock,timestarted);
	fprintf('Saving...');
	save(fname,'W','H','iter','objhistory','elapsed');
	fprintf('Done!\n');
    end
	
    % Show stats
    if showflag && (rem(iter,5)==0),
	figure(1);
	cursW = (sqrt(vdim)-(sum(W)./sqrt(sum(W.^2))))/(sqrt(vdim)-1);
	cursH = (sqrt(samples)-(sum(H')./sqrt(sum(H'.^2))))/(sqrt(samples)-1);
	subplot(3,1,1); bar(sqrt(sum(W.^2)));
	subplot(3,1,2); bar(cursW);
	subplot(3,1,3); bar(cursH);
	if iter>1,
	    figure(2);
	    plot(objhistory(2:end));
	end
	drawnow;
    end
    
    % Update iteration count
    iter = iter+1;    
    
    % Save old values
    Wold = W;
    Hold = H;
    
    % Compute new W and H 
    W = W.*((V * H')./(W * H * H' + 1e-9));
    H = H.*((W'*V)./(W' * W * H + 1e-9));

    
    % Calculate objective
    newobj = sum(sum((V - W*H).^2));
    % fprintf('%.5f \n',(abs(newobj - objhistory(end)) / newobj * 100));
%     if (abs(newobj - objhistory(end)) / newobj * 100) <= epsilon
%         keepGoing = 0;
%     end
    if iter >= maxiter
        keepGoing = 0;
    end
    objhistory = [objhistory newobj];
    	
    
end