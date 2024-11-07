script_name("{ff7e14}DiChat")
script_author("{ff7e14}solodi")
script_version("1.9.7")

local encoding = require 'encoding'

encoding.default = 'cp1251'
local u8 = encoding.UTF8
local function recode(u8) return encoding.UTF8:decode(u8) end

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется!')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/TankerVScripte/DiChat/main/version.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/TankerVScripte/DiChat"
        end
    end
end

local se = require("samp.events")
local memory = require "memory"
local ini = require "inicfg"

local actual = {
	time = memory.getint8(0xB70153),
	weather = memory.getint16(0xC81320)
}

local cfg = ini.load({
	time = {
		value = 12,
		lock = false
	},
	weather = {
		value = 1,
		lock = false
	}
}, "DiClimate.ini")

local skip = [[

[Подсказка] {DC4747}На сервере есть инвентарь, используйте клавишу Y для работы с ним
[Подсказка] {DC4747}Вы можете задать вопрос в нашу техническую поддержку /report
В нашем магазине ты можешь приобрести нужное количество игровых денег и потратить
их на желаемый тобой {FFFFFF}бизнес, дом, аксессуар{6495ED} или на покупку каких-нибудь безделушек
Игроки со статусом {FFFFFF}VIP{6495ED} имеют больше возможностей, подробнее /help [Преимущества VIP]
Игроки со статусом {FFFFFF}VIP{6495ED} имеют большие возможности, подробнее /help [Преимущества VIP]
В магазине также можно приобрести редкие {FFFFFF}автомобили, аксессуары, воздушные шары
В магазине так-же можно приобрести редкие {FFFFFF}автомобили, аксессуары, воздушные шары
предметы, которые выделят тебя из толпы! Наш сайт: {FFFFFF}arizona-rp.com
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- Основные команды сервера: /menu /help /gps /settings
- Пригласи друга и получи бонус в размере $300 000!
- Пригласи друга и получи бонус в размере $1 000 000 + 4 случайных ларца!
- Наш сайт: arizona-rp.com (Личный кабинет/Донат)
[Аэропорт Лос Сантос] {ffffff}Уважаемые жители штата, открыта продажа билетов на рейс: Лос Сантос — Вайс Сити
[Аэропорт Лос Сантос] {ffffff}Подробнее: {FF6666}/help — Перелёты в город Vice City
[Аэропорт Вайс Сити] {ffffff}Уважаемые жители штата, открыта продажа билетов на рейс: Вайс Сити — Лос Сантос
[Сервер Vice City] {ffffff}Внимание! На сервере Vice City действует акция
[Подсказка] Вы можете купить складское помещение /gps - складские помещения
Этот тип недвижимости будет навсегда закреплен за вами и за него не нужно платить
Таким образом вы можете сберечь своё имущество, даже если вас забанят
[Подсказка] С помощью телефона можно заказать такси. Среднее время ожидания - 2 минуты!
[Подсказка] {FFFFFF}Номера телефонов государственных служб:
{FFFFFF}1.{6495ED} 111 - {FFFFFF}Проверить баланс телефона
{FFFFFF}2.{6495ED} 060 - {FFFFFF}Служба точного времени
{FFFFFF}3.{6495ED} 911 - {FFFFFF}Полицейский участок
{FFFFFF}4.{6495ED} 912 - {FFFFFF}Скорая помощь
{FFFFFF}5.{6495ED} 914 - {FFFFFF}Механик
{FFFFFF}6.{6495ED} 8828 - {FFFFFF}Справочная центрального банка
{FFFFFF}7.{6495ED} 997 - {FFFFFF}Служба по вопросам жилой недвижимости (узнать владельца дома)
{DFCFCF}[Подсказка] {DC4747}Выбросить шипы в полицейском авто: {DFCFCF}(Клавиша: 2)
{DFCFCF}[Подсказка] {DC4747}Переключить режим езды в полицейском авто: {DFCFCF}Клавиша: 3 или /style
Ваш аккаунт привязан к серверу Vice City, выберите к какому серверу хотите подключиться.
[Информация] {ffffff}Если Вы перезайдете в игру, то сможете подключиться сразу на Vice City сервер.
[Подсказка] {ffffff}Поскольку вы владеете частным самолетом, можно вылететь моментальным рейсом.
{DFCFCF}[Подсказка] {DC4747}Чтобы завести двигатель введите {DFCFCF}/engine{DC4747} или нажмите {DFCFCF}N
Чтобы открыть круговое меню для управления транспортом
{DFCFCF}[Подсказка] {DC4747}Чтобы включить радио используйте кнопку {DFCFCF}CTRL (/radio)
{DFCFCF}[Подсказка] {DC4747}Для управления поворотниками используйте клавиши: {DFCFCF}(Q/E)
[Vice City News] Вы можете отправить своё объявление. Используйте /ad, чтобы прорекламировать свои услуги или свой бизнес.
[Подсказка] {ffffff}Воспользуйтесь трудовой книжкой через инвентарь (/wbook) для повышения по карьерной лестнице во фракции.
[Подсказка] {FFFFFF}Транспорт создан, не забывайте о /park для парковки транспорта.
[Подсказка] {ffffff}Внимание! На ваше транспортное средство не установлен номерной знак. 
[Подсказка] {ffffff}В связи с этим вам недоступны некоторые функции автомобиля! {CCCCCC}(/help - Ограничения за езду без номеров)
[Подсказка] {ffffff}Выберите комбинацию от которой хотите забрать приз!
[Подсказка] {ffffff}При установленных Twin Turbo и технических компонентов - применяется лучшая характеристика из двух.
[Battle Pass]{ffffff} Доступен новый BattlePass - 'Королевская Битва', успейте получить уникальные награды одним из первых!
[Battle Pass]{ffffff} Для просмотра используйте клавишу 'B'
[Подсказка] {ffffff}Для быстрого доступа к меню анимаций, используйте {ff6666}клавишу U
[Подсказка] Ларец добавляется каждые 3 часа.
[Подсказка] {ffffff}Ваш уровень сытости ниже 20%, теперь Вы не можете быстро бегать.
[Ошибка] {ffffff}Ваш уровень сытости ниже 20%, поэтому Вы не можете быстро бегать.
Используйте /olock чтобы закрыть организационный транспорт.
Используйте клавишу '2', чтобы использовать бортовой компьютер.
Купить лотерейные билеты можно в уличных киосках нашего штата или в самой лотерейной! (/GPS - Мероприятия - Лотерейная)
[Подсказка] {ffffff}Вы получаете в 2 раза больше семейных талонов из-за имеющегося ADD VIP.
[Подсказка] {ffffff}Если вы будете отсутствовать за рулём более 3 минут, транспорт будет отправлен в семейный паркинг.
[Подсказка] {ffffff}Продлить аренду можно через меню арендованного транспорта (/cars)
[Подсказка] {FFFFFF}При входе в банк у вас забрали оружие. Забрать сможете как будете уходить!
[Информация] {FFFFFF}Вы отказались покупать оружие
[Информация] {FFFFFF}Чтобы отказаться от аренды [/unrentcar]
[Информация] {FFFFFF}Чтобы закрыть автомобиль используйте [/jlock]
[Информация] {FFFFFF}У вас есть 2 минуты чтобы вернуться обратно в транспорт.
[Подсказка] {FFFFFF}Для того чтобы выполнить это задание, вам необходимо взять один из грузовиков семьи,
и следовать подсказкам по перевозке груза со склада СФ на склад семьи.
[Подсказка] {FFFFFF}Для того чтобы выполнить это задание, вам необходимо отправиться в Лес,
найти там 3 оленя и застрелить их. После вернуться к Серафиму за наградой!
[Подсказка] {FFFFFF}Отправляйтесь в Железный порт, место отмечено на миникарте
красным маркером. Необходимо продать в порт 1000 рыбы! После вернуться к Юджину!
Этот транспорт принадлежит семье 'Dillinger', стоимость аренды: 0$ в 1 минуту (с банковского счёта)
ВАЖНО! Если Ваша семья проживает в Arizona Tower, то вертолет можно забрать на вертолетной площадке Arizona Tower на пикапе!
[Подсказка] {FFFFFF}Используйте /house для управления домом.
[Депозит] {ffffff}Внимание! В выходные дни комиссия на снятие денег с депозита понижена.
[День Торговли в городе Вайс Сити] {ffffff}Внимание! В субботу на Вайс Сити будет комиссия на продажу и покупку 1 процент.
[День Торговли в городе Вайс Сити] {ffffff}Данная акция действует на Центральном Рынке и переносных лавках.
[Подсказка] {ffffff}Рекомендуем соблюдать местные правила во избежание наказаний! {CCCCCC}( /help — Центр гетто )
[Подсказка] {ffffff}Воспользуйтесь трудовой книжкой через инвентарь (/wbook) для повышения по карьерной лестнице во фракции.
[Подсказка] {ffffff}Подробнее о фракционных заданиях: {ff6666}/wbook {ffffff}или {ff6666}/cbook
{FFFFFF} Используйте /phone - Настройки - Настройки телефона - Мониторинг организаций, чтобы найти членов организаций.
{ffffff}Внимание! На ваше транспортное средство не установлен номерной знак. 
{ffffff}В связи с этим вам недоступны некоторые функции автомобиля! {CCCCCC}(/help - Ограничения за езду без номеров)
{ffffff}Чтобы установить номера на транспорт, обратитесь в {ff6666}отделение полиции Los Santos{ffffff}.
[Подсказка] {ffffff}Для быстрого доступа к меню анимаций, используйте {ff6666}клавишу U
[Подсказка] {ffffff}При установленных Twin Turbo и технических компонентов - применяется лучшая характеристика из двух.
[Подсказка] {ffffff}Вы попали в зону платной парковки. Тариф указан на табличке. Припаркуйте транспорт в свободное место.
[Подсказка] {ffffff}На платной парковке ваш транспорт будет находиться в безопасности и его никто не сможет угнать.
[Подсказка] {ffffff}Вы вошли в зону митинга.
[Подсказка] {ffffff}Вы можете взять табличку для митинга на {ff0000}отмеченном пикапе{ffffff}.
[Подсказка] {ffffff}Вы покинули зону митинга.
У Вас имеется предмет 'Эффект x4 пополнение счёта (24 часа)', который можно использовать.
Обратите внимание! Вы можете улучшить свои характеристики на поле битвы, купив списанный полицейский бронежилет на складе в Las Venturas.
Списанный бронежилет на 4 часа даст вашему персонажу +38 ед. защиты, +7 ед. к урону, +10 ед. к удаче, а также +50 макс. HP и +40 макс. брони.
Найти склад можно с помощью /GPS - Разное - Склад списанных бронежилетов.
[Информация] Продавай и покупай автомобильные номера и СИМ-карты в Лас Вентурасе! /GPS - Разное - Рынок автомобильных номеров и СИМ-карт.
[Информация] {FFFFFF}Используйте курсор чтобы выбрать тип топлива и его кол-во
[Информация] {FFFFFF}Вы можете заправить полный бак - нажав на стоимость топлива
{9ACD32}[Подсказка]{FFFFFF} Негде жить? Арендуйте номер в любом из отелей штата!
{9ACD32}[Подсказка]{FFFFFF} Проживая в отеле, Вы получаете множество бонусов, которые упростят Вашу игру
{9ACD32}[Подсказка]{FFFFFF} Подробнее: {9ACD32}/hotel
[Battle Pass]{ffffff} Доступен только играя с лаунчера ARIZONA GAMES или ARIZONA MOBILE!
[Подсказка] {ffffff}Вы можете отключить данную функцию в {ff6666}/settings - Настройки персонажа{ffffff}.
Центр обмена имущество
Проводи безопасный обмен имуществом с другими игроками в специальном центре обмена имуществом
(/GPS - Разное - Центр обмена имуществом)
Оленей можно найти в лесу Лос-Сантос, используйте огнестрельное оружие чтобы убить их.
Для выполнения задания Вам нужно устроиться на работу развозчиком продуктов и выполнить 3 любых заказа.
Обратите внимание! Устроиться на работу можно в центре занятости: {FFA500}/GPS - Важные места - Центр занятости.
Если Вы уже устроены на работу, тогда Вам нужно отправиться на стоянку развозчиков и арендовать там рабочий транспорт.
/GPS - По работе - База развозчиков продуктов
[Подсказка] {FFFFFF}Добыча на земле, беги хватай!
[Контейнеры] Не упустите возможность выиграть уникальные призы
]]

-- погода
function se.onSetWeather(id)
	actual.weather = id
	if cfg.weather.lock then
		return false
	end
end

function se.onSetPlayerTime(hour, min)
	actual.time = hour
	if cfg.time.lock then
		return false
	end
end

function se.onSetWorldTime(hour)
	actual.time = hour
	if cfg.time.lock then
		return false
	end
end

function se.onSetInterior(id)
	local result = isPlayerInWorld(id)
	if cfg.time.lock then
		setWorldTime(result and cfg.time.value or actual.time, true) 
	end
	if cfg.weather.lock then 
		setWorldWeather(result and cfg.weather.value or actual.weather, true)
	end
end

function main()
	-- информативное сообщение, что скрипт работает
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end
	sampAddChatMessage('{F48B8C}[INFO] {ffffff}Скрипт {ff7e14}"DiChat" {ffffff}готов к работе! Автор: {ff7e14}solodi {ffffff}| Версия: ' .. thisScript().version,-1)

	while not isSampAvailable() do
        wait(100)
    end

	if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end

	-- команды смены погоды
	sampRegisterChatCommand("st", setWorldTime)
	sampRegisterChatCommand("sw", setWorldWeather)
	-- регистры управления временем и погодой сервером ВКЛ/ВЫКЛ
	sampRegisterChatCommand("bt", toggleFreezeTime)
	sampRegisterChatCommand("bw", toggleFreezeWeather)
	wait(-1)
end

-- отключение частиц нагружающих буффер
require('memory').fill(0x4A125D, 0x90, 8, true)
writeMemory(0x539F00, 4, 0x0024C2, true)

-- отключение билбордов и экрана на цб
function onReceivePacket(id, bs)
    if id == 220 then
        raknetBitStreamIgnoreBits(bs, 8)
        if raknetBitStreamReadInt8(bs) == 12 then
            return false
        end
    end
end

function setWorldTime(hour, no_save)
	if tostring(hour):lower() == "off" then
		hour = actual.time
	end
	hour = tonumber(hour)
	if hour ~= nil and (hour >= 0 and hour <= 23) then
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, hour)
		raknetEmulRpcReceiveBitStream(94, bs)
		raknetDeleteBitStream(bs)
		if no_save == nil then
			cfg.time.value = hour
			ini.save(cfg, "DiClimate.ini")
		end
		return nil
	end
	sampAddChatMessage("Используйте: {EEEEEE}/st [0 - 23 или OFF]", 0xFFDD90)
end

function setWorldWeather(id, no_save)
	if tostring(id):lower() == "off" then
		id = actual.weather
	end
	id = tonumber(id)
	if id ~= nil and (id >= 0 and id <= 45) then
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, id)
		raknetEmulRpcReceiveBitStream(152, bs)
		raknetDeleteBitStream(bs)
		if no_save == nil then
			cfg.weather.value = id
			ini.save(cfg, "DiClimate.ini")
		end
		return nil
	end
	sampAddChatMessage("Используйте: {EEEEEE}/sw [0 - 45 или OFF]", 0xFFDD90)
end

function toggleFreezeTime()
	cfg.time.lock = not cfg.time.lock
	if ini.save(cfg, "DiClimate.ini") then
		local state = (cfg.time.lock and "не сможет" or "снова может")
		sampAddChatMessage("Теперь сервер " .. state .. " изменять время!", 0xFFDD90)
	end
end

function toggleFreezeWeather()
	cfg.weather.lock = not cfg.weather.lock
	if ini.save(cfg, "DiClimate.ini") then
		local state = (cfg.weather.lock and "не сможет" or "снова может")
		sampAddChatMessage("Теперь сервер " .. state .. " изменять погоду!", 0xFFDD90)
	end
end

function isPlayerInWorld(interior_id)
	local ip, port = sampGetCurrentServerAddress()
	local address = ("%s:%s"):format(ip, port)
	if address == "80.66.82.147:7777" then -- Vice City
		return (interior_id == 20)
	end
	return (interior_id == 0)
end

function se.onShowDialog(id, style, title, button1, button2, text)
    -- таблица диалогов
    local dialogSkip = {
        [26013] = 0, -- фамавто
        [26612] = 0, -- рядом стоящие буквой R
        [25194] = 1, -- фамавто без хуйни
        [7551] = 1,   -- переодеться без хуйни
        [581] = 1,    -- переодеться без хуйни
        [15330] = 0, -- скип акции х4
        [25191] = 1, -- ещё один диалог
        [15531] = 1,  -- оплата налогов с Metall Bank Card
		[26014] = 1, -- vc fam avto
		[25824] = 1 -- переодеться вс
    }

    -- проверка по id
    if dialogSkip[id] ~= nil then
        sampSendDialogResponse(id, dialogSkip[id])
        return false
    end

    -- тексты для скипа
    local textSkip = {
        ["Удача! При использовании сундука с рулеткой"] = false,
        ["Удача! При использовании платинового сундука с рулеткой"] = false,
		-- СЕМЕЙНЫЕ КВЕСТЫ
        ["Сегодня в наш город доставили невероятно дорогой суперкар."] = "{73B461}[Информация] {ffffff}Вы приняли семейный квест {ff7e14}'Перевозим провизию'{ffffff}.",
        ["На прилавках магазинов заканчивается свежая рыба!"] = "{73B461}[Информация] {ffffff}Вы приняли семейный квест {ff7e14}'Тонна рыбы'{ffffff}.",
        ["Нам срочно нужны люди которые будут заниматься охотой!"] = "{73B461}[Информация] {ffffff}Вы приняли семейный квест {ff7e14}'Охотимся'{ffffff}.",
		["Как ты наверное знаешь у нас в штате есть 5 ферм."] = "{73B461}[Информация] {ffffff}Вы приняли семейный квест {ff7e14}'Утоляем голод'{ffffff}.",
		["Ажиотаж на рынке в последнее время очень велик."] = "{73B461}[Информация] {ffffff}Вы приняли семейный квест {ff7e14}'Ответственная работа'{ffffff}.",
		["Ты же знаешь что у нас по всему штату ходят поезда?"] = "{73B461}[Информация] {ffffff}Вы приняли семейный квест {ff7e14}'Ответственная работа'{ffffff}.",
		["В последнее время правительство столкнулось с такой проблемой как недостаточность водителей автобусов,"] = "{73B461}[Информация] {ffffff}Вы приняли семейный квест {ff7e14}'Городские проблемы'{ffffff}.",
		-- ГОЛОДНАЯ ПОРА
		-- КОНФИСКАТ
		-- В РАЗРАБОТКЕ		
		["Есть тут у меня одно дело, особенное."] = "{73B461}[Информация] {ffffff}Вы приняли семейный квест {ff7e14}'Великая стройка'{ffffff}.",
		-- КВЕСТ ЦЕНТР ГЕТТО
        ["Йоу братишка, вижу ты часто гуляешь по нашим опасным улицам."] = false,
		-- ОКНО ВХОДА НА VICE CITY
        ["Мы рады видеть вас на сервере"] = false
    }

    -- проверка по тексту
    for key, message in pairs(textSkip) do
        if text:find(key) then
            sampSendDialogResponse(id, 1, 0, false)
            if message then
                sampAddChatMessage(message, -1)
            end
            return false
        end
    end
end

function se.onServerMessage(color, text)
	if text:match("^%s*$") then
        return false
    end

	-- скип всякой хуйни ненужной
	for line in string.gmatch(skip, "[^\n]+") do
		if string.find(text, line, 1, true) then
			return false
		end
	end
	-- СЕМЕЙНЫЕ КВЕСТЫ
	local messages = {
		["Для выполнения задания Вам нужно доставить груз на указанную точку."] = false,
		["Вы успешно погрузили груз на автомобиль, сейчас Вам нужно отвезти его к указанному на миникарте месту."] = "{73B461}[Информация] {ffffff}Вы погрузили груз и должны доставить его к указанному месту на миникарте.",
		["За каждый полученный урон на вашем автомобиле Вы будете терять часть дохода за перевозку ценного груза"] = "{73B461}[Информация] {ffffff}За урон машине вы теряете часть дохода, а при выходе из игры или попадании в больницу задание придется начать заново.",
		["Если Вы покинете игру или попадете в больницу, выполнение задания придется начать заново."] = false,
		["Для выполнения задания Вам нужно отправиться на автомобиле"] = false,
		["Местоположение порта в городе Лос Сантос отмечено на миникарте."] = "{73B461}[Информация] {ffffff}Для выполнения задания отправьтесь на DFT-30 в порт Лос-Сантоса (отмечен на миникарте), чтобы забрать и доставить ценный груз.",
		["Обратите внимание! Вы можете самостоятельно отправиться на рыбалку и поймать рыбу"] = false,
		["Для выполнения задания Вам нужно продать рыболову 20 любых рыб."] = "{73B461}[Информация] {ffffff}Поймайте или купите рыбу у игроков и продайте рыболову 20 рыб.",
		["Для выполнения задания Вам нужно убить 3 оленей."] = "{73B461}[Информация] {ffffff}Чтобы выполнить задание, убейте 3 оленей.",
		["Для выполнения задания Вам нужно отправиться на одну из 5 ферм и выполнить там 30 любых действий."] = "{73B461}[Информация] {ffffff}Для выполнения задания отправьтесь на частную ферму и выполните 30 любых действий.",
		["Для выполнения задания вам нужно устроиться на работу развозчиком продуктов и выполнить 3 любых заказа."] = "{73B461}[Информация] {ffffff}Чтобы выполнить задание, устройтесь развозчиком продуктов и выполните 3 любых заказа.",
		["Для выполнения задания Вам нужно устроиться на работу машиниста поезда и выполнить 3 рейса!"] = "{73B461}[Информация] {ffffff}Для выполнения задания устройтесь машинистом поезда и выполните 3 рейса.",
		["Для выполнения задания Вам нужно устроиться на работу водителя автобуса и проехать 300 чекпоинтов на любом маршруте."] = "{73B461}[Информация] {ffffff}Чтобы выполнить задание, устройтесь водителем автобуса и пройдите 300 чекпоинтов на любом маршруте.",
		-- ГОЛОДНАЯ ПОРА
		-- КОНФИСКАТ
		-- В РАЗРАБОТКЕ
		["Для выполнения задания Вам нужно подойди к пикапу и взять специальную машину на парковке возле ЖК."] = false,
		["Местоположение пикапа отмечено на миникарте."] = "{73B461}[Информация] {ffffff}Подойдите к пикапу (отмечен на миникарте) и возьмите специальную машину на парковке возле ЖК.",
		["Для выполнения задания вам нужно загрузить машину бетоном возле карьера деревни Форт Карсон."] = "{73B461}[Информация] {ffffff}Загрузите машину бетоном возле карьера в деревне Форт Карсон (местоположение отмечено на миникарте).",
		["Местоположение бетонного завода для загрузки отмечено на миникарте."] = false,
		["Вы успешно загрузили машину бетоном."] = false,
		["Осталось сделать рейсов: 1."] = "{73B461}[Информация] {ffffff}Осталось сделать рейсов: {00FFFF}1{ffffff}.",
		["Для выполнения задания Вам нужно вновь загрузить машину бетоном возле карьера деревни Форт Карсон."] = false,
		["Теперь вам нужно отвезти бетон к месту постройки новой шахты в городе Сан Фиерро и выгрузить его там."] = "{73B461}[Информация] {ffffff}Доставьте машину на стройку новой шахты в Сан Фиерро для выгрузки.", 
		["Вы успешно отказались от квеста!"] = "{73B461}[Информация] {ffffff}Вы успешно отказались от квеста."
    }

	for msg, chatMsg in pairs(messages) do
        if text:find(msg) then
            sampSendDialogResponse(id, 1, 0, false)
            if chatMsg then
                sampAddChatMessage(chatMsg, -1)
            end
            return false
        end
    end

	-- квест с оленями
	local deerLeft = string.match(text, "%[Квест] Осталось застрелить оленей: (%d+) шт.")
	if deerLeft then
		return { 0x73B461FF, string.format("{73B461}[Информация] {ffffff}Осталось застрелить оленей: {00FFFF}%s {ffffff}шт.", deerLeft) }
	end

	-- квест с действиями на ферме
	local actionsLeft = string.match(text, "%[Квест] Осталось выполнить действий на ферме: (%d+)")
	if actionsLeft then
    	return { 0x31B404FF, string.format("{31B404}[Информация] {ffffff}Осталось выполнить действий на ферме: {00FFFF}%s {ffffff}шт.", actionsLeft) }
	end

	-- квест с развозкой
	local jobLeft = string.match(text, "%[Квест] Вы успешно отвезли 1 заказ%(а%), для выполнения задания Вам осталось отвезти еще (%d+) заказ%(а%)%.")
	if jobLeft then
    	return { 0x73B461FF, string.format("{73B461}[Информация] {ffffff}Вы успешно отвезли 1 заказ, для выполнения задания Вам осталось отвезти еще {00FFFF}%s {ffffff}заказ(а).", jobLeft) }
	end

    -- скип эфиров от СМИ
    if color == 0x73B461FF and string.find(text, "^%[ News .. %]") then
		return false
	end

	-- скип офф от ареста
	if string.match(text, "> Игрок .+_.+%(.+%) вышел при попытке избежать ареста и был наказан!") then
		return false
	end

    -- /ad без лишнего
    if color == 0x73B461FF then
        if string.find(text, "Отредактировал сотрудник") then
            return false
        end

		local keywords = { 
			"Ломбард", "ломбард", "Ломбрад", "ломбрад", "Ломабрд", 
			"ломабрд", "Ломбарь", "ломбарь", "Ломборд", "ломборд", 
			"Ломбар", "ломбар", "Лобмбард", "лобмбард", "Лобмард", "лобмард" }

		-- Проверка на наличие ключевых слов
		for _, keyword in ipairs(keywords) do
			if string.find(text, keyword) then
				return false
			end
		end

        local patterns = {
            {pattern = "Объявление: (.+)%. (.+_.+)%(офф%)", prefix = "{87b650}OFF AD: {ffeadb}", suffix = "{ff9a76} "},
            {pattern = "Объявление: (.+)%. (.+_.+)%[.+] Тел%. (.+)", prefix = "{87b650}AD: {ffeadb}", suffix = "{ff9a76} T: "},
            {pattern = "Объявление: (.+)%. (.+_.+) %[.+]%. Тел: (.+)", prefix = "{87b650}AD: {ffeadb}", suffix = "{ff9a76} T: "},
            {pattern = "%[VIP]Объявление: (.+)%. (.+_.+)%[.+] Тел%. (.+)", prefix = "{FCAA4D}VIP AD: {ffeadb}", suffix = "{ff9a76} T: "},
			{pattern = "%[Реклама Бизнеса] (.+)%. Отправил: (.+_.+)%[.+]", prefix = "{FCAA4D}AD BIZ: {ffeadb}", suffix = "{ff9a76} "}
        }

		for _, p in ipairs(patterns) do
			local ad, sender, tel = string.match(text, p.pattern)
			if ad and sender then
				local message = p.prefix .. ad .. "." .. p.suffix .. (tel and tel .. ". " or "") .. sender
				sampAddChatMessage(message, -1)
				return false
			end
		end
	end

	--поздравление с апом уровня в фаме
	if text:find("%[Новости Семьи]{FFFFFF} Член семьи: .+_.+%[.+] достиг .+ уровня%. В семью начислен опыт%.") then
		lua_thread.create(function()
		  wait(1000)
		  sampSendChat("/fam С днём рождения!")
		  end)
		return text
   end

   --приветствие в семье
	if text:find("%[Семья %(Новости%)] .+_.+%[.+]:{B9C1B8} пригласил в семью нового члена: .+_.+%[.+]!") then
        lua_thread.create(function()
			wait(1000)
			sampSendChat("/fam бобро пожаловать)")
			end)
		  return text
    end

    -- действия администрации
    local adminKeywords = { " A:", "A:", "Администратор:", " Администратор:" }
    for _, keyword in ipairs(adminKeywords) do
        if string.find(text, keyword) then
            return { 0xffe066FF, text }
        end
    end

    -- редкие призы из ларцов другим игрокам будут выделяться серым
    if color == 0x31B404FF then
        local patterns = {
            "^[A-z0-9_]+ испытал удачу при",
            "%[Удача] Игрок .+_.+ открыл Ящик с секретной машиной и получил: .+%.",
            "Удача улыбнулась игроку .+_.+ при открытии '.+' и он выиграл предмет: .+",
			"Удача улыбнулась игрок .+_.+ при обмене подарков и он выиграл - '.+'!"
        }

        for _, pattern in ipairs(patterns) do
            if string.find(text, pattern) then
                return { 0xDDDDDDFF, text }
            end
        end
    end

	do -- замена цветов тегов /vr чата
		local ad_tag = "{fcaa4d}%[РЕКЛАМА]"
		local old_tag = "%[VIP ADV]"
		local keywords = { 
			"Ломбард", "ломбард", "Ломбрад", "ломбрад", "Ломабрд", 
			"ломабрд", "Ломбарь", "ломбарь", "Ломборд", "ломборд", 
			"Ломбар", "ломбар", "Лобмбард", "лобмбард", "Лобмард", "лобмард" }

		if string.find(text, old_tag) then
			text = string.gsub(text, old_tag, ad_tag)
		end

		if string.find(text, ad_tag) then
			for _, keyword in ipairs(keywords) do
				if string.find(text, keyword) then
					return false
				end
			end
			return { 0xfcaa4dFF, text }
		end

		if string.find(text, "%[VIP]") then
			return { 0xf7e980FF, text }
		end
        if string.find(text, "%[PREMIUM]") then
            return { 0xfee001FF, text }
        end

        if string.find(text, "%[FOREVER]") then
            return { 0xfebf00FF, text }
        end

		if string.find(text, "%[ADMIN]") then
			for _, keyword in ipairs(keywords) do
				if string.find(text, keyword) then
					return false
				end
			end
			return { 0xff033eFF, text }
		end
    end

	do -- информативное сообщение о том что наложен мут
		local sec = string.match(text, "^Вы заглушены. Оставшееся время заглушки (%d+) секунд")
		if sec ~= nil then
			local end_mute = os.time() + tonumber(sec)
			local get = function(count)
				local normal = count + (86400 - os.date("%H", 0) * 3600)
				if count < 3600 then
					return os.date("%M:%S", normal)
				else
				    return os.date("%H:%M:%S", normal)
				end
			end
			text = string.gsub(text, "%d+ секунд", get(end_mute - os.time()) .. " (До " .. os.date("%H:%M:%S", end_mute) .. ")")
			return { color, text }
		end
	end

	do -- окрашивание ников при разговоре в цвет клиста
		local id, message = string.match(text, "^[A-z0-9_]+%[(%d+)%] говорит:{B7AFAF} (.+)")
		if id ~= nil then
			local clist = sampGetPlayerColor(tonumber(id))
			local a, r, g, b = explode_argb(clist)
			return { join_argb(r, g, b, a), text }
		end
	end

	do -- OOC чат над головой (/b)
		local id, message = string.match(text, "^%(%( .+%[(%d+)%]: {B7AFAF}(.+){FFFFFF} %)%)$")
		id = tonumber(id)
		if id ~= nil and select(1, sampGetCharHandleBySampPlayerId(id)) then
			message = string.format("(( {B7AFAF}%s{FFFFFF} ))", message)
			if #message > 128 then message = "(( {B7AFAF}...{FFFFFF} ))" end
			setPlayerChatBubble(id, -1, 15, 6000, message)
		end
	end
end

function setPlayerChatBubble(playerId, color, dist, duration, message)
	local bs = raknetNewBitStream()
	raknetBitStreamWriteInt16(bs, playerId)
	raknetBitStreamWriteInt32(bs, color)
	raknetBitStreamWriteFloat(bs, dist)
	raknetBitStreamWriteInt32(bs, duration)
	raknetBitStreamWriteInt8(bs, #message)
	raknetBitStreamWriteString(bs, message)
    raknetEmulRpcReceiveBitStream(59, bs)
    raknetDeleteBitStream(bs)
end

function explode_argb(argb)
	local a = bit.band(bit.rshift(argb, 24), 0xFF)
	local r = bit.band(bit.rshift(argb, 16), 0xFF)
	local g = bit.band(bit.rshift(argb, 8), 0xFF)
	local b = bit.band(argb, 0xFF)
	return a, r, g, b
end

function join_argb(a, r, g, b)
    local argb = b
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))
    argb = bit.bor(argb, bit.lshift(a, 24))
    return argb
end