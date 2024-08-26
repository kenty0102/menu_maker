import { Controller } from '@hotwired/stimulus';
import html2canvas from 'html2canvas';

export default class extends Controller {
  connect() {
    this.captureMenuImage(); // ページ読み込み時にメニュー表を画像として表示
    this.checkUploadFlag(); // ページ読み込み時にアップロードフラグを確認
  }

  // メニュー詳細が画面でメニュー表を画像で表示させる
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

  // メニュー表の画像のダウンロード
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
  
  // アップロードフラグをチェック
  checkUploadFlag() {
    const menuId = this.element.dataset.menuId; // メニューのIDを取得
    
    fetch(`/menus/${menuId}`, {
      method: 'GET',
      headers: { 'Accept': 'application/json'}
      })
    .then(response => {
      if (!response.ok) {
          throw new Error('Network response was not ok');
      }
      return response.json();
    })
    .then(data => {
      console.log(data); // データを確認
      const shouldUpload = data.upload_image; // JSONからフラグを取得
      if (shouldUpload) {
        this.uploadToS3(menuId); // メニュー作成・更新後に画像をアップロード
        // アップロード後にフラグをリセット（次回以降のアップロードを防ぐ）
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content'); // CSRFトークンを取得
        
        fetch('/menus/reset_upload_flag', {
          method: 'POST',
          body: JSON.stringify({ menu: { id: menuId} }),
          headers: {
            'Accept': 'application/json',
            'X-CSRF-Token': csrfToken, // CSRFトークンを追加
            'Content-Type': 'application/json' // もし必要であれば、Content-Typeも追加
          }
        });
      }
    })
    .catch(error => {
      console.error('Fetch error:', error); // エラーをログ出力
    });
  }

  // S3へアップロード
  async uploadToS3(menuId) {
    const menuContainer = this.element.querySelector('.menulist-container');
  
    // 一時的に表示させる
    menuContainer.style.display = 'block';
  
    const canvas = await html2canvas(menuContainer, { scale: 2 });
    const imageData = canvas.toDataURL('image/png');
  
    // CSRFトークンを取得
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  
    try {
        // S3へのアップロード処理を行う（menus_controller.rbのupload_imageアクションへPOSTリクエストを送る）
        const responseUpload = await fetch('/menus/upload_image', {
            method: 'POST',
            body: JSON.stringify({ image: imageData }),
            headers: {
                'Accept': 'application/json',
                'X-CSRF-Token': csrfToken,
                'Content-Type': 'application/json'
            }
        });
      
        if (!responseUpload.ok) {
            throw new Error('Failed to upload image to S3');
        }

        const dataUpload = await responseUpload.json();
        const imageUrl = dataUpload.url; // S3のURLを取得

        // S3にアップロードした画像のURLを保存（menus_controller.rbのsave_image_urlアクションへPOSTリクエストを送る）
        const responseSave = await fetch('/menus/save_image_url', {
            method: 'POST',
            body: JSON.stringify({ image_url: imageUrl, menu_id: menuId }),
            headers: {
                'Accept': 'application/json',
                'X-CSRF-Token': csrfToken,
                'Content-Type': 'application/json'
            }
        });

        if (!responseSave.ok) {
            throw new Error('Failed to save image URL');
        }
        
    } catch (error) {
        console.error('Error:', error);
    } finally {
        // メニュー表のテキストを非表示
        menuContainer.style.display = 'none'; 
    }
  }
}
