%%
%说明：本函数用于将设置输入参数
%作者：苗硕
%时间：2014年5月6号


function varargout = argProcess(arg, varargin)

%参数预处理
arg = argPreprocess(arg);
%varargin 检查
if  mod( length(varargin), 2 ) ~= 0
    error('The parameter must be pairwise')
end
%输出变量的个数
if nargout ~= length(varargin) / 2
    error('The number of output arguments is not equal to default number')
end
%设定默认输出
varargout = cell(nargout,1);
for iter = 1 : nargout
    varargout{iter} = varargin{2 * iter};
end
%更改程序的默认输出为人为设置的输出
for iter = 1 : nargout
    for iter1 = 1 : 2 : length(arg)-1
        if strcmpi( varargin{ 2*iter-1 }, arg{iter1} )
            varargout{iter} = arg{iter1 + 1};
        end
    end
end
