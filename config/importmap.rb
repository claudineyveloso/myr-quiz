# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js"
pin "sweetalert2", to: "https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"
#bin/pin "rails_admin", preload: true
#pin "rails_admin/src/rails_admin/base", to: "https://ga.jspm.io/npm:rails_admin@3.2.0/src/rails_admin/base.js"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@6.1.7/lib/assets/compiled/rails-ujs.js"
#pin "jquery-ui", to: "https://ga.jspm.io/npm:jquery-ui@1.13.3/dist/jquery-ui.js"
