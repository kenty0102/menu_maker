import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["nestedForms"]

  connect() {
    // 初期フォームの数を取得
    this.initialFormCount = this.nestedFormsTarget.querySelectorAll('.instruction-fields, .ingredient-fields').length;
    // カウンターを初期フォームの数からスタートさせる
    this.instructionCount = this.initialFormCount;

    // 削除ボタンがクリックされたときのイベントリスナーを追加
    this.element.addEventListener('click', (event) => {
      if (event.target.classList.contains('remove-instruction') || event.target.classList.contains('remove-ingredient')) {
        this.removeForm(event);
      }
    });
  }

  addIngredientForm(event) {
    event.preventDefault();
    const newForm = document.querySelector('.ingredient-fields').cloneNode(true);
    const timestamp = new Date().getTime();
    newForm.innerHTML = newForm.innerHTML.replace(/_attributes_\d+_/g, `_attributes_${timestamp}_`);

    // 新しいフォームに削除ボタンを追加する
    const removeButton = this.createRemoveButton('ingredient');
    const formRow = newForm.querySelector('.row');
    formRow.appendChild(removeButton);
    
    // Insert newForm before the add ingredient link
    const addIngredientLink = this.element.querySelector('.add-ingredient');
    this.nestedFormsTarget.insertBefore(newForm, addIngredientLink);
  }

  addInstructionForm(event) {
    event.preventDefault();
    const newForm = document.querySelector('.instruction-fields').cloneNode(true);
    const timestamp = new Date().getTime();
    newForm.innerHTML = newForm.innerHTML.replace(/_attributes_\d+_/g, `_attributes_${timestamp}_`);

    // 新しいフォームに番号を付ける
    newForm.querySelector('input[name*="[step_number]"]').value = ++this.instructionCount;

    // 新しいフォームに削除ボタンを追加する
    const removeButton = this.createRemoveButton('instruction');
    const formRow = newForm.querySelector('.row');
    formRow.appendChild(removeButton);
    
    // Insert newForm before the add instruction link
    const addInstructionLink = this.element.querySelector('.add-instruction');
    this.nestedFormsTarget.insertBefore(newForm, addInstructionLink);
  }

  removeForm(event) {
    event.preventDefault();
    const formContainer = event.target.closest('.instruction-fields, .ingredient-fields');
    if (formContainer && formContainer.dataset.newForm !== 'true') {
      formContainer.remove();
      this.recalculateStepNumbers();
    }
  }

  recalculateStepNumbers() {
    // 全てのフォームを取得し直す
    const forms = this.nestedFormsTarget.querySelectorAll('.instruction-fields, .ingredient-fields');
    this.instructionCount = 0;

    // 各フォームの番号を再設定する
    forms.forEach((form, index) => {
      const stepNumberInput = form.querySelector('input[name*="[step_number]"]');
      if (stepNumberInput) {
        stepNumberInput.value = ++this.instructionCount;
      }
    });
  }

  createRemoveButton(type) {
    const removeButton = document.createElement('a');
    removeButton.href = '#';
    removeButton.textContent = 'x';
    removeButton.className = `remove-${type} btn btn-danger`;
    removeButton.setAttribute('data-action', 'click->dynamic-form#removeForm');
    return removeButton;
  }
}