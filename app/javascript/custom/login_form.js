"use strict";

document.addEventListener("turbo:load", function () {
  const form = document.getElementById("signup-form");

  form.addEventListener("submit", function (event) {
    const usernameInput = document.getElementById("newName");
    const passwordInput = document.getElementById("newPass");
    const username = usernameInput.value;
    const password = passwordInput.value;

    if (username.length > 12) {
      alert("ユーザー名は12文字以下で入力してください");
      event.preventDefault(); // フォームの送信をキャンセル
      return;
    }

    if (
      !/^[a-zA-Z0-9]+$/.test(password) ||
      password.length < 4 ||
      password.length > 12
    ) {
      alert("パスワードは半角英数4文字以上12文字以下で入力してください");
      event.preventDefault(); // フォームの送信をキャンセル
      return;
    }
  });
});
