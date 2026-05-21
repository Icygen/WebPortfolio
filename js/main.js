(function () {

  const yearEl = document.getElementById("year");



  if (yearEl) {

    yearEl.textContent = String(new Date().getFullYear());

  }



  initMobileNav();

  initScrollReveal();

  initActiveNav();

  initContactForm();

})();



function initMobileNav() {

  const navToggle = document.querySelector(".nav-toggle");

  const siteNav = document.querySelector(".site-nav");

  const navLinks = document.querySelectorAll(".site-nav a");



  if (!navToggle || !siteNav) return;



  function closeNav() {

    navToggle.setAttribute("aria-expanded", "false");

    navToggle.setAttribute("aria-label", "Open menu");

    siteNav.classList.remove("is-open");

  }



  function openNav() {

    navToggle.setAttribute("aria-expanded", "true");

    navToggle.setAttribute("aria-label", "Close menu");

    siteNav.classList.add("is-open");

  }



  navToggle.addEventListener("click", function () {

    const isOpen = navToggle.getAttribute("aria-expanded") === "true";

    if (isOpen) {

      closeNav();

    } else {

      openNav();

    }

  });



  navLinks.forEach(function (link) {

    link.addEventListener("click", closeNav);

  });



  document.addEventListener("keydown", function (e) {

    if (e.key === "Escape") closeNav();

  });

}



function prefersReducedMotion() {

  return window.matchMedia("(prefers-reduced-motion: reduce)").matches;

}



function initScrollReveal() {

  const revealEls = document.querySelectorAll(".reveal");



  if (!revealEls.length) return;



  if (prefersReducedMotion()) {

    revealEls.forEach(function (el) {

      el.classList.add("is-visible");

    });

    return;

  }



  const observer = new IntersectionObserver(

    function (entries) {

      entries.forEach(function (entry) {

        if (!entry.isIntersecting) return;

        entry.target.classList.add("is-visible");

        observer.unobserve(entry.target);

      });

    },

    { rootMargin: "0px 0px -6% 0px", threshold: 0.08 }

  );



  revealEls.forEach(function (el) {

    observer.observe(el);

  });

}



function initActiveNav() {

  const navLinks = document.querySelectorAll('.site-nav a[href^="#"]');

  const sections = [];



  navLinks.forEach(function (link) {

    const id = link.getAttribute("href").slice(1);

    const section = id ? document.getElementById(id) : null;

    if (section) sections.push(section);

  });



  if (!sections.length) return;



  function setActiveLink(id) {

    navLinks.forEach(function (link) {

      const linkId = link.getAttribute("href").slice(1);

      const isActive = linkId === id;



      link.classList.toggle("is-active", isActive);

      if (isActive) {

        link.setAttribute("aria-current", "true");

      } else {

        link.removeAttribute("aria-current");

      }

    });

  }



  const observer = new IntersectionObserver(

    function (entries) {

      const visible = entries.filter(function (entry) {

        return entry.isIntersecting;

      });



      if (!visible.length) return;



      const current = visible.reduce(function (best, entry) {

        return entry.intersectionRatio > best.intersectionRatio ? entry : best;

      });



      setActiveLink(current.target.id);

    },

    {

      rootMargin: "-28% 0px -58% 0px",

      threshold: [0, 0.15, 0.35, 0.55, 0.75, 1],

    }

  );



  sections.forEach(function (section) {

    observer.observe(section);

  });

}



function initContactForm() {

  const form = document.getElementById("contact-form");

  const keyInput = document.getElementById("web3forms-access-key");

  const statusEl = document.getElementById("form-status");

  const setupNote = document.getElementById("form-setup-note");

  const submitBtn = document.getElementById("form-submit");

  const config = window.PORTFOLIO_FORM || {};

  const accessKey = String(config.accessKey || "").trim();



  if (!form) return;



  function setStatus(message, type) {

    if (!statusEl) return;

    statusEl.textContent = message;

    statusEl.classList.remove("is-success", "is-error");

    if (type) statusEl.classList.add(type);

  }



  if (keyInput) {

    keyInput.value = accessKey;

  }



  if (!accessKey) {

    if (setupNote) setupNote.hidden = false;

    if (submitBtn) submitBtn.disabled = true;

    setStatus("", null);

    return;

  }



  if (setupNote) setupNote.hidden = true;

  if (submitBtn) submitBtn.disabled = false;



  form.addEventListener("submit", function (e) {

    e.preventDefault();



    if (!form.checkValidity()) {
      form.classList.add("was-validated");
      form.reportValidity();
      return;
    }



    if (submitBtn) submitBtn.disabled = true;

    setStatus("Sending…", null);



    const body = new FormData(form);



    fetch(form.action, {

      method: "POST",

      body: body,

      headers: { Accept: "application/json" },

    })

      .then(function (res) {

        return res.json().then(function (data) {

          return { ok: res.ok, data: data };

        });

      })

      .then(function (result) {

        if (result.ok && result.data.success) {
          form.reset();
          form.classList.remove("was-validated");
          setStatus("Message sent. I will get back to you soon.", "is-success");

        } else {

          setStatus(

            result.data.message || "Something went wrong. Please try email instead.",

            "is-error"

          );

        }

      })

      .catch(function () {

        setStatus("Could not send. Please email reiv728@gmail.com instead.", "is-error");

      })

      .finally(function () {

        if (submitBtn) submitBtn.disabled = false;

      });

  });

}


