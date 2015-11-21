function net = svmltrain(net, X, Y)
% SVMLTRAIN - Wrapper for SVMlight: Training
%
%   NET = SVMLTRAIN(NET, X, Y)
%   NET is a wrapper structure generated by SVML. SVMlight is called to
%   train an SVM on training data X with labels Y. X is an [N D] matrix
%   with one training data point per row, a total of N points with
%   dimension D. X may be sparse. Y is a column vector of labels, where
%   Y(i) is the +1 or -1 label for data point X(i,:).
%   SVMlight is trained with the options given by NET.options. The
%   generated model file is written to file NET.fname.
%   If any of the Y(i) is 0, the transductive learner is invoked
%   automatically.
%   NET = SVMLTRAIN(NET, FNAME) may be used when several calls to
%   SVMLTRAIN are made, using the same training data. In the
%   SVMLTRAIN(NET, X, Y) syntax, training data X and Y are written to a
%   file at each call, which is deleted after training. To save time, one
%   may call SVMLWRITE(FNAME, X, Y) beforehand, thus saving X and Y into
%   a permanent file. Afterwards SVMLTRAIN(NET, FNAME) will invoke the
%   training, used the data in file FNAME.
%
%   See also SVML, SVMLFWD, SVMLWRITE, SVM_LEARN
%

%
% Copyright (c) by Anton Schwaighofer (2002)
% $Revision: 1.3 $ $Date: 2002/02/19 12:26:56 $
% mailto:anton.schwaighofer@gmx.net
%
% This program is released unter the GNU General Public License.
%

narginchk(2, 3);
error(consist(net, 'svml'));
if nargin<3,
    Y = [];
    if ~ischar(X),
        error(['Calling SVMLTRAIN with only 2 arguments requires a string as' ...
            ' the second arg']);
    else
        traindata = X;
    end
else
    traindata = [];
end
% If no filename specified: Use a random filename for storing the model
fname = net.fname;
if isempty(fname),
    r = round(rand(1)*1e6);
    fname = sprintf('svml_%i.model', r);
    net.fname = fname;
end
uY = unique(Y);
if isempty(setdiff(uY, [-1 0 1])),
    if ismember(0, uY),
        % For the case of transduction: make sure the transduction labels are
        % written out somewhere
        if isempty(net.options.TransLabelFile),
            net.options = svmlopt(net.options, 'TransLabelFile', ...
                [fname '.transduction']);
            fprintf('Modifying options:\n');
            fprintf('Labels for transduction examples will be written to file %s\n',...
                net.options.TransLabelFile);
        end
    end
end
% Write out the training data into a file
if isempty(traindata),
    traindata = [fname '.traindata'];
    svmlwrite(traindata, X, Y);
    deleteData = 1;
else
    deleteData = 0;
end
status = svm_learn(net.options, traindata, fname);
if deleteData,
    delete(traindata);
end
if status~=0,
    error(sprintf('Error when calling SVMlight. Status = %i', status));
end