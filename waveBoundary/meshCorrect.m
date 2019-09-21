timeCorrect = '16.8/';

%% Read points
fDir = [timeCorrect 'polyMesh/points'];
fId = fopen(fDir,'r');
i = 1;
tLine = fgetl(fId);
C{i} = tLine;
while ischar(tLine)
    i = i + 1;
    tLine = fgetl(fId);
    C{i} = tLine;
end

parfor i = 21:length(C) - 5
    space = find(isspace(C{i}));
    B = C{i}(2 : space(1) - 1);
    D = C{i}(space(1) + 1 : space(2) - 1);
    E = C{i}(space(2) + 1 : end - 1);
    x(i - 20) = str2double(B);
    y(i - 20) = str2double(D);
    z(i - 20) = str2double(E);
end

%% Clean faces
d = 1.8e-4;
D = 0.5;
n = 1;
figure(1)
plot(x,z,'*');
figure(2)
plot(x,y,'*');

%% Find points with same x and z
parfor i = 1:length(x)
    n = 2;
    for j = 1:length(x) - i
        if abs(x(i) - x(i+j)) < 5e-3
            if abs(z(i) - z(i+j)) < 5e-3
                grid{i}(1) = y(i);
                grid{i}(n) = y(i+j);
                gridPoints{i}(1) = j;
                gridPoints{i}(n) = i+j;
                n = n + 1;
            end
        end
    end
end

%% Correct points
for i = 1:length(grid)
    if length(gridPoints{i}) == 62
        as = sortrows([gridPoints{i}',grid{i}'],2);
        gridPoints{i} = as(:,1);
        grid{i} = as(:,2);
        y(gridPoints{i}(1)) = y(gridPoints{i}(1));
        y0 = 4*d;
        for j = 1:60
            y(gridPoints{i}(j+1)) = y(gridPoints{i}(j)) + y0*(1.095^(j - 1));
        end
        y(gridPoints{i}(62)) = y(gridPoints{i}(62));
        
        for k = 1:61
            if abs(z(gridPoints{i}(k)) - z(gridPoints{i}(k + 1)) > 1e-5) || ...
               abs(x(gridPoints{i}(k)) - x(gridPoints{i}(k + 1)) > 1e-5)
               x(gridPoints{i}(k + 1)) = x(gridPoints{i}(k));
               z(gridPoints{i}(k + 1)) = z(gridPoints{i}(k));
            end
        end
    end
end
figure(3)
polt(x,y,'*')

%% Output corrected mesh
fid = fopen([timeCorrect 'polyMesh/points1'],'wb');
s = 'FoamFile'; fprint(fid,'%s\n',s);
s = '{'; fprint(fid,'%s\n',s);
s = 'version 2.0;'; fprint(fid,'%s\n',s);
s = 'format ascii;'; fprint(fid,'%s\n',s);
s = 'class vectorField;'; fprint(fid,'%s\n',s);
s = 'object points;'; fprint(fid,'%s\n',s);
s = '}'; fprint(fid,'%s\n',s);
s = num2str(length(x)); fprint(fid,'%s\n',s);
s = '('; fprint(fid,'%s\n',s);
for j = 1:length(x)
    s = ['(' num2str(x(j)) ' ' num2str(y(j)) ' ' num2str(z(j)) ')'];
    fprint(fid,'%s\n',s);
end
s = ')'; fprint(fid,'%s\n',s);