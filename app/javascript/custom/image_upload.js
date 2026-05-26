// Prevent uploading of big images.
document.addEventListener("turbo:load", function () {
    const imageUpload = document.querySelector("#micropost_image");
    if (!imageUpload) {
        return;
    }

    imageUpload.addEventListener("change", function () {
        if (!imageUpload.files || !imageUpload.files[0]) {
            return;
        }

        const sizeInMegabytes = imageUpload.files[0].size / 1024 / 1024;
        if (sizeInMegabytes > 5) {
            alert("Maximum file size is 5MB. Please choose a smaller file.");
            imageUpload.value = "";
        }
    });
});