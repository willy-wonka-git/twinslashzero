# TASK

[Original task](https://docs.google.com/document/d/1390ZczB-uCVaH0bsxH0qKALk1YQAeK9yta7LalW1hvo/edit#heading=h.800vgi95v9ga)

[Demo on Heroku](https://blooming-journey-21325.herokuapp.com/)

# TODO

доделать смену состояния

 	групповая операция в списке

ранзак - сортировка и поиск

----------------
- кнопка удалить в форму редактирования поста

- кнопка удалить в форму редактирования категории постов (если нет объявлений)

- админ - на форме категорий кнопка удалить, если нет объявлений

- удалять теги без постов
----------------
- крон закрытие объявлений в архив после 3х дней публикации в 23:50

- крон удаление тегов sequel 

- админка

- RSpec

- Travis CI
--------------------------------------------------

* удалять теги без объявлений (cron или админу вручную)

* тесты rspec (capybara, factory_bot)
	приемочные тесты turnip (браузер) 

* Публикация объявлений и архив cron - rake + whenever
* админка https://administrate-demo.herokuapp.com/authentication https://github.com/thoughtbot/administrate

* Аутентификация через соцсети [habr](https://habr.com/ru/post/142128/) [devise](https://github.com/heartcombo/devise/wiki/OmniAuth:-Overview) (вк, твиттер, фейсбук)

