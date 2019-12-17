# README

Question and answer - приложение для вопросов и ответов.

Приложение разработано для того, чтобы разные пользователи могли задавать на нем свои вопросы, отвечать на вопросы других пользователей. Пользователи имеют возможность авторизоваться посредством логина и пароля или же через facebook, github. Реализована возможность голосовать за или против выбранных вопросов. Приложением присуждаются бэйджи за достижения пользователей. Реализован полнотекстовый поиск. Реализована возможность подписки на выбранные вопросы с последующей рассылкой на почту всех изменений связанных с этим вопросом.

Ruby version: 2.5.3 Rails: 5.2.2 Database: Postgresql

При разработке проекта была применена методология TDD. В самом проекте для удаленного хранения файлов использовалась библиотека ActiveStorage. Реализована аутентификация через github. (Протокол OAuth) Разработан Api. Реализован полнотекстовый поиск при помощи Sphinx. Использовались такие технологии как ActionCabel, фоновые задачи. Для создания и управления ролями и правами пользователей в приложении использован гем cancancan. Была осуществлена работа с полиморфными ассоциациями.

