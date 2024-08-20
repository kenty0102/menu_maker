import { Controller } from '@hotwired/stimulus';
import html2canvas from 'html2canvas';

export default class extends Controller {
  connect() {
    this.captureMenuImage(); // ページ読み込み時にメニュー表を画像として表示
  }

  captureMenuImage() {
    const menuContainer = this.element.querySelector('.menulist-container'); // コントローラ内の要素を参照
    
    // 一時的に表示させる
    menuContainer.style.display = 'block';
    
    html2canvas(menuContainer, { scale: 2 }).then((canvas) => {
      const imgElement = document.getElementById('menu-image');
      imgElement.src = canvas.toDataURL('image/png'); // PNG形式で画像データを取得
      menuContainer.style.display = 'none'; // メニュー表のテキストを非表示
      imgElement.style.display = 'block'; // 画像を表示
    });
  }

  capture() {
    const menuContainer = this.element.querySelector('.menulist-container'); // コントローラ内の要素を参照

    // 一時的に表示させる
    menuContainer.style.display = 'block';

    html2canvas(menuContainer, { scale: 2 }).then((canvas) => {
      const link = document.createElement('a');
      link.href = canvas.toDataURL('image/png');
      link.download = 'menu-image.png'; // ダウンロードするファイル名
      link.click(); // 画像をダウンロード

      // メニュー表のテキストを非表示
      menuContainer.style.display = 'none'; 
    });
  }
}
