%%
%˵�������������ڽ����������struct��cell������ͳһ��cell������
%���ߣ���˶
%ʱ�䣺2014��5��6��

function y = argPreprocess(arg)

if isstruct(arg)
    y = assemble( fieldnames(arg), struct2cell(arg) );
elseif ~isempty(arg)
    y = [];
    for iter = 1 : length(arg)
        if isstruct( arg{iter} )
            temp = assemble( fieldnames(arg{iter}), struct2cell(arg{iter}) );
            y = [y;temp];
        else
            y = [y;arg(iter)];
        end
    end
else
    y = arg;
end

%assemble function
function y = assemble(arg1, arg2)

arg1 = arg1(:);
arg2 = arg2(:);
if length(arg1) ~= length(arg2)
    error('The parameter must be pairwise')
end
y = cell( 2*length(arg1), 1 );
y( 1 : 2 : 2*length(arg1)-1 ) = arg1;
y( 2 : 2 : 2*length(arg1) ) =arg2;
