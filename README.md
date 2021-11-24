# TASK

[![Build Status](https://app.travis-ci.com/willy-wonka-git/twinslashzero.svg?branch=main)](https://app.travis-ci.com/willy-wonka-git/twinslashzero) ![GitHub language count](https://img.shields.io/github/languages/count/willy-wonka-git/twinslashzero?style=social) ![License](https://img.shields.io/badge/license-MIT%20license-blue)

<style>
.mark {
  background-color: yellow;
}    
</style>

[Task](https://docs.google.com/document/d/1390ZczB-uCVaH0bsxH0qKALk1YQAeK9yta7LalW1hvo/edit#heading=h.800vgi95v9ga)

[Demo](https://blooming-journey-21325.herokuapp.com/)

# TODO

1) config/*.yml файлы с паролями / ключами доступа API - не должны лежать в репозитории.
2) нет тестов
3) нужно прогнать rubocop
4) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/controllers/posts_controller.rb - прямо что-то страшное происходит, детально пока не смотрел
8) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/helpers/icon_helper.rb - CSS стили должны быть в файлах стилей
10) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/javascript/packs/application.js - тоже каша по качеству кода, детально пока-что не смотрел
11) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/models/post.rb#L8 - почему теги удаляются вместе с постом ?
12) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/models/post.rb#L12 - default_scope - плохая практика, потому что меняет выборку по умолчанию
13) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/models/post.rb - в модели поста, куча кода, который относится к тегам, а не к постам
14) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/models/post.rb - self.published, self.not_moderated ... - это все нужно делать через scopes
17) после ввода логина + пароля = получил страницу системной ошибки (The change you wanted was rejected.Maybe you tried to change something you didn't have access to. If you are the application owner check the logs for more information.) с 422 кодом.
18) при попытке сохранить обьявление получил 404 ошибку и опять системную страницу.
19) при попытке удалить юзера 404 ошибка

---

Василий, добрый день, направляю вам ошибки по вашему тестовому, которые надо было бы исправить. + есть рекомендация    Я бы рекомендовал для начала выполнить вот этот тестовый проект(https://www.softcover.io/read/db8803f7/ruby_on_rails_tutorial_3rd_edition_russian/beginning) и внимательно не спеша изучить (https://guides.rubyonrails.org/).

---

# Done

5) Gemfile - нет одного стиля, к одним гемам есть комментарии к другим - нету, нет версий у многих гемов - должны быть версии  
    <small>Исправил</small>

6) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/controllers/welcome_controller.rb - пустой файл, не понятно зачем он  
    <small class="mark">
    *Для главной страницы. В rails после 3й версии views самостоятельно не рендерится без контроллера и вываливается ошибка.     
    [Подробнее](https://stackoverflow.com/questions/1352420/rails-view-without-a-controller/14249363)*
    </small>     

7) https://github.com/willy-wonka-git/twinslashzero/tree/main/app/helpers - пустые файлы  
    <small>Исправил</small>


9) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/javascript/packs/application.js - каша по оформлению, отступы гуляют  
    <small>Исправил</small>

15) не понял почему неавторизованный юзер, может видеть список всех пользоателей с ролями?
    <small>Исправил</small>
    
16) когда в локализации выбрал флажек USA - отображается русский интерфейс и наоборот  
    <small>? Текущая локаль не должна выводиться  
    *app/views/layouts/_navbar.html.haml*
    ``` 
          - I18n.available_locales.each do |item|
            - if item != I18n.locale
              ...
    ```
    </small>
    
---
RSpec (capybara, turnip)   
	- coverage  
	- [пример](https://semaphoreci.com/community/tutorials/how-to-test-rails-models-with-rspec)

