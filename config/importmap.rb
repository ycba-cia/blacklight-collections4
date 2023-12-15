# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@github/auto-complete-element", to: "https://cdn.skypack.dev/@github/auto-complete-element"
pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.js"
#use bootstrap.bundle rather than popper and bootstrap
#pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.6/dist/umd/popper.min.js"
#pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.1/dist/js/bootstrap.js"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.1/dist/js/bootstrap.bundle.js"
