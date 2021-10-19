# TASK

[Original task](https://docs.google.com/document/d/1390ZczB-uCVaH0bsxH0qKALk1YQAeK9yta7LalW1hvo/edit#heading=h.800vgi95v9ga)

[Demo on Heroku](https://blooming-journey-21325.herokuapp.com/)

# TODO

- добавить теги
- настроить и локализовать формы тегов
- добавить объявления
	- автор
	- категория
	- теги
	- картинки

* Настроить форму просмотра и редактирования от роли (cancancan)
	https://www.bogotobogo.com/RubyOnRails/RubyOnRails_Devise_Adding_User_Field_and_Customization_Update_Saved.php
	https://stackoverflow.com/questions/25223919/rails-devise-customize-the-create-method

* Теория по гемам cancancan, state_machine || aasm, nested_form

* модель "теги объявления" [1](https://www.sitepoint.com/tagging-scratch-rails/) [2](https://medium.com/@sherzelsmith/add-a-filtering-multiple-tag-system-with-autocomplete-to-your-rails-model-in-rails-5-1bf88cd53e9) (автокомплит, несколько, https://select2.org/) 
	- поиск (ransack)
	- удалять теги без объявлений (cron или админу)

* модель "объявление" (CRUD, сортировка, фильтр) // time_ago_in_words(post.created_at)

* модель "статус объявления" (state_machine || aasm)
	- "черновик" - не виден в ленте, можно изменять
	- "новая" 
		юзер может только удалить
		админ одобрить или отклонить с причиной (может несколько)
	- "блокировано" (причина)
	- "опубликовано"
	- "архив" - после 3х дней публикации в 23:50
	- автор может перевести "архив" в "черновик"

* Роли юзеров admin, user, guest (enumerize + cancancan || pundit)
	- юзер 
		создает\редактирует черновик
		удалять
	- админ
		удалять тип объяв, если нет ни одного
		создавать тип объяв
		добавлять\удалять\редактировать пользователя
		не может создавать\редактировать объявы
		может удалить объяву

* генерация сидов - faker

* модерация - причина отклонения (обязательное)
	- история статуса: кто / когда / статус / комментарий (если отклонено)
	- ajax
	- история правок статуса на странице объявления (админ и автор)

* "картинки" объявления (превью 100х100, nested_form)
	- облако cloudinary.com/documentation

* тесты rspec (capybara, factory_bot)
	приемочные тесты turnip (браузер) 

* запросы squeel 
* Публикация объявлений и архив cron - rake + whenever
* админка https://administrate-demo.herokuapp.com/authentication https://github.com/thoughtbot/administrate

* Аутентификация через соцсети [habr](https://habr.com/ru/post/142128/) [devise](https://github.com/heartcombo/devise/wiki/OmniAuth:-Overview) (вк, твиттер, фейсбук)
