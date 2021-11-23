cd(code_directory)

s = filesep; % This gets the file separator character from the  system
test_faces_photos = strcat(training_directory, '\test_face_photos');
test_cropped_faces = strcat(training_directory, '\test_cropped_faces');
test_nonfaces = strcat(training_directory, '\test_nonfaces');
other_code = strcat(code_directory, '\given');
addpath([other_code s '00_common' s '00_detection'])
addpath([other_code s '00_common' s '00_images'])
addpath([other_code s '00_common' s '00_utilities'])
addpath(other_code)
addpath(test_faces_photos)
addpath(test_cropped_faces)
addpath(test_nonfaces)

load boosted_classifier
load weak_classifiers
load boosted_classifier_num
%{
cd([test_cropped_faces])
face_images_cropped = dir(fullfile(test_cropped_faces,'*.bmp'));
cropped_faces = zeros(100, 100, number_faces);
for i = 1:size(face_images_cropped,3)
  filename = fullfile(test_cropped_faces,face_images_cropped(i).name);
  cropped_faces(:,:,i) = read_gray(filename);
end
%}

face_images_photo = dir(fullfile(test_faces_photos,'*.jpg'));
%cd([repo_path])
for i = 1:size(face_images_photo,3)
    filename = fullfile(test_faces_photos,face_images_photo(i).name);
    photo_image = read_gray(filename);
    imshow(photo_image, []);

    [result, boxes] = boosted_detector_demo(photo_image,18, boosted_classifier, weak_classifiers, [31, 25], 3);
    imshow(result, []);
end
%{
num_wrong_face = 0;
num_wrong_nonface = 0;
for i = 1:size(cropped_faces,3)
    prediction = boosted_predict(cropped_faces(:, :, i), boosted_classifier, weak_classifiers, boosted_classifier_num);
    if (prediction < 0)
       num_wrong_face = num_wrong_face + 1; 
    else 
        imshow(cropped_faces(:, :, i), []);
    end
    
end

for i = 1:size(nonfaces,3)
    prediction = boosted_predict(nonfaces(:, :, i), boosted_classifier, weak_classifiers, boosted_classifier_num);
    if (prediction > 0)
     num_wrong_nonface = num_wrong_nonface + 1;
    end
end
%}