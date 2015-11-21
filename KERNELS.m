function k=KERNELS(kerneltype)
switch kerneltype
    case 'linear'
        k=0;
    case 'poly'
        k=1;
    case 'rbf'
        k=2;
    otherwise
        error('Unknown Kernel Type');
end
end