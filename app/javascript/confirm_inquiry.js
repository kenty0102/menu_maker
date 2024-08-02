document.addEventListener('DOMContentLoaded', () => {
  const inquiryForm = document.querySelector('form[data-inquiry-confirm]');

  if (inquiryForm) {
    inquiryForm.addEventListener('submit', function (event) {
      const confirmMessage = this.getAttribute('data-inquiry-confirm');
      if (!confirm(confirmMessage)) {
        event.preventDefault();
      }
    });
  }
});
