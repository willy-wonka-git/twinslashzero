# TASK

[![Build Status](https://app.travis-ci.com/willy-wonka-git/twinslashzero.svg?branch=main)](https://app.travis-ci.com/willy-wonka-git/twinslashzero) ![GitHub language count](https://img.shields.io/github/languages/count/willy-wonka-git/twinslashzero?style=social) ![License](https://img.shields.io/badge/license-MIT%20license-blue)

[Task](https://docs.google.com/document/d/1390ZczB-uCVaH0bsxH0qKALk1YQAeK9yta7LalW1hvo/edit#heading=h.800vgi95v9ga)

[Demo](https://blooming-journey-21325.herokuapp.com/)

# TODO

1) config/*.yml файлы с паролями / ключами доступа API - не должны лежать в репозитории.
2) нет тестов
3) нужно прогнать rubocop
    почитать гадстайл
    
4) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/controllers/posts_controller.rb - прямо что-то страшное происходит, детально пока не смотрел  
    *?*

17) после ввода логина + пароля = получил страницу системной ошибки (The change you wanted was rejected.Maybe you tried to change something you didn't have access to. If you are the application owner check the logs for more information.) с 422 кодом.
    *
    ```ruby
    ActionController::InvalidAuthenticityToken in Devise::SessionsController#create
    ```     
    Ошибка работы devise + form_for, разбираюсь. Пока не знаю, как лечить. Если верно авторизоваться и выйти, а после ввести неверный пароль с существующим логином, то ошибка.  
    Для лечения пока надо обновлять страницу или вводить только верный пароль*

---

Василий, добрый день, направляю вам ошибки по вашему тестовому, которые надо было бы исправить. + есть рекомендация
Я бы рекомендовал для начала выполнить вот этот тестовый проект(https://www.softcover.io/read/db8803f7/ruby_on_rails_tutorial_3rd_edition_russian/beginning) и внимательно не спеша изучить (https://guides.rubyonrails.org/).  

---

# Done


5) Gemfile - нет одного стиля, к одним гемам есть комментарии к другим - нету, нет версий у многих гемов - должны быть версии  
    *Исправил*

6) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/controllers/welcome_controller.rb - пустой файл, не понятно зачем он  
    *Для главной страницы. В rails после 3й версии views самостоятельно не рендерится без контроллера и вываливается ошибка.     
    [Подробнее](https://stackoverflow.com/questions/1352420/rails-view-without-a-controller/14249363)*
 
7) https://github.com/willy-wonka-git/twinslashzero/tree/main/app/helpers - пустые файлы  
    *Исправил*

8) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/helpers/icon_helper.rb - CSS стили должны быть в файлах стилей  
    *Исправил*

9) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/javascript/packs/application.js - каша по оформлению, отступы гуляют  
    *Исправил*

10) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/javascript/packs/application.js - тоже каша по качеству кода, детально пока-что не смотрел  
    *Подправил*

11) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/models/post.rb#L8 - почему теги удаляются вместе с постом ?  
    *Исправил*

12) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/models/post.rb#L12 - default_scope - плохая практика, потому что меняет выборку по умолчанию  
    *Исправил*

13) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/models/post.rb - в модели поста, куча кода, который относится к тегам, а не к постам  
    *Подправил*

14) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/models/post.rb - self.published, self.not_moderated ... - это все нужно делать через scopes  
    *Исправил*

15) не понял почему неавторизованный юзер, может видеть список всех пользоателей с ролями?  
    *Исправил*
    
16) когда в локализации выбрал флажек USA - отображается русский интерфейс и наоборот  
    *? Текущая локаль не должна выводиться в меню, сделано с заделом на увеличение количества локалей  
    *app/views/layouts/_navbar.html.haml*
    ``` 
          - I18n.available_locales.each do |item|
            - if item != I18n.locale
              ...
    ```
    *    

18) при попытке сохранить обьявление получил 404 ошибку и опять системную страницу.
    *Исправил*

19) при попытке удалить юзера 404 ошибка  
    *Исправил*
    
---
RSpec (capybara, turnip)   
	- coverage  
	- [пример](https://semaphoreci.com/community/tutorials/how-to-test-rails-models-with-rspec)

--
добавить кнопка удалить пользователя на странице юзера
(проверить права и кнопки под обычным пользователем)


узнать как они сами делают скрытие настроек (переменные среды, файлы в гитигнор, и как разделить пуши гита и хероку),  
узнать какая основная среда разработки  
может поделятся базовыми настройками рубокопа  
simple_form_for(@post) - на ура, но для тестов надо simple_form_for(@post, url: post_path(id: @post.id)) - ломает вью  
