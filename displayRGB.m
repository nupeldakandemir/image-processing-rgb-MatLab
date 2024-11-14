function im = displayRGB(filename)
    % Read the image file
    originalImage = imread(filename);

    % Get image dimensions
    [M, N, ~] = size(originalImage);

    % Calculate new dimensions to maintain aspect ratio but resize larger dimension to 800 pixels
    if M > N
        scaleFactor = 800 / M;
        newM = 800;
        newN = round(N * scaleFactor);
    else
        scaleFactor = 800 / N;
        newN = 800;
        newM = round(M * scaleFactor);
    end

    % Interpolate each color layer separately
    [X, Y] = meshgrid(linspace(1, N, newN), linspace(1, M, newM));
    redLayer = interp2(double(originalImage(:, :, 1)), X, Y, 'cubic');
    greenLayer = interp2(double(originalImage(:, :, 2)), X, Y, 'cubic');
    blueLayer = interp2(double(originalImage(:, :, 3)), X, Y, 'cubic');

    % Combine color layers into an interpolated image
    interpolatedImage = uint8(cat(3, redLayer, greenLayer, blueLayer));

    % Create empty matrix for the composite image
    compositeImage = zeros(2 * newM, 2 * newN, 3, 'uint8');

    % Place the original resized image in the top left
    compositeImage(1:newM, 1:newN, :) = interpolatedImage;

    % Create and place red layer image in the top right
    redImage = interpolatedImage;
    redImage(:, :, [2 3]) = 0;
    compositeImage(1:newM, newN+1:2*newN, :) = redImage;

    % Create and place green layer image in the bottom left
    greenImage = interpolatedImage;
    greenImage(:, :, [1 3]) = 0;
    compositeImage(newM+1:2*newM, 1:newN, :) = greenImage;

    % Create and place blue layer image in the bottom right
    blueImage = interpolatedImage;
    blueImage(:, :, [1 2]) = 0;
    compositeImage(newM+1:2*newM, newN+1:2*newN, :) = blueImage;

    % Display the composite image
    image(compositeImage);
    axis equal;
    axis tight;

    % Return the composite image matrix
    im = compositeImage;
end