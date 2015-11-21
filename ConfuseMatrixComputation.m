%Ŀ�ģ�
%      ������ʵ�ֻ�������ļ��㣬��ʾ�������������ȣ��û����ȣ����徫�ȣ�kappa
%      ϵ����
%���ߣ���дʱ�䣺
%      ��˶��2014��9��18�ţ�������

function [ Matrix, varargout ] = ConfuseMatrixComputation( reallabel, predictlabel, varargin )
%���룺
%    realabel---���ݵ�ʵ�ʱ�ǩ
%    predictlabel---���ݵ�Ԥ���ǩ
%    varargin---��Ҫ�������������
%               'Adjust'--'true','false'
%               'CenterLabelReal' ��һ��2*n�ľ��󣬵�һ����centers
%                                 �ڶ����Ƕ�Ӧ�ı�ǩ
%               'CenterLabelPredict'��һ��2*n�ľ��󣬵�һ����centers
%                                   �ڶ����Ƕ�Ӧ�ı�ǩ
%               'FigureShow'---'true','false'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ����Ԥ����
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
% ������һЩ���
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
% ����������
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ������
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
% �����������ȣ��û����ȣ����徫�ȣ�kappaϵ��
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
% ��ʾͼ��
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
% ���
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
    

        
        
    
   