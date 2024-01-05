% Parameters
nImages = 999; % Number of images for each digit (0-9)
n = 28; % Assuming each image is 28x28 pixels
Sdim = min(784, nImages);

% Initialize variables for digits 0 to 9
A = cell(10, 1);
U = cell(10, 1);
S = cell(10, 1);
B = cell(10, 1);
k_values = zeros(10, 1);

for digit = 0:9
    A{digit+1} = zeros(784, nImages);
    
    for i = 1:nImages
        filename = ['digit' num2str(digit) '\' num2str(i, '%04d') '.png']; % Adjust the filename pattern
        img = imread(filename);
        A{digit+1}(:, i) = reshape(img, [], 1);
    end
    
    [U{digit+1}, S{digit+1}, ~] = svd(A{digit+1});
    B{digit+1} = reshape(uint8(255 * mat2gray(U{digit+1}(:, 1))), n, n);
    imshow(B{digit+1});
    
    % Determine the value of k for the current digit
    svdTol = 0.9;
    sigmaAll = trace(S{digit+1}(1:Sdim, 1:Sdim));
    sigmaK = 0;
    for i = 1:size(S{digit+1}, 1)
        sigmaK = sigmaK + S{digit+1}(i, i);
        if sigmaK / sigmaAll > svdTol
            k_values(digit+1) = i;
            break
        end
    end
        pause(1); % Pause briefly between digits
end


k_values % Display the values of k for digits 0 to 9

% zfilename = ['digit1\0001.png'];
% img = imread(zfilename);
% z = double(reshape(img(:,:,1),[],1));
% Initialize variables to track the minimum rel_res and corresponding digit
min_rel_res = Inf;
min_rel_res_digit = -1;
% Initialize an array to store rel_res for each digit
% rel_res_array = zeros(10, 1);
% Loop through each digit to calculate rel_res and find the minimum
for digit = 0:9
    % Calculate rel_res for a specific image (e.g., digit 1, image 1)
    zfilename = ['digit' num2str(digit) '\0001.png'];
    img = imread(zfilename);
    z = double(reshape(img(:,:,1),[],1));

    res = norm(z - U{digit+1}(:, 1:k_values(digit+1)) * (U{digit+1}(:, 1:k_values(digit+1))' * z), 2);
    rel_res = res / norm(z, 2);
    % Store the rel_res for the current digit
    % rel_res_array(digit+1) = rel_res;
    % Check if this digit has the minimum relative residual
    if rel_res < min_rel_res
        min_rel_res = rel_res;
        min_rel_res_digit = digit;
    end
end

min_rel_res % Minimum relative residual
min_rel_res_digit % Digit with the minimum relative residual
