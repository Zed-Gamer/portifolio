document.addEventListener("DOMContentLoaded", () => {
  const yearEl = document.getElementById("year");
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  const toggle = document.querySelector(".nav-toggle");
  const navList = document.getElementById("primary-nav");
  if (toggle && navList) {
    toggle.addEventListener("click", () => {
      const open = navList.classList.toggle("open");
      toggle.setAttribute("aria-expanded", String(open));
    });
  }

  const observer = new IntersectionObserver(
    entries => entries.forEach(e => {
      if (e.isIntersecting) e.target.classList.add("visible");
    }),
    { threshold: 0.2 }
  );
  document.querySelectorAll(".reveal").forEach(el => observer.observe(el));

  const form = document.getElementById("contact-form");
  const status = document.getElementById("form-status");
  if (form) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      const name = (document.getElementById("name") || {}).value || "";
      const email = (document.getElementById("email") || {}).value || "";
      const message = (document.getElementById("message") || {}).value || "";
      if (!name || !email || !message) {
        if (status) status.textContent = "Please fill in all fields.";
        return;
      }
      const subject = encodeURIComponent("Portfolio Inquiry – " + name);
      const body = encodeURIComponent(`Name: ${name}\nEmail: ${email}\n\n${message}`);
      const mailto = `mailto:mohamedemadrashid@gmail.com?subject=${subject}&body=${body}`;
      window.location.href = mailto;
      if (status) status.textContent = "Opening your email client…";
    });
  }
});
