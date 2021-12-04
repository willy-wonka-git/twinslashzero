# TASK

[![Build Status](https://app.travis-ci.com/willy-wonka-git/twinslashzero.svg?branch=main)](https://app.travis-ci.com/willy-wonka-git/twinslashzero) ![GitHub language count](https://img.shields.io/github/languages/count/willy-wonka-git/twinslashzero?style=social) ![License](https://img.shields.io/badge/license-MIT%20license-blue)

[Task](https://docs.google.com/document/d/1390ZczB-uCVaH0bsxH0qKALk1YQAeK9yta7LalW1hvo/edit#heading=h.800vgi95v9ga)

[Demo](https://blooming-journey-21325.herokuapp.com/)

# TODO

0. перепроверить авторизацию твиттер в production после обновлений

4) У админа при нажатии на control panel требует ввести логин и пароль(какой не понятно)Create user admin for ActiveAdminAdminUser.create!(email: 'admin@gmail.com', password: '111111', password_confirmation: '111111') - вот эти данные не подходят    
5) Если при создании заполнить все поля и выбрать картинки, нажать сохранить, и при этом не пройдут валидации, то картинки потеряются  
7) https://github.com/willy-wonka-git/twinslashzero/blob/main/.rubocop_basic.yml - везде подописывал exclude с файлами - которые нужно менять, а не исключать их из линтера тут нужно убрать из exclude файлы:  
app/controllers/users/omniauth_callbacks_controller.rb  
app/controllers/posts_controller.rb  
app/models/user.rb  
app/controllers/users_controller.rb  
и переделать их в соответствии с тем что просит rubocop  
10) https://github.com/willy-wonka-git/twinslashzero/blob/main/spec/support/controller_macros.rb  
логика двух методов фактически дублируется это можно переделать например  
    ```ruby
    def login_user(type = :user)    
        user = FactoryBot.create(type)
        sign_in user    
        User.current_user = user
    end
    ```
11) в тестах много где на прямую используются модели для создания, для всех сущностей должны использовать Factories  
12) User.current_user= - это плохо, не должно быть глобальных состояний у модели, это тяжело отслеживать. current_user может быть только в контроллере, во все остальные места где это нужно, нужно передавать его как параметр.  
13) добавил rake таски(https://github.com/willy-wonka-git/twinslashzero/tree/main/lib/tasks) при этом в https://github.com/willy-wonka-git/twinslashzero/blob/main/config/schedule.rb вызываешь методы модели на прямую, получается рейк таски не используются  
14) get '/user/:id' => 'users#show', as: 'user'get '/users' => 'users#index'delete '/user/:id' => 'users#destroy'для этого же можно использовать resources - https://guides.rubyonrails.org/routing.html#crud-verbs-and-actions  
15) https://github.com/willy-wonka-git/twinslashzero/blob/main/app/controllers/users/omniauth_callbacks_controller.rbметоды vkontakte и twitter очень похожие друг на друга, это дублированиеаналогично https://github.com/willy-wonka-git/twinslashzero/blob/main/app/models/user.rbfrom_vkontakte_omniauthfrom_twitter_omniauth

---

# Done

1) У пользователей в профиле - показывает Adverts 4 - при этом не одного обьявления не отображается  
    *Исправил*
2) пользователем создал обьявление и оно нигде не отображается  
    *Черновики видят только автор и админ в профиле пользователя. В списке на модерацию будут засорять список.*
3) при отклонении обьявления, если в окно ввода причины просто жать ок, то это окно потом будет бесконечно висеть - при нажатии отмены  
    *Проверил под разными углами, но не могу повторить. Добавил сообщение о необходимости ввода и event.stopPropagation()*

6) Обьявления которые на модерации - открываются по прямой ссылке любым пользователем, аналогично с draft.  
    *Исправил*

8) .idea - все что не относится к коду проекта должно быть в gitignore - в данном случае это настройки редактора  
    *Исправил*
9) https://github.com/willy-wonka-git/twinslashzero/tree/main/test - папка осталась висеть, в ней все папки пустые, получается что смысловой нагрузки они не несет, только сбивает с толку. таких вещей не должно быть в проекте.  
    *Исправил*
    