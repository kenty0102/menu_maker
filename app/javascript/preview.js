document.addEventListener("turbo:load", function() {
  const imageInput = document.getElementById("recipe_image");
  const preview = document.getElementById("preview");

  if (imageInput && preview) {
    imageInput.addEventListener("change", function(event) {
      const alreadyPreview = document.querySelector(".preview");
      if (alreadyPreview) {
        alreadyPreview.remove();
      }

      const file = event.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
          preview.src = e.target.result;
          preview.style.display = "block";
        };
        reader.readAsDataURL(file);
      }
    });
  }
});
