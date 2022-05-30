// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/assets and only use these pack files to reference
// that code so it'll be compiled.

// Some useful links for JS:
// https://youmightnotneedjquery.com/
// https://gist.github.com/joyrexus/7307312
// https://webdesign.tutsplus.com/articles/essential-cheat-sheet-convert-jquery-to-javascript--cms-35633

import * as bootstrap from 'bootstrap'
import "../stylesheets/application.scss"
import "@fortawesome/fontawesome-free/css/all"
import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"

Rails.start()
ActiveStorage.start()

function closeFlashMessage() {
	let flash_element = document.getElementById('flashMessage')
	if (flash_element) {
		setTimeout(() => { flash_element.style.display = 'none'; }, 4000);
	}
}

function refreshSearchFilters() {
	Array.prototype.forEach.call(document.querySelectorAll('select[data-field]'), function (filter) {
		filter.addEventListener("change", (event) => {
			let {field, type} = filter.dataset;

			let predicate = filter.value
			if (predicate === '') {
				if (type === 'string') {
					predicate = 'cont'
				} else {
					predicate = 'eq'
				}
			}

			let old_value = filter.id;
			let new_value = `q_${field}_${predicate}`;

			let div_element = document.querySelector(`div[class*=${old_value}]`);
			div_element.classList.remove(old_value);
			div_element.classList.add(new_value);

			let label_element = document.querySelector(`label[for=${old_value}]`);
			label_element.setAttribute('for', new_value);

			filter.id = new_value

			let found_element = document.querySelectorAll(`[id^=q_${field}_]`)[1];
			found_element.setAttribute('id', new_value);
			found_element.setAttribute('name', `q[${field}_${predicate}]`);
			if (filter.value === '') {
				found_element.value = ''
			}

			event.preventDefault();
		});
	});
}

// https://stackoverflow.com/a/65614338
// https://github.com/twbs/bootstrap/issues/11037
function fixTableDropdownsMenu() {
	Array.prototype.forEach.call(document.querySelectorAll('.btn-group'), function (btn) {
		btn.addEventListener('show.bs.dropdown', function (event) {
			let dropdownBtnId = event.target.id;
			let dropdownMenu = document.querySelector(`#dropdown-menu-${dropdownBtnId.replace('dropdown-btn-', '')}`);
			let eventOffset = event.target.getBoundingClientRect();

			document.body.appendChild(dropdownMenu.parentElement.removeChild(dropdownMenu));
			dropdownMenu.style.display = 'block';
			dropdownMenu.style.top = `${eventOffset.top + event.target.offsetHeight}px`;
			dropdownMenu.style.left = `${eventOffset.left}px`;
		});

		btn.addEventListener('hide.bs.dropdown', function (event) {
			let dropdownBtnId = event.target.id;
			let dropdownMenu = document.querySelector(`#dropdown-menu-${dropdownBtnId.replace('dropdown-btn-', '')}`);
			event.target.parentElement.appendChild(dropdownMenu.parentElement.removeChild(dropdownMenu));
			dropdownMenu.style.display = 'none';
		});
	});
}

document.addEventListener('DOMContentLoaded', function() {
	closeFlashMessage();
	refreshSearchFilters();
	fixTableDropdownsMenu();
});
