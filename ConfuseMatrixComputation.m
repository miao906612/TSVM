%目的：
%      本代码实现混淆矩阵的计算，显示，计算生产精度，用户精度，总体精度，kappa
%      系数。
%作者，编写时间：
%      苗硕，2014年9月18号，星期四

function [ Matrix, varargout ] = ConfuseMatrixComputation( reallabel, predictlabel, varargin )
%输入：
%    realabel---数据的实际标签
%    predictlabel---数据的预测标签
%    varargin---需要输入的其他参数
%               'Adjust'--'true','false'
%               'CenterLabelReal' 是一个2*n的矩阵，第一行是centers
%                                 第二行是对应的标签
%               'CenterLabelPredict'是一个2*n的矩阵，第一行是centers
%                                   第二行是对应的标签
%               'FigureShow'---'true','false'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 参数预处理
%
[  Adjust, ...
   CenterLabelReal, ...
   CenterLabelPredict, ...
   FigureShow ] = argProcess( varargin, ...
                   'Adjust', 'false', ...
                   'CenterLabelReal', [], ...
                   'CenterLabelPredict', [], ...
                   'FigureShow', 'true');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 其他的一些检测
%
labelValueReal = unique( reallabel(:) );
labelValuePredict = unique( predictlabel(:) );

if length( labelValueReal ) ~= length( labelValuePredict )
    warning('The number of the real and predicted labels is different.')
end

if strcmpi( Adjust, 'true' ) || strcmpi( Adjust, 't' )
    if length( size( CenterLabelReal ) ) ~= 2 || ...
            size( CenterLabelReal, 1 ) ~= 2
        error( strcat( '''CenterLabelReal'' must be a two dimensional matrix,', ...
            'with two rows.' ) )
    end
    if length( size( CenterLabelPredict ) ) ~= 2 || ...
            size( CenterLabelPredict, 1 ) ~= 2
        error( strcat( '''CenterLabelPredict'' must be a two dimensional matrix,', ...
            'with two rows.' ) )
    end
    if size( CenterLabelReal, 2 ) ~= size( CenterLabelPredict, 2 )
        warning('The numbers of the real and predicted labels is different.')
    end
    if length( labelValueReal ) ~= size( CenterLabelReal, 2 )
        error('The number of the real labels in ''reallabel'' and ''CenterLabelReal'' is different')
    end
    if length( labelValuePredict ) ~= size( CenterLabelPredict, 2 )
        error('The number of the real labels in ''predictlabel'' and ''CenterLabelPredict'' is different')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 混淆矩阵构造
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 类标调整
%
if strcmpi( Adjust, 'true' ) || strcmpi( Adjust, 't' )
    vtemp = randn( size( CenterLabelPredict, 2 ), 1 );
    for iter = 1 : size( CenterLabelPredict, 2 )
         vtempLabelPredict = CenterLabelPredict(2, iter);
         CenterLabelPredict(2, iter) = vtemp(iter);
         predictlabel( predictlabel == vtempLabelPredict ) = vtemp(iter);
    end
    for iter = 1 : size( CenterLabelPredict, 2 )
        vtemp = abs( CenterLabelReal(1,:) - CenterLabelPredict(1,iter) );
        index = find( vtemp == min( vtemp ) );
        vtempLabelReal = CenterLabelReal(2, index);
        vtempLabelPredict = CenterLabelPredict(2, iter);
        predictlabel( predictlabel == vtempLabelPredict ) = vtempLabelReal;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Matrix = zeros( length(labelValueReal), length(labelValuePredict) );
labelValueReal = sort( labelValueReal );
for iterRow = 1 : length(labelValueReal)
    a = reallabel(:);
    b = predictlabel(:);
    index = find( a == labelValueReal(iterRow) );
    vtemp = b( index );
    for iterColumn = 1 : length(labelValuePredict)
        c = find( vtemp == labelValueReal(iterColumn) );
        Matrix( iterRow, iterColumn ) = length( c  );
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 计算生产精度，用户精度，总体精度，kappa系数
%
vtemp = diag( Matrix );
vtemp = vtemp(:);
vtempSumRow = sum( Matrix, 1 );
vtempSumRow = vtempSumRow(:);
vtempSumColumn = sum( Matrix, 2 );
vtempSumColumn = vtempSumColumn(:);
vtempSum = sum( vtempSumColumn );
coePro = vtemp ./ vtempSumColumn;
coeUser = vtemp ./ vtempSumRow;
coeTotal = sum( vtemp ) / sum( vtempSumColumn );
kappa = ( vtempSum * sum( vtemp ) - sum( vtempSumRow .* vtempSumColumn ) ) / ...
    ( vtempSum .^ 2 - sum( vtempSumRow .* vtempSumColumn ) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 显示图形
% 
vtemp = Matrix ./ repmat( sum( Matrix, 2 ), 1, size(Matrix, 2));
name_class = cell( size(Matrix, 2) );
%for iter = 1 : size(Matrix, 2)
 %   name_class{iter} = ('Cstrcatlass',num2str(iter) );
%end
if strcmpi( FigureShow, 'true') || strcmpi( FigureShow, 't')
    draw_cm(vtemp,name_class,size(Matrix, 2));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 输出
%
if nargout == 2
    varargout{1} = kappa;
elseif nargout == 3
    varargout{1} = kappa;
    varargout{2} = coePro;
elseif nargout == 4
    varargout{1} = kappa;
    varargout{2} = coePro;
    varargout{3} = coeUser;
elseif nargout == 5
    varargout{1} = kappa;
    varargout{2} = coePro;
    varargout{3} = coeUser;
    varargout{4} = coeTotal;
end
    

        
        
    
   