import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["nestedForms"]

  connect() {
    // 初期フォームの数を取得
    this.initialFormCount = this.nestedFormsTarget.querySelectorAll('.instruction-fields, .ingredient-fields').length;
    // カウンターを初期フォームの数からスタートさせる
    this.instructionCount = this.initialFormCount;

    // ページのモード（new または edit）を取得
    const mode = this.element.dataset.mode;

    if (mode === 'new') {
      this.addRemoveButtonsToNewFormsForNew();
    } else if (mode === 'edit') {
      this.addRemoveButtonsToNewFormsForEdit();
    }

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
    newForm.innerHTML = newForm.innerHTML.replace(/_attributes_\d+_/g, `_attributes_${timestamp}`);
    newForm.querySelectorAll('input').forEach(input => input.value = ''); // 追加されたフォームの値をリセット

    // 新しいフィールドの名前属性を更新
    const fieldSets = this.nestedFormsTarget.querySelectorAll('.ingredient-fields');
    const newIndex = fieldSets.length;
    newForm.querySelectorAll('[name]').forEach((element) => {
      element.name = element.name.replace(/\[\d+\]/, `[${newIndex}]`);
    });

    // 新しいフォームにはチェックボックスとラベルを追加しない
    newForm.querySelectorAll('input[type="checkbox"]').forEach(el => el.closest('.delete-checkbox').remove());

    // 新しいフォームに削除ボタンを追加する
    const removeButton = this.createRemoveButton('ingredient');
    const formRow = newForm.querySelector('.row');
    formRow.appendChild(removeButton);

     // 新しいフォームに `data-new-form="true"` を設定
    newForm.setAttribute('data-new-form', 'true');

    const addIngredientLink = this.element.querySelector('.add-ingredient');
    this.nestedFormsTarget.insertBefore(newForm, addIngredientLink);
  }

  addInstructionForm(event) {
    event.preventDefault();
    const newForm = document.querySelector('.instruction-fields').cloneNode(true);
    const timestamp = new Date().getTime();
    newForm.innerHTML = newForm.innerHTML.replace(/_attributes_\d+_/g, `_attributes_${timestamp}`);
    newForm.querySelectorAll('input, textarea').forEach(input => input.value = ''); // 追加されたフォームの値をリセット

    // 新しいフィールドの名前属性を更新
    const fieldSets = this.nestedFormsTarget.querySelectorAll('.instruction-fields');
    const newIndex = fieldSets.length;
    newForm.querySelectorAll('[name]').forEach((element) => {
      element.name = element.name.replace(/\[\d+\]/, `[${newIndex}]`);
    });

    // 新しいフォームにはチェックボックスとラベルを追加しない
    newForm.querySelectorAll('input[type="checkbox"]').forEach(el => el.closest('.delete-checkbox').remove());

    // 新しいフォームに番号を付ける
    newForm.querySelector('input[name*="[step_number]"]').value = ++this.instructionCount;

    const removeButton = this.createRemoveButton('instruction');
    const formRow = newForm.querySelector('.row');
    formRow.appendChild(removeButton);

    const addInstructionLink = this.element.querySelector('.add-instruction');
    this.nestedFormsTarget.insertBefore(newForm, addInstructionLink);
  }

  removeForm(event) {
    event.preventDefault();
    const formContainer = event.target.closest('.instruction-fields, .ingredient-fields');
    if (formContainer) {
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
    removeButton.className = `remove-${type} btn btn-danger remove-button`;
    removeButton.setAttribute('data-action', 'click->dynamic-form#removeForm');
    return removeButton;
  }

  addRemoveButtonsToNewFormsForNew() {
    const newForms = this.nestedFormsTarget.querySelectorAll('[data-new-form="true"]');
    newForms.forEach((form, index) => {
      if (index > 0) { // 最初のフォームには削除ボタンを追加しない
        if (!form.querySelector('.remove-button')) {
          const type = form.classList.contains('ingredient-fields') ? 'ingredient' : 'instruction';
          const removeButton = this.createRemoveButton(type);
          const formRow = form.querySelector('.row');
          formRow.appendChild(removeButton);
        }
      }
    });
  }

  addRemoveButtonsToNewFormsForEdit() {
    const newForms = this.nestedFormsTarget.querySelectorAll('[data-new-form="true"]');
    newForms.forEach((form) => {
      if (!form.querySelector('.remove-button')) {
        const type = form.classList.contains('ingredient-fields') ? 'ingredient' : 'instruction';
        const removeButton = this.createRemoveButton(type);
        const formRow = form.querySelector('.row');
        formRow.appendChild(removeButton);
      }
    });
  }
}