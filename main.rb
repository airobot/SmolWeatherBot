# coding: UTF-8

require 'telegram/bot'
require 'openssl'
require 'json'
require 'rest-client'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

TOKEN = '408696857:AAGJEzOXsisR5N24artnb2kpnTmpSra86PA'
url = 'http://temp.olegt.ru/2/'

Telegram::Bot::Client.run(TOKEN) do |bot|
	bot.listen do |message|
		case message.text
		when '/start', 'start start'
			bot.api.send_message(
			chat_id: message.chat.id,
			text: "Приветствую, #{message.from.first_name}")
		when '/temp', 'Погода в Смоленске', 'Погода', 'погода'
			resp = RestClient.get url
			temp = JSON.parse(resp)
			case temp["cloudiness"]
			when "0"
				cloud = "Ясно"
			when "1"
				cloud = "Малооблачно"
			when "2"
				cloud = "Облачно"
			when "3"
				cloud = "Пасмурно"
			end
			bot.api.send_message(
			chat_id: message.chat.id,
			text: ("Сейчас за окном #{temp['tempws']}" + "°С, #{cloud}"))
		else
			bot.api.send_message(
			chat_id: message.chat.id,
			text: "Простите, я еще не научился обрабатывать данные запросы. Вы можете написать, моему создателю, на почту - airobot67@gmail.com.\n
			Опишите проблему и скоро создатель ответить вам.")
		end
	end
end