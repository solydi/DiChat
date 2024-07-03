# DiChat

### [Головний розробник (Telegram)](https://t.me/lisowsky)

## Опис DiChat.lua для сховища GitHub

**DiChat.lua** — це скрипт Lua, розроблений для платформи SAMP (San Andreas Multiplayer). Сценарій розроблено для покращення ігрового процесу шляхом керування взаємодіями в чаті в грі, пропускання непотрібних повідомлень і автоматизації певних повторюваних завдань. Нижче наведено детальний опис можливостей і функцій сценарію:

## Особливості

- **Автоматична фільтрація повідомлень:**
Автоматично пропускає попередньо визначені повідомлення «кошик», щоб зберегти чат чистим і актуальним.

- **Керування версіями та оновленнями:**
Перевіряє наявність оновлень, порівнюючи версію локального сценарію з версією, доступною на віддаленому сервері.
Автоматично завантажує та оновлює сценарій, якщо знайдено новішу версію.

- **Інтеграція з MoonLoader:**
Використовує MoonLoader для завантаження оновлень і обробки залежностей сценаріїв.

- **Настроювані сповіщення та сповіщення:**
Відображає настроювані ігрові сповіщення та попередження для гравців.

- **Інтеграція команд:**
Надає такі команди, як /update, для ручної перевірки та застосування оновлень.

## Використання

- **Встановлення:**
Завантажте сценарій і розмістіть його в каталозі сценаріїв MoonLoader.
Переконайтеся, що MoonLoader встановлено та налаштовано правильно.

- **Команди:**
/update: вручну перевіряє наявність оновлень і застосовує їх, якщо вони доступні.

## Конфігурація

Сценарій можна налаштувати шляхом зміни певних змінних у сценарії. Ключові конфігурації включають:

- **'update_url':** URL-адреса для перевірки оновлень.
- **'script_url':** URL-адреса, звідки завантажується сценарій.
- **'update_path':** Шлях, де зберігається інформація про оновлення.

## Вимоги

- **SAMP (San Andreas Multiplayer):** Багатокористувацька модифікація для GTA: San Andreas.
- **MoonLoader:** Завантажувач сценаріїв Lua для SAMP.

## Внесок

Внески вітаються! Якщо ви виявите будь-які проблеми або маєте пропозиції щодо покращення, не соромтеся відкривати проблему або надсилати запит на отримання.

## Ліцензія

Ліцензія Apache версії 2.0