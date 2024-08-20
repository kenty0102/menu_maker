// Entry point for the build script in your package.json
import "@hotwired/stimulus"
import "@hotwired/turbo-rails"
import "stimulus-autocomplete"
import "html2canvas"
import "./controllers"
import "./preview"
import "./confirm_inquiry"

// パンくずのリンクのturbo無効化
document.addEventListener("DOMContentLoaded", () => {
  const breadcrumbLinks = document.querySelectorAll(".breadcrumbs a");
  breadcrumbLinks.forEach(link => {
    link.setAttribute("data-turbo", "false");
  });
});

// 削除ボタンのturbo無効化に伴い、確認ダイアログを表示させるよう設定
window.delete_confirm = function delete_confirm(message = '本当に削除しますか？'){
  if(window.confirm(message)){
    return true;
  } else {
    return false;
  }
}