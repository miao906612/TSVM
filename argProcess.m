%%
%˵�������������ڽ������������
%���ߣ���˶
%ʱ�䣺2014��5��6��


function varargout = argProcess(arg, varargin)

%����Ԥ����
arg = argPreprocess(arg);
%varargin ���
if  mod( length(varargin), 2 ) ~= 0
    error('The parameter must be pairwise')
end
%��������ĸ���
if nargout ~= length(varargin) / 2
    error('The number of output arguments is not equal to default number')
end
%�趨Ĭ�����
varargout = cell(nargout,1);
for iter = 1 : nargout
    varargout{iter} = varargin{2 * iter};
end
%���ĳ����Ĭ�����Ϊ��Ϊ���õ����
for iter = 1 : nargout
    for iter1 = 1 : 2 : length(arg)-1
        if strcmpi( varargin{ 2*iter-1 }, arg{iter1} )
            varargout{iter} = arg{iter1 + 1};
        end
    end
end
