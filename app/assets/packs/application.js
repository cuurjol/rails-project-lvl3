// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/assets and only use these pack files to reference
// that code so it'll be compiled.

import * as bootstrap from 'bootstrap'
import "../stylesheets/application.scss"
import "@fortawesome/fontawesome-free/css/all"
import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"

Rails.start()
ActiveStorage.start()

setTimeout(() => { document.getElementById('flashMessage').style.display = 'none'; }, 4000);
