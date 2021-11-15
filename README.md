# TASK

[Original task](https://docs.google.com/document/d/1390ZczB-uCVaH0bsxH0qKALk1YQAeK9yta7LalW1hvo/edit#heading=h.800vgi95v9ga)

[Demo on Heroku](https://blooming-journey-21325.herokuapp.com/)

# TODO

RSpec (capybara, приемочные тесты turnip (браузер))  
travis (требует время и платежные реквизиты)  

### last updates

групповые операции при модерировании  
поиск постов по тегам  
админка ActiveAdmin  
schedule rake-задачи на хероку  
social networks auth - vk, twitter  
исправлены старые и добавлены новые ошибки


### Уточнить работу и генерацию путей

    # controller.extra_params = { :id => @post_category.id }
    # render template: 'post_categories/edit', :locals => { locale: :en, @post_category => @post_category }
    # assert_select "form[action=?][method=?]", post_categories_url(@post_category), "post" do
