function y = transduction_read(filename)
% ���ļ���Ҫ����ɶ���ѵ���������ޱ�ǩ�����ķ�����
f = fopen(filename,'rt');
y =[];
while ~feof(f)
    s = fgetl(f);
    temp = sscanf(s,'%f:%f',2);
    temp = temp(1)*temp(2);
    y = [y;temp];
end
fclose(f);