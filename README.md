# TASK

[Original task](https://docs.google.com/document/d/1390ZczB-uCVaH0bsxH0qKALk1YQAeK9yta7LalW1hvo/edit#heading=h.800vgi95v9ga)

[Demo on Heroku](https://blooming-journey-21325.herokuapp.com/)

# TODO

доделать смену состояния
 	групповая операция в списке
ранзак - сортировка и поиск

----------------
- кнопка удалить в форму редактирования поста
- кнопка удалить в форму редактирования категории постов

- админ - на форме категорий кнопка удалить, если нет объявлений
- удалять теги без постов
----------------
- крон закрытие объявлений в архив 
- крон удаление тегов sequel 
- админка

- RSpec
- Travis CI
--------------------------------------------------

* модель "статус объявления" (state_machine || aasm)
	https://www.nopio.com/blog/ruby-state-machine-aasm-tutorial/
	- "draft" - не виден в ленте, можно изменять
	- "new" 
		юзер может только удалить
		админ одобрить или отклонить с причиной (может несколько)
	- "ban" (причина)
	- "publish"
	- "archive" - после 3х дней публикации в 23:50
	- автор может перевести "archive" в "draft"

* Роли юзеров admin, user, guest (enumerize + cancancan || pundit)
	- юзер 
		создает\редактирует черновик
	- админ
		удалять тип объяв, если нет ни одного

* Фильтр и сортировка объявлений
	- поиск (ransack)

* модерация - причина отклонения (обязательное)
	- история статуса: кто / когда / статус / комментарий (если отклонено)
	- ajax
	- история правок статуса на странице объявления (админ и автор)

* удалять теги без объявлений (cron или админу вручную)

* тесты rspec (capybara, factory_bot)
	приемочные тесты turnip (браузер) 

* Публикация объявлений и архив cron - rake + whenever
* админка https://administrate-demo.herokuapp.com/authentication https://github.com/thoughtbot/administrate

* Аутентификация через соцсети [habr](https://habr.com/ru/post/142128/) [devise](https://github.com/heartcombo/devise/wiki/OmniAuth:-Overview) (вк, твиттер, фейсбук)

