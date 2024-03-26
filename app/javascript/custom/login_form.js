"use strict";

document.addEventListener("turbo:load", function () {
  // フォームの要素を取得
  const form = document.getElementById("signup-form");

  // フォームが送信されるときの処理
  form.addEventListener("submit", function (event) {
    // 入力値を取得
    const usernameInput = document.getElementById("newname");
    const passwordInput = document.getElementById("newpass");
    const username = usernameInput.value;
    const password = passwordInput.value;

    // バリデーションを実行
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
