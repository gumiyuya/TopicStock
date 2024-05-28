"use strict";

document.addEventListener("turbo:load", function () {
  let nav = document.querySelector("#navArea");
  let btn = document.querySelector(".cog-btn");
  let mask = document.querySelector("#mask");

  btn.onclick = () => {
    nav.classList.toggle("open");
    btn.classList.toggle("open");
  };

  mask.onclick = () => {
    nav.classList.toggle("open");
  };
});
