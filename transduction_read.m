function y = transduction_read(filename)
% 该文件主要是完成读入训练样本中无标签样本的分类结果
f = fopen(filename,'rt');
y =[];
while ~feof(f)
    s = fgetl(f);
    temp = sscanf(s,'%f:%f',2);
    temp = temp(1)*temp(2);
    y = [y;temp];
end
fclose(f);