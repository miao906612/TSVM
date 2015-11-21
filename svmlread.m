function [Y, X] = svmlread(fname)
% SVMLREAD - Read a data file generated by SVM light
%
%   Y = SVMLREAD(FNAME)
%   FNAME gives the name of an output file generated by SVM light. It
%   may contain predicted labels, coefficients alpha, or an input
%   (example) file with class values and features. From this file the
%   data in the first column (class labels or alphas) is extrated and
%   returned in Y.
%   [Y, X] = SVMLREAD(FNAME), where FNAME is the name of an input file
%   with class values and features, returns both the vector of class
%   labels Y and the matrix of examples X. Each line of X corresponds to
%   a line in the file.
%   Attention: this may take a while...
%
%   See also SVML, SVM_LEARN, SVM_CLASSIFY, SVMLOPT, SVMLWRITE
%

%
% Copyright (c) by Anton Schwaighofer (2001)
% $Revision: 1.6 $ $Date: 2002/02/19 12:26:07 $
% mailto:anton.schwaighofer@gmx.net
%
% This program is released unter the GNU General Public License.
%

error(nargchk(1, 1, nargin));

X = [];
Y = [];

f = fopen(fname, 'rt');
if (f<0),
    error(sprintf('Unable to open file %s', fname));
end

i = 0;
fprintf('Scanning ');
while ~feof(f),
    s = fgetl(f);
    [Yi, count, errmsg, nextind] = sscanf(s, '%f', 1);
    % read the class label resp. anything else that is in the first column
    if (count==1),
        i = i+1;
        Y(i,1) = Yi;
        [Xi, count] = sscanf(s(nextind:end), ' %i:%f');
        % scan for the feature:value pairs
        if (rem(count,2)==0) & (count~=0),
            % if they really come in pairs, then accept
            ind = 2:2:count;
            if isempty(X),
                maxCol = max(Xi(ind-1));
                approxSparsity = (count/2)/maxCol;
                % a rough estimate of the sparsity, based on the first line of
                % data
                if approxSparsity>0.5,
                    approxSparsity = 1;
                    X = zeros(maxCol, 1000);
                else
                    X = spalloc(maxCol, 1000, round(1000*maxCol*approxSparsity));
                    % allocate for 1000 data points (lines) beforehand
                    % We store everything *columnwise* and transpose afterwards,
                    % this greatly improves performance
                end
            end
            X(Xi(ind-1),i) = Xi(ind);
            if (rem(i,100)==0),
               % fprintf(' %i', i);
            end
        end
    end
end
fprintf(' done.\n');
if ~isempty(X),
    X = X(:,1:i)';
    sparsity = length(find(X))/prod(size(X));
    if sparsity<0.5,
        X = sparse(X);
        % remove any surplus lines & convert to sparse a second time for
        % optimal memory usage
    end
end

fclose(f);