script_name("{ff7e14}DiChat")
script_author("{ff7e14}solodi")
script_version("1.8.1")

local encoding = require 'encoding'

encoding.default = 'cp1251'
local u8 = encoding.UTF8
local function recode(u8) return encoding.UTF8:decode(u8) end

local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
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
{DFCFCF}[Подсказка] {DC4747}Чтобы открыть круговое меню для управления транспортом, нажмите {DFCFCF}CTRL
{DFCFCF}[Подсказка] {DC4747}Чтобы включить радио используйте кнопку {DFCFCF}R (/radio)
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
[Подсказка] {FFFFFF}Добыча на земле, беги хватай!
[Подсказка] {ffffff}Вы попали в зону платной парковки. Тариф указан на табличке. Припаркуйте транспорт в свободное место.
[Подсказка] {ffffff}На платной парковке ваш транспорт будет находиться в безопасности и его никто не сможет угнать.
[Подсказка] {ffffff}Вы вошли в зону митинга.
[Подсказка] {ffffff}Вы можете взять табличку для митинга на {ff0000}отмеченном пикапе{ffffff}.
[Подсказка] {ffffff}Вы покинули зону митинга.
У Вас имеется предмет 'Эффект x4 пополнение счёта (24 часа)', который можно использовать.
]]

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
end

function se.onShowDialog(id, style, title, button1, button2, text)
	-- скип диалога фамавто
	if id == 26012 then
		sampSendDialogResponse(26012, 0)
		return false
	end
	-- cкип диалога на рядом стоящих буквой R
	if id == 26611 then
		sampSendDialogResponse(26611, 0)
		return false
	end
	-- взять фамавто без хуйни
	if id == 25194 then
		sampSendDialogResponse(25194, 1)
		return false
	end
	-- скип диалога загрузки провизии ДФТ фамквест
	if text:find("Вы успешно загрузили машину провизией.") then
        sampSendDialogResponse(id, 1, 0, false)
        sampAddChatMessage("{73B461}[Информация] {ffffff}Вы успешно загрузили машину провизией.", -1)
        return false
    end
	-- скип диалога разгрузки провизии ДФТ фамквест
    if text:find("Вы успешно разгрузили машину с провизией.") then
        sampSendDialogResponse(id, 1, 0, false)
        sampAddChatMessage("{73B461}[Информация] {ffffff}Вы успешно разгрузили машину с провизией.", -1)
        return false
    end
	-- скип диалога завершения разгрузок
    if text:find("Вы успешно разгрузили нужное количество провизии для вашей семьи.") then
        sampSendDialogResponse(id, 1, 0, false)
        return false
    end
	-- скип получения мусорного предмета х4 с сундука
	if text:find ("Удача! При использовании сундука с рулеткой") then
		sampSendDialogResponse(id, 1, 0, false)
		return false
	end
	-- переодеться без хуйни
	if id == 7551 then
		sampSendDialogResponse(7551, 1)
		return false
	end
	if id == 581 then
		sampSendDialogResponse(581, 1)
		return false
	end
	-- фамквесты без хуйни
    if text:find("У меня всегда есть чем занять человека! В нашу семью нужно пополнять провизию, ибо нам не выжить.") then
        sampSendDialogResponse(id, 1, 0, false)
        sampAddChatMessage("{73B461}[Информация] {ffffff}Вы приняли семейный квест {ff7e14}'Перевозим провизию!'.", -1)
        return false
    end
	if text:find("Отправляйся в Железный порт, его ты сможешь найти с помощью GPS.") then
        sampSendDialogResponse(id, 1, 0, false)
        sampAddChatMessage("{73B461}[Информация] {ffffff}Вы приняли семейный квест {ff7e14}'Тонна рыбы!'.", -1)
        return false
    end
	if text:find("Нам срочно нужны люди которые будут заниматься охотой!.") then
        sampSendDialogResponse(id, 1, 0, false)
        sampAddChatMessage("{73B461}[Информация] {ffffff}Вы приняли семейный квест {ff7e14}'Охотимся!'.", -1)
        return false
    end
	-- скип акции х4
	if id == 15330 then
		sampSendDialogResponse(15330, 0)
		return false
	end
	-- квест центр гетто
	if text:find("Йоу братишка, вижу ты часто гуляешь по нашим опасным улицам.") then
        sampSendDialogResponse(id, 1, 0, false)
        return false
    end

	if id == 25191 then
		sampSendDialogResponse(25191, 1)
		return false
	end
	--х2 Vice City
	if text:find ("Мы ради видеть вас на сервере Vice City. Сейчас на сервере проходит акция [FA5858]X2 PayDay") then
		sampSendDialogResponse(id, 1, 0, false)
		return false
	end
end

function se.onServerMessage(color, text)
	-- скип всякой хуйни ненужной
	for line in string.gmatch(skip, "[^\n]+") do
		if string.find(text, line, 1, true) then
			return false
		end
	end

    -- скип эфиров от СМИ
    if color == 0x73B461FF and string.find(text, "^%[ News .. %]") then
		return false
	end

	-- скип офф от ареста
	if string.match(text, "> Игрок .+_.+%(.+%) вышел при попытке избежать ареста и был наказан!") then
		return false
	end

    -- скип туберкулёзников
	if string.find(text, "^[A-z0-9_]%[%d+%] очень громко кашлянул$") then
		return false
	end

    -- /ad без хуйни
	if color == 0x73B461FF then
		if string.find(text, "Отредактировал сотрудник") then
			return false
		end
		--offadd
		if text:match("Объявление: .+%. .+_.+%(офф%)") then
			local ad, sender = string.match(text, "Объявление: (.+)%. (.+_.+)%(офф%)")
			sampAddChatMessage("{87b650}OFF AD: {ffeadb}" .. ad .. ".{ff9a76} " .. sender, -1)
			return false
		end
		--73B461
		-- light
		if text:match("Объявление: .+%. .+_.+%[.+] Тел%. .+") then
			local ad, sender, tel = string.match(text, "Объявление: (.+)%. (.+_.+)%[.+] Тел%. (.+)")
			sampAddChatMessage("{87b650}AD: {ffeadb}" .. ad .. ".{ff9a76} T: " .. tel .. ". " .. sender, -1)
			return false
		end
	
		-- dark
		if text:match("Объявление: .+%. .+_.+%[.+] Тел%. .+") then
			local ad, sender, tel = string.match(text, "Объявление: (.+)%. (.+_.+)%[.+] Тел%. (.+)")
			sampAddChatMessage("{87b650}AD: {ffeadb}" .. ad .. ".{ff9a76} T: " .. tel .. ". " .. sender, -1)
			return false
		end
		
		-- ebobo
		if text:match("Объявление: .+%. .+_.+ %[.+]%. Тел: .+") then
			local ad, sender, tel = string.match(text, "Объявление: (.+)%. (.+_.+) %[.+]%. Тел: (.+)")
			sampAddChatMessage("{87b650}AD: {ffeadb}" .. ad .. ".{ff9a76} T: " .. tel .. ". " .. sender, -1)
			return false
		end
		--73B461
		-- vip
		if text:match("%[VIP]Объявление: .+%. .+_.+%[.+] Тел%. .+") then
			local ad, sender, tel = string.match(text, "%[VIP]Объявление: (.+)%. (.+_.+)%[.+] Тел%. (.+)")
			sampAddChatMessage("{FCAA4D}VIP AD: {ffeadb}" .. ad .. ".{ff9a76} T: " .. tel .. ". " .. sender, -1)
			return false
		end
		--в случае большой объявы
		if text:match("Объявление: .+%. .+_.+ %[.+]%. Тел: .+") then
			local ad, sender, tel = string.match(text, "Объявление: (.+)%. (.+_.+) %[.+]%. Тел:")
			sampAddChatMessage("{87b650}AD: {ffeadb}" .. ad .. ".{ff9a76}. " .. sender, -1)
			return false
		end
	end

	--поздравление с апом уровня в фаме
	if text:find("{FF8400}%[Новости Семьи]{FFFFFF} Член семьи: .+_.+%[.+] достиг .+ уровня%. В семью начислен опыт%.") then
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
	if string.find(text, " A:") then
		if color == -10270721 then
			return { 0xFFECA1FF, text }
		elseif color == -2686721 then
			return { 0xFF4040FF, text }
		end
	end

	if string.find(text, "Администратор:") then
		if color == -10270721 then
			return { 0xFFECA1FF, text }
		elseif color == -2686721 then
			return { 0xFF4040FF, text }
		end
	end

	if string.find(text, "A:") then
		if color == -10270721 then
			return { 0xFFECA1FF, text }
		elseif color == -2686721 then
			return { 0xFF4040FF, text }
		end
	end

	-- редкие призы из ларцов другим игрокам будут выделятся серым
	if color == 0x31B404FF and string.find(text, "^[A-z0-9_]+ испытал удачу при") then
		return { 0xDDDDDDFF, text }
	end

	if color == 0x31B404FF and string.find(text, "%[Удача] Игрок .+_.+ открыл Ящик с секретной машиной и получил: .+%.") then
		return { 0xDDDDDDFF, text }
	end

	if color == 0x31B404FF and string.find(text, "Удача улыбнулась игроку .+_.+ при открытии '.+' и он выиграл предмет: .+") then
		return { 0xDDDDDDFF, text }
	end

--[[ скип лотерейки если не надо
	if color == 0x31B404FF and string.find(text, "[Лотерейная] Купите лотерейный билет и получите возможность выиграть") then
		return { 0xDDDDDDFF, text }
	end

	if color == 0x31B404FF and string.find(text, "[Лотерейная] Игрок ^[A-z0-9_]+ получил приз") then
		return { 0xDDDDDDFF, text }
	end]]

	do -- замена цветов тегов /vr чата
		local ad_tag = "^%[?Р?Е?К?Л?А?М?А?%]?%s?"
		-- if ad_tag ~= "" then return false end -- Удаление рекламных сообщений /vr
		if string.find(text, ad_tag .. "%[VIP%]") and color == 1687547391 then
			return { 0x2FAA5BFF, text }
		end

		if string.find(text, ad_tag .. "%[PREMIUM%]") and color == -213517057 then
			return { 0xFFAA00FF, text }
		end

		if string.find(text, ad_tag .. "%[ADMIN%]") and color == -54114817 then
			return { 0xFF4040FF, text }
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